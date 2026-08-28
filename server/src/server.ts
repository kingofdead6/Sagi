import http from 'node:http';
import { createApp } from './app';
import { connectDb, disconnectDb } from './config/db';
import { env } from './config/env';
import { logger } from './config/logger';
import { createSocketServer } from './realtime/socket';
import { startSweeper, stopSweeper } from './realtime/sweeper';
import { ensureDefaultSettings, getSettings } from './modules/settings/settings.service';

async function main() {
  await connectDb();
  await ensureDefaultSettings();
  await getSettings(true);

  const app = createApp();
  const server = http.createServer(app);
  createSocketServer(server);
  startSweeper();

  server.listen(env.PORT, () => {
    logger.info(`Saji API listening on http://localhost:${env.PORT}${env.API_PREFIX}`);
  });

  const shutdown = async (signal: string) => {
    logger.info({ signal }, 'Shutting down');
    stopSweeper();
    server.close();
    await disconnectDb();
    process.exit(0);
  };

  process.on('SIGINT', () => void shutdown('SIGINT'));
  process.on('SIGTERM', () => void shutdown('SIGTERM'));
}

main().catch((err) => {
  logger.error({ err }, 'Fatal startup error');
  process.exit(1);
});
