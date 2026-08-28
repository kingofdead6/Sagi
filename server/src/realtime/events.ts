/** Server -> client socket event names (§7). */
export const SOCKET_EVENTS = {
  orderNew: 'order:new',
  orderStatus: 'order:status',
  orderAssigned: 'order:assigned',
  orderLate: 'order:late',
  agentLocation: 'agent:location',
  agentStatus: 'agent:status',
} as const;

export const CLIENT_EVENTS = {
  agentLocationUpdate: 'agent:location:update',
  joinOrder: 'order:join',
  leaveOrder: 'order:leave',
} as const;

export const rooms = {
  admin: 'admin',
  agent: (id: string) => `agent:${id}`,
  order: (id: string) => `order:${id}`,
  customer: (id: string) => `customer:${id}`,
};
