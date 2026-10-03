/** Mirrors server/src/modules/orders/order.state.ts. */
export const ACTIVE = [
  'pending', 'confirmed', 'sent_to_vendor', 'preparing', 'ready',
  'assigned', 'accepted', 'picked_up', 'on_the_way',
];
export const DONE = ['delivered', 'cancelled'];

/**
 * The customer stepper collapses the eleven internal states into five the
 * customer actually cares about — the same grouping the app shows.
 */
export const STEPS = ['pending', 'confirmed', 'preparing', 'on_the_way', 'delivered'];

const STEP_OF = {
  pending: 0,
  confirmed: 1,
  sent_to_vendor: 2,
  preparing: 2,
  ready: 2,
  assigned: 2,
  accepted: 2,
  picked_up: 3,
  on_the_way: 3,
  delivered: 4,
};

export function stepIndex(status) {
  return STEP_OF[status] ?? 0;
}

export function isActive(status) {
  return ACTIVE.includes(status);
}

export const TONE = {
  pending: 'tangerine',
  confirmed: 'leaf',
  sent_to_vendor: 'leaf',
  preparing: 'leaf',
  ready: 'leaf',
  assigned: 'forest',
  accepted: 'forest',
  picked_up: 'forest',
  on_the_way: 'forest',
  delivered: 'leaf',
  cancelled: 'tomato',
};
