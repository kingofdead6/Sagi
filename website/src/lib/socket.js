import { io } from 'socket.io-client';
import { useEffect, useRef } from 'react';
import { API_URL, onSessionChange, session } from './api';

/**
 * One socket for the life of the page. The server authenticates the handshake
 * with the access token and joins the socket to the user's own rooms
 * (customer:<id>, agent:<id>), so events arrive without subscribing.
 *
 * `auth` is a callback, read on every (re)connect, so a refreshed token is
 * picked up by reconnecting the same socket — handlers registered on it are
 * never orphaned the way they would be if the socket object were replaced.
 */
const socket = io(API_URL, {
  path: '/socket.io',
  autoConnect: false,
  transports: ['websocket', 'polling'],
  reconnectionDelayMax: 10_000,
  auth: (cb) => cb({ token: session.read()?.accessToken ?? '' }),
});

let currentToken = session.read()?.accessToken ?? null;
if (currentToken) socket.connect();

onSessionChange((next) => {
  const token = next?.accessToken ?? null;
  if (token === currentToken) return;
  currentToken = token;
  socket.disconnect();
  if (token) socket.connect();
});

export function getSocket() {
  return socket;
}

/** Subscribes to a server event for the component's lifetime; always calls the latest handler. */
export function useSocketEvent(event, handler) {
  const ref = useRef(handler);
  ref.current = handler;
  useEffect(() => {
    const listener = (payload) => ref.current(payload);
    socket.on(event, listener);
    return () => socket.off(event, listener);
  }, [event]);
}

/** Joins an order's room (authorised server-side) while the page is open. */
export function useOrderRoom(orderId) {
  useEffect(() => {
    if (!orderId) return undefined;
    const join = () => socket.emit('order:join', orderId);
    if (socket.connected) join();
    socket.on('connect', join); // rooms are lost on every reconnect
    return () => {
      socket.off('connect', join);
      socket.emit('order:leave', orderId);
    };
  }, [orderId]);
}

export function emitAgentLocation(point) {
  if (socket.connected) socket.emit('agent:location:update', point);
}
