import { Router } from 'express';
import { requireAuth, requireRole } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import * as ctrl from './order.controller';
import {
  cancelOrderSchema,
  createOrderSchema,
  idParams,
  listOrdersQuerySchema,
  quoteSchema,
  ratingSchema,
} from './order.schema';

export const orderRouter = Router();

orderRouter.use(requireAuth);

orderRouter.post('/quote', requireRole('customer', 'admin'), validate({ body: quoteSchema }), ctrl.quoteCtrl);
orderRouter.post('/', requireRole('customer'), validate({ body: createOrderSchema }), ctrl.createOrderCtrl);
orderRouter.get('/', requireRole('customer'), validate({ query: listOrdersQuerySchema }), ctrl.myOrdersCtrl);
orderRouter.get('/reorderable', requireRole('customer'), ctrl.reorderableCtrl);
orderRouter.get('/:id', validate({ params: idParams }), ctrl.getOrderCtrl);
orderRouter.patch(
  '/:id/cancel',
  requireRole('customer'),
  validate({ params: idParams, body: cancelOrderSchema }),
  ctrl.cancelOrderCtrl,
);
orderRouter.post(
  '/:id/rating',
  requireRole('customer'),
  validate({ params: idParams, body: ratingSchema }),
  ctrl.rateOrderCtrl,
);
