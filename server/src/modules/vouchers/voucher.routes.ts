import { Router } from 'express';
import { Types } from 'mongoose';
import { requireAuth, requireRole } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { asyncHandler } from '../../utils/asyncHandler';
import { ok } from '../../utils/response';
import { validateVoucherForBasket } from '../orders/pricing.service';
import { Voucher, VoucherRedemption } from './voucher.model';
import { validateVoucherSchema } from '../orders/order.schema';
import { ApiError } from '../../utils/ApiError';

export const voucherRouter = Router();

/**
 * The vouchers a customer can actually still use, for the coupons screen.
 *
 * Mirrors `evaluateVoucher`: active, inside its window, quota left, and not
 * already spent by this user. Anything failing those is simply absent rather
 * than listed as unusable.
 */
voucherRouter.get(
  '/mine',
  requireAuth,
  requireRole('customer', 'admin'),
  asyncHandler(async (req, res) => {
    const now = new Date();
    const candidates = await Voucher.find({
      isActive: true,
      $and: [
        { $or: [{ startsAt: null }, { startsAt: { $lte: now } }] },
        { $or: [{ endsAt: null }, { endsAt: { $gte: now } }] },
        { $or: [{ maxUses: 0 }, { $expr: { $lt: ['$usedCount', '$maxUses'] } }] },
      ],
    })
      .sort({ createdAt: -1 })
      .lean();

    if (candidates.length === 0) return ok(res, []);

    // One query for this user's redemptions rather than one per voucher.
    const redemptions = await VoucherRedemption.aggregate<{ _id: unknown; count: number }>([
      // aggregate does not cast strings to ObjectId the way find() does.
      {
        $match: {
          user: new Types.ObjectId(req.user!.sub),
          voucher: { $in: candidates.map((v) => v._id) },
        },
      },
      { $group: { _id: '$voucher', count: { $sum: 1 } } },
    ]);
    const usedByUser = new Map(redemptions.map((r) => [String(r._id), r.count]));

    const available = candidates.filter((v) => {
      if (!v.perUserLimit || v.perUserLimit <= 0) return true;
      return (usedByUser.get(String(v._id)) ?? 0) < v.perUserLimit;
    });

    return ok(
      res,
      available.map((v) => ({
        id: String(v._id),
        code: v.code,
        type: v.type,
        value: v.value,
        minOrderCentimes: v.minOrderCentimes,
        endsAt: v.endsAt ?? null,
      })),
    );
  }),
);

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
