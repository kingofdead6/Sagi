import { messaging } from '../config/firebase';
import { logger } from '../config/logger';
import { User } from '../modules/users/user.model';

export interface PushMessage {
  title: string;
  body: string;
  data?: Record<string, string>;
  /** Agent offers ring loudly and use an Android full-screen intent. */
  highPriority?: boolean;
}

/**
 * Sends to every device registered for a user and prunes tokens the FCM
 * backend reports as dead.
 */
export async function pushToUser(userId: string, message: PushMessage): Promise<void> {
  const user = await User.findById(userId).select('fcmTokens').lean();
  const tokens = (user?.fcmTokens ?? []).map((t) => t.token).filter(Boolean);
  if (!tokens.length) return;

  const client = messaging();
  if (!client) {
    logger.info({ userId, title: message.title }, 'Push (firebase disabled)');
    return;
  }

  try {
    const response = await client.sendEachForMulticast({
      tokens,
      notification: { title: message.title, body: message.body },
      data: message.data ?? {},
      android: {
        priority: message.highPriority ? 'high' : 'normal',
        notification: {
          channelId: message.highPriority ? 'saji_offers' : 'saji_orders',
          sound: 'default',
          ...(message.highPriority ? { visibility: 'public' as const } : {}),
        },
      },
      apns: {
        payload: { aps: { sound: 'default', contentAvailable: true } },
      },
    });

    const dead: string[] = [];
    response.responses.forEach((r, i) => {
      const code = r.error?.code;
      if (
        code === 'messaging/registration-token-not-registered' ||
        code === 'messaging/invalid-registration-token'
      ) {
        const token = tokens[i];
        if (token) dead.push(token);
      }
    });
    if (dead.length) {
      await User.updateOne({ _id: userId }, { $pull: { fcmTokens: { token: { $in: dead } } } });
      logger.info({ userId, pruned: dead.length }, 'Pruned dead FCM tokens');
    }
  } catch (err) {
    logger.warn({ err, userId }, 'Push send failed');
  }
}

export async function pushToRole(role: 'admin', message: PushMessage): Promise<void> {
  const users = await User.find({ role, isActive: true }).select('_id').lean();
  await Promise.all(users.map((u) => pushToUser(String(u._id), message)));
}
