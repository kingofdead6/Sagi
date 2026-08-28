import admin from 'firebase-admin';
import { env } from './env';
import { logger } from './logger';

let app: admin.app.App | null = null;

if (env.firebaseEnabled) {
  try {
    app = admin.initializeApp({
      credential: admin.credential.cert({
        projectId: env.FIREBASE_PROJECT_ID,
        clientEmail: env.FIREBASE_CLIENT_EMAIL,
        privateKey: env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
      }),
    });
  } catch (err) {
    logger.error({ err }, 'Failed to initialise firebase-admin');
  }
} else {
  logger.warn('Firebase is not configured — push notifications are logged instead of sent.');
}

export const messaging = () => (app ? admin.messaging(app) : null);
