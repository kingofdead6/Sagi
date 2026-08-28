import { Router } from 'express';
import { validate } from '../../middleware/validate';
import { asyncHandler } from '../../utils/asyncHandler';
import { ok } from '../../utils/response';
import * as service from './vendor.service';
import { vendorGetQuerySchema, vendorListQuerySchema } from './vendor.schema';
import { idParams } from '../orders/order.schema';

export const vendorRouter = Router();

vendorRouter.get(
  '/',
  validate({ query: vendorListQuerySchema }),
  asyncHandler(async (req, res) => ok(res, await service.listVendors(req.query as never))),
);

vendorRouter.get(
  '/:id',
  validate({ params: idParams, query: vendorGetQuerySchema }),
  asyncHandler(async (req, res) => {
    const { lat, lng } = req.query as unknown as { lat?: number; lng?: number };
    const origin = lat !== undefined && lng !== undefined ? { lat, lng } : null;
    return ok(res, await service.getVendor(req.params.id, origin));
  }),
);

vendorRouter.get(
  '/:id/menu',
  validate({ params: idParams }),
  asyncHandler(async (req, res) => ok(res, await service.getMenu(req.params.id))),
);
