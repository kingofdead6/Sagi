import express, { type Express } from 'express';
import helmet from 'helmet';
import cors from 'cors';
import compression from 'compression';
import pinoHttp from 'pino-http';

import { env } from './config/env';
import { logger } from './config/logger';
import { errorHandler, notFoundHandler } from './middleware/error';
import { mongoSanitize } from './middleware/sanitize';
import { generalLimiter } from './middleware/rateLimit';

import { authRouter } from './modules/auth/auth.routes';
import { addressRouter } from './modules/addresses/address.routes';
import { categoryRouter } from './modules/categories/category.routes';
import { vendorRouter } from './modules/vendors/vendor.routes';
import { productRouter } from './modules/products/product.routes';
import { offerRouter } from './modules/offers/offer.routes';
import { voucherRouter } from './modules/vouchers/voucher.routes';
import { vendorPortalRouter } from './modules/vendors/portal.routes';
import { orderRouter } from './modules/orders/order.routes';
import { agentRouter } from './modules/agents/agent.routes';
import { adminRouter } from './modules/admin/admin.routes';
import { uploadRouter } from './modules/uploads/upload.routes';

export function createApp(): Express {
  const app = express();

  app.set('trust proxy', 1);
  app.use(helmet({ crossOriginResourcePolicy: { policy: 'cross-origin' } }));
  app.use(
    cors({
      origin: env.corsOrigins.includes('*') ? true : env.corsOrigins,
      credentials: true,
    }),
  );
  app.use(compression());
  app.use(express.json({ limit: '1mb' }));
  app.use(express.urlencoded({ extended: true, limit: '1mb' }));
  app.use(mongoSanitize);
  if (!env.isTest) app.use(pinoHttp({ logger }));
  app.use(generalLimiter);

  app.get('/health', (_req, res) => {
    res.json({ success: true, data: { status: 'ok', uptime: process.uptime() } });
  });

  const api = express.Router();
  api.use('/auth', authRouter);
  api.use('/addresses', addressRouter);
  api.use('/categories', categoryRouter);
  api.use('/vendors', vendorRouter);
  api.use('/products', productRouter);
  api.use('/offers', offerRouter);
  api.use('/vouchers', voucherRouter);
  api.use('/orders', orderRouter);
  api.use('/agent', agentRouter);
  // The shop owner's own portal: their menu and nothing else.
  api.use('/portal', vendorPortalRouter);
  api.use('/admin', adminRouter);
  api.use('/uploads', uploadRouter);

  app.use(env.API_PREFIX, api);

  app.use(notFoundHandler);
  app.use(errorHandler);

  return app;
}
