import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: { port: 5175 },
  build: {
    // Leaflet and framer-motion are the heavy pieces; keep them out of the
    // entry chunk so the home page paints before the map code arrives.
    rollupOptions: {
      output: {
        manualChunks: {
          motion: ['framer-motion'],
          map: ['leaflet', 'react-leaflet'],
          vendor: ['react', 'react-dom', 'react-router-dom', 'axios', 'socket.io-client'],
        },
      },
    },
  },
});
