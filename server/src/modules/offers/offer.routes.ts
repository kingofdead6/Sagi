import { Router } from 'express';
import { asyncHandler } from '../../utils/asyncHandler';
import { ok } from '../../utils/response';
import { Offer } from './offer.model';

export const offerRouter = Router();

/** Offers flagged for the customer home carousel, currently in their window. */
offerRouter.get(
  '/home',
  asyncHandler(async (_req, res) => {
    const now = new Date();
    const offers = await Offer.find({
      isActive: true,
      showOnHome: true,
      $and: [
        { $or: [{ startsAt: null }, { startsAt: { $lte: now } }] },
        { $or: [{ endsAt: null }, { endsAt: { $gte: now } }] },
      ],
    })
      .sort({ sortOrder: 1, createdAt: -1 })
      .populate({ path: 'vendor', select: 'name slug logo' })
      .limit(10);
    return ok(res, offers.map((o) => o.toJSON()));
  }),
);
