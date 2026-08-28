import type { Server } from 'socket.io';
import { rooms, SOCKET_EVENTS } from './events';
import { logger } from '../config/logger';

let io: Server | null = null;

export function bindIo(server: Server): void {
  io = server;
}

export function getIo(): Server | null {
  return io;
}

function emit(room: string, event: string, payload: unknown): void {
  if (!io) {
    logger.debug({ room, event }, 'Socket emit skipped — no io bound');
    return;
  }
  io.to(room).emit(event, payload);
}

export const realtime = {
  orderNew(order: unknown) {
    emit(rooms.admin, SOCKET_EVENTS.orderNew, order);
  },

  orderStatus(orderId: string, customerId: string, payload: unknown) {
    emit(rooms.order(orderId), SOCKET_EVENTS.orderStatus, payload);
    emit(rooms.customer(customerId), SOCKET_EVENTS.orderStatus, payload);
    emit(rooms.admin, SOCKET_EVENTS.orderStatus, payload);
  },

  orderAssigned(agentId: string, payload: unknown) {
    emit(rooms.agent(agentId), SOCKET_EVENTS.orderAssigned, payload);
  },

  orderLate(payload: unknown) {
    emit(rooms.admin, SOCKET_EVENTS.orderLate, payload);
  },

  /** Admin always sees agents; the customer only while their order is en route. */
  agentLocation(payload: { agentId: string; lat: number; lng: number; orderId?: string | null; customerId?: string | null }) {
    emit(rooms.admin, SOCKET_EVENTS.agentLocation, payload);
    if (payload.orderId) emit(rooms.order(payload.orderId), SOCKET_EVENTS.agentLocation, payload);
    if (payload.customerId) {
      emit(rooms.customer(payload.customerId), SOCKET_EVENTS.agentLocation, payload);
    }
  },

  agentStatus(payload: unknown) {
    emit(rooms.admin, SOCKET_EVENTS.agentStatus, payload);
  },
};
