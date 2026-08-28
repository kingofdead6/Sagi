import { Router } from 'express';
import { z } from 'zod';
import { requireAuth } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { asyncHandler } from '../../utils/asyncHandler';
import { created, ok } from '../../utils/response';
import { Address } from './address.model';
import { User } from '../users/user.model';
import { ApiError } from '../../utils/ApiError';
import { idParams } from '../orders/order.schema';
import { point } from '../../utils/geo';

const addressBody = z
  .object({
    label: z.string().trim().min(1).max(30).default('المنزل'),
    wilaya: z.string().trim().min(2).max(60),
    commune: z.string().trim().min(2).max(60),
    street: z.string().trim().min(2).max(160),
    notes: z.string().trim().max(200).optional(),
    lat: z.number().min(-90).max(90),
    lng: z.number().min(-180).max(180),
    isDefault: z.boolean().default(false),
  })
  .strict();

export const addressRouter = Router();
addressRouter.use(requireAuth);

/** Makes one address the user's default and clears the flag on the rest. */
async function setDefault(userId: string, addressId: string) {
  await Address.updateMany({ user: userId }, { $set: { isDefault: false } });
  await Address.updateOne({ _id: addressId, user: userId }, { $set: { isDefault: true } });
  await User.updateOne({ _id: userId }, { $set: { defaultAddress: addressId } });
}

addressRouter.get(
  '/',
  asyncHandler(async (req, res) => {
    const items = await Address.find({ user: req.user!.sub }).sort({ isDefault: -1, createdAt: -1 });
    return ok(res, items.map((a) => a.toJSON()));
  }),
);

addressRouter.post(
  '/',
  validate({ body: addressBody }),
  asyncHandler(async (req, res) => {
    const { lat, lng, isDefault, ...rest } = req.body;
    const count = await Address.countDocuments({ user: req.user!.sub });
    const address = await Address.create({
      ...rest,
      user: req.user!.sub,
      location: point(lng, lat),
      isDefault: false,
    });
    if (isDefault || count === 0) await setDefault(req.user!.sub, String(address._id));
    const fresh = await Address.findById(address._id);
    return created(res, fresh!.toJSON(), 'تمت إضافة العنوان');
  }),
);

addressRouter.patch(
  '/:id',
  validate({ params: idParams, body: addressBody.partial() }),
  asyncHandler(async (req, res) => {
    const { lat, lng, isDefault, ...rest } = req.body;
    const update: Record<string, unknown> = { ...rest };
    if (lat !== undefined && lng !== undefined) update.location = point(lng, lat);

    const address = await Address.findOneAndUpdate(
      { _id: req.params.id, user: req.user!.sub },
      { $set: update },
      { new: true },
    );
    if (!address) throw ApiError.notFound('العنوان غير موجود');
    if (isDefault) await setDefault(req.user!.sub, String(address._id));
    return ok(res, (await Address.findById(address._id))!.toJSON(), 'تم تحديث العنوان');
  }),
);

addressRouter.patch(
  '/:id/default',
  validate({ params: idParams }),
  asyncHandler(async (req, res) => {
    const exists = await Address.exists({ _id: req.params.id, user: req.user!.sub });
    if (!exists) throw ApiError.notFound('العنوان غير موجود');
    await setDefault(req.user!.sub, req.params.id);
    return ok(res, (await Address.findById(req.params.id))!.toJSON());
  }),
);

addressRouter.delete(
  '/:id',
  validate({ params: idParams }),
  asyncHandler(async (req, res) => {
    const address = await Address.findOneAndDelete({ _id: req.params.id, user: req.user!.sub });
    if (!address) throw ApiError.notFound('العنوان غير موجود');
    if (address.isDefault) {
      const next = await Address.findOne({ user: req.user!.sub }).sort({ createdAt: -1 });
      if (next) await setDefault(req.user!.sub, String(next._id));
      else await User.updateOne({ _id: req.user!.sub }, { $set: { defaultAddress: null } });
    }
    return ok(res, null, 'تم حذف العنوان');
  }),
);
