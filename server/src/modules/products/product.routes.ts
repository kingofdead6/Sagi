import { Router } from 'express';
import { validate } from '../../middleware/validate';
import { asyncHandler } from '../../utils/asyncHandler';
import { ok } from '../../utils/response';
import { Product } from './product.model';
import { ApiError } from '../../utils/ApiError';
import { idParams } from '../orders/order.schema';

export const productRouter = Router();

productRouter.get(
  '/:id',
  validate({ params: idParams }),
  asyncHandler(async (req, res) => {
    const product = await Product.findById(req.params.id).populate({
      path: 'vendor',
      select: 'name slug logo isOpen deliveryFeeCentimes prepTimeMin prepTimeMax',
    });
    if (!product) throw ApiError.notFound('المنتج غير موجود');
    return ok(res, product.toJSON());
  }),
);
