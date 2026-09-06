import { Route, Routes } from 'react-router-dom';
import { AuthProvider } from './auth/AuthContext';
import RequireAdmin from './auth/RequireAdmin';
import AdminShell from './components/AdminShell';
import LoginPage from './pages/LoginPage';
import DashboardPage from './pages/DashboardPage';
import OrdersPage from './pages/OrdersPage';
import CategoriesPage from './pages/CategoriesPage';
import VendorsPage from './pages/VendorsPage';
import VendorFormPage from './pages/VendorFormPage';
import ProductsPage from './pages/ProductsPage';
import OffersPage from './pages/OffersPage';
import VouchersPage from './pages/VouchersPage';
import AgentsPage from './pages/AgentsPage';
import CustomersPage from './pages/CustomersPage';
import AnalyticsPage from './pages/AnalyticsPage';
import SettingsPage from './pages/SettingsPage';

export default function AdminApp() {
  return (
    <AuthProvider>
      <Routes>
        <Route path="login" element={<LoginPage />} />
        <Route
          element={
            <RequireAdmin>
              <AdminShell />
            </RequireAdmin>
          }
        >
          <Route index element={<DashboardPage />} />
          <Route path="orders" element={<OrdersPage />} />
          <Route path="categories" element={<CategoriesPage />} />
          <Route path="vendors" element={<VendorsPage />} />
          <Route path="vendors/new" element={<VendorFormPage />} />
          <Route path="vendors/:id" element={<VendorFormPage />} />
          <Route path="products" element={<ProductsPage />} />
          <Route path="offers" element={<OffersPage />} />
          <Route path="vouchers" element={<VouchersPage />} />
          <Route path="agents" element={<AgentsPage />} />
          <Route path="customers" element={<CustomersPage />} />
          <Route path="analytics" element={<AnalyticsPage />} />
          <Route path="settings" element={<SettingsPage />} />
        </Route>
      </Routes>
    </AuthProvider>
  );
}
