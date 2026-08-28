import { Router } from 'express';
import { requireAuth, requireRole } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { asyncHandler } from '../../utils/asyncHandler';
import { ok } from '../../utils/response';
import { validateVoucherForBasket } from '../orders/pricing.service';
import { validateVoucherSchema } from '../orders/order.schema';
import { ApiError } from '../../utils/ApiError';

export const voucherRouter = Router();

voucherRouter.post(
  '/validate',
  requireAuth,
  requireRole('customer', 'admin'),
  validate({ body: validateVoucherSchema }),
  asyncHandler(async (req, res) => {
    const { code, subtotalCentimes, deliveryFeeCentimes } = req.body;
    const result = await validateVoucherForBasket(
      code,
      req.user!.sub,
      subtotalCentimes,
      deliveryFeeCentimes,
    );
    if (result.error) throw ApiError.badRequest(result.error);
    return ok(res, {
      code: result.voucher!.code,
      type: result.voucher!.type,
      value: result.voucher!.value,
      discountCentimes: result.discountCentimes,
    });
  }),
);
