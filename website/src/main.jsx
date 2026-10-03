import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import App from './App';
import { I18nProvider } from './state/i18n';
import { AuthProvider } from './state/auth';
import { CartProvider } from './state/cart';
import { ToastProvider } from './state/toast';
import { LocationProvider } from './state/location';
import './index.css';

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <BrowserRouter>
      <I18nProvider>
        <ToastProvider>
          <AuthProvider>
            <LocationProvider>
              <CartProvider>
                <App />
              </CartProvider>
            </LocationProvider>
          </AuthProvider>
        </ToastProvider>
      </I18nProvider>
    </BrowserRouter>
  </StrictMode>,
);
