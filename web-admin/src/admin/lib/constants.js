export const ORDER_STATUSES = [
  'pending',
  'confirmed',
  'sent_to_vendor',
  'preparing',
  'ready',
  'assigned',
  'accepted',
  'picked_up',
  'on_the_way',
  'delivered',
  'cancelled',
];

export const ORDER_STATUS_LABELS = {
  pending: 'قيد الانتظار',
  confirmed: 'مؤكد',
  sent_to_vendor: 'أُرسل للمتجر',
  preparing: 'قيد التحضير',
  ready: 'جاهز',
  assigned: 'تم إسناده',
  accepted: 'قبله السائق',
  picked_up: 'تم الاستلام',
  on_the_way: 'في الطريق',
  delivered: 'تم التوصيل',
  cancelled: 'ملغى',
};

export const ALLOWED_TRANSITIONS = {
  pending: ['confirmed', 'cancelled'],
  confirmed: ['sent_to_vendor', 'cancelled'],
  sent_to_vendor: ['preparing', 'cancelled'],
  preparing: ['ready', 'cancelled'],
  ready: ['assigned', 'cancelled'],
  assigned: ['accepted', 'ready', 'cancelled'],
  accepted: ['picked_up', 'cancelled'],
  picked_up: ['on_the_way', 'cancelled'],
  on_the_way: ['delivered', 'cancelled'],
  delivered: [],
  cancelled: [],
};

export const PAYMENT_METHODS = ['cash', 'electronic'];
export const PAYMENT_LABELS = { cash: 'نقداً', electronic: 'إلكتروني' };

export const DELIVERY_TYPES = ['normal', 'vip'];
export const DELIVERY_LABELS = { normal: 'عادي', vip: 'VIP' };

export const OFFER_TYPES = ['percentage', 'fixed', 'freeDelivery', 'bundle'];
export const OFFER_TYPE_LABELS = {
  percentage: 'نسبة مئوية',
  fixed: 'مبلغ ثابت',
  freeDelivery: 'توصيل مجاني',
  bundle: 'باقة',
};

export const VOUCHER_TYPES = ['percentage', 'fixed', 'freeDelivery'];
export const VOUCHER_TYPE_LABELS = {
  percentage: 'نسبة مئوية',
  fixed: 'مبلغ ثابت',
  freeDelivery: 'توصيل مجاني',
};

/** Centimes (server currency unit) <-> display DA. */
export function centimesToDa(c) {
  return (Number(c || 0) / 100).toFixed(2);
}

export function daToCentimes(da) {
  return Math.round(Number(da || 0) * 100);
}
