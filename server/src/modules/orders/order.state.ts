import type { Role } from '../users/user.model';

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
] as const;

export type OrderStatus = (typeof ORDER_STATUSES)[number];

export const TERMINAL_STATUSES: readonly OrderStatus[] = ['delivered', 'cancelled'];

/** The single source of truth for the order lifecycle (§6). */
export const ALLOWED: Record<OrderStatus, OrderStatus[]> = {
  pending: ['confirmed', 'cancelled'],
  confirmed: ['sent_to_vendor', 'cancelled'],
  sent_to_vendor: ['preparing', 'cancelled'],
  preparing: ['ready', 'cancelled'],
  ready: ['assigned', 'cancelled'],
  // A rejected/expired assignment sends the order back to `ready`.
  assigned: ['accepted', 'ready', 'cancelled'],
  accepted: ['picked_up', 'cancelled'],
  picked_up: ['on_the_way', 'cancelled'],
  on_the_way: ['delivered', 'cancelled'],
  delivered: [],
  cancelled: [],
};

export type Transition = `${OrderStatus}->${OrderStatus}`;

/** Who may perform each transition. Enforced on EVERY status write. */
export const ACTOR: Record<Transition, Role[]> = {
  'pending->confirmed': ['admin'],
  'pending->cancelled': ['admin', 'customer'],
  'confirmed->sent_to_vendor': ['admin'],
  'confirmed->cancelled': ['admin'],
  'sent_to_vendor->preparing': ['admin'],
  'sent_to_vendor->cancelled': ['admin'],
  'preparing->ready': ['admin'],
  'preparing->cancelled': ['admin'],
  'ready->assigned': ['admin'],
  'ready->cancelled': ['admin'],
  'assigned->accepted': ['agent'],
  'assigned->ready': ['agent', 'admin'], // reject / expiry returns it to the pool
  'assigned->cancelled': ['admin'],
  'accepted->picked_up': ['agent'],
  'accepted->cancelled': ['admin'],
  'picked_up->on_the_way': ['agent'],
  'picked_up->cancelled': ['admin'],
  'on_the_way->delivered': ['agent'],
  'on_the_way->cancelled': ['admin'],
} as Record<Transition, Role[]>;

export function isTerminal(status: OrderStatus): boolean {
  return TERMINAL_STATUSES.includes(status);
}

export function canTransition(from: OrderStatus, to: OrderStatus): boolean {
  return ALLOWED[from]?.includes(to) ?? false;
}

export function actorAllowed(from: OrderStatus, to: OrderStatus, role: Role): boolean {
  const roles = ACTOR[`${from}->${to}` as Transition];
  return Array.isArray(roles) && roles.includes(role);
}

/** Statuses whose UI badge is "live" for the customer tracking stepper. */
export const CUSTOMER_TRACKING_STEPS: OrderStatus[] = [
  'pending',
  'confirmed',
  'preparing',
  'on_the_way',
  'delivered',
];
