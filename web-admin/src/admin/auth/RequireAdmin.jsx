import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from './AuthContext';
import { PageLoader } from '../components/ui';

export default function RequireAdmin({ children }) {
  const { user, loading } = useAuth();
  const location = useLocation();

  if (loading) return <PageLoader />;
  if (!user) return <Navigate to="/login" state={{ from: location }} replace />;
  return children;
}
