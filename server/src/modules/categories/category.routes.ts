import { Router } from 'express';
import { Category } from './category.model';
import { asyncHandler } from '../../utils/asyncHandler';
import { ok } from '../../utils/response';

export const categoryRouter = Router();

categoryRouter.get(
  '/',
  asyncHandler(async (_req, res) => {
    const items = await Category.find({ isActive: true }).sort({ sortOrder: 1, nameAr: 1 });
    return ok(res, items.map((c) => c.toJSON()));
  }),
);
