import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  // Relative asset paths — required so the built app loads correctly from
  // Electron's file:// origin, not just an HTTP server.
  base: './',
  server: {
    port: 5174,
  },
});
