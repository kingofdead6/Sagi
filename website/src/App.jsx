import { Suspense, lazy } from 'react';
import { Navigate, Route, Routes, useLocation } from 'react-router-dom';
import { AnimatePresence, MotionConfig, motion } from 'framer-motion';
import { FlyLayer, Footer, Navbar, ScrollToTop, TabBar } from './components/Layout';
import { CartDrawer } from './components/CartDrawer';
import { Spinner } from './components/ui';
import { homeFor, useAuth } from './state/auth';
import { OrderNotifier } from './pages/OrderNotifier';

const Home = lazy(() => import('./pages/Home'));
const Stores = lazy(() => import('./pages/Stores'));
const Store = lazy(() => import('./pages/Store'));
const Checkout = lazy(() => import('./pages/Checkout'));
const OrderSuccess = lazy(() => import('./pages/OrderSuccess'));
const Orders = lazy(() => import('./pages/Orders'));
const OrderDetail = lazy(() => import('./pages/OrderDetail'));
const Account = lazy(() => import('./pages/Account'));
const Login = lazy(() => import('./pages/Auth').then((m) => ({ default: m.Login })));
const Register = lazy(() => import('./pages/Auth').then((m) => ({ default: m.Register })));
const Driver = lazy(() => import('./pages/Driver'));
const Portal = lazy(() => import('./pages/Portal'));
const AdminGate = lazy(() => import('./pages/AdminGate'));
const NotFound = lazy(() => import('./pages/NotFound'));

/** Signed-in only; optionally limited to some roles (others go to their own home). */
function Guard({ roles, children }) {
  const { isAuthed, role } = useAuth();
  const location = useLocation();
  if (!isAuthed) return <Navigate to="/login" replace state={{ from: location.pathname + location.search }} />;
  if (roles && !roles.includes(role)) return <Navigate to={homeFor(role)} replace />;
  return children;
}

/** Customer screens stay browsable for guests, but staff are sent to their hub. */
function CustomerOnly({ children }) {
  const { role } = useAuth();
  if (role && role !== 'customer') return <Navigate to={homeFor(role)} replace />;
  return children;
}

function Page({ children }) {
  return (
    <motion.main
      initial={{ opacity: 0, y: 18 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -10, transition: { duration: 0.18 } }}
      transition={{ duration: 0.45, ease: [0.16, 1, 0.3, 1] }}
      className="min-h-[70vh]"
    >
      {children}
    </motion.main>
  );
}

function Loading() {
  return (
    <div className="grid min-h-[60vh] place-items-center text-forest">
      <Spinner className="h-9 w-9" />
    </div>
  );
}

export default function App() {
  const location = useLocation();
  // Hubs with their own tabs (account, driver, portal) key on their root so a
  // tab switch inside them does not replay the whole-page transition.
  const segments = location.pathname.split('/');
  const key = ['account', 'driver', 'portal'].includes(segments[1])
    ? `/${segments[1]}`
    : segments.slice(0, 3).join('/');
  return (
    <MotionConfig reducedMotion="user">
      <ScrollToTop />
      <Navbar />
      <Suspense fallback={<Loading />}>
        <AnimatePresence mode="wait">
          <Routes location={location} key={key}>
            <Route path="/" element={<CustomerOnly><Page><Home /></Page></CustomerOnly>} />
            <Route path="/stores" element={<CustomerOnly><Page><Stores /></Page></CustomerOnly>} />
            <Route path="/stores/:id" element={<CustomerOnly><Page><Store /></Page></CustomerOnly>} />
            <Route path="/checkout" element={<Guard roles={['customer']}><Page><Checkout /></Page></Guard>} />
            <Route path="/orders/:id/success" element={<Guard roles={['customer']}><Page><OrderSuccess /></Page></Guard>} />
            <Route path="/orders" element={<Guard roles={['customer']}><Page><Orders /></Page></Guard>} />
            <Route path="/orders/:id" element={<Guard roles={['customer']}><Page><OrderDetail /></Page></Guard>} />
            <Route path="/account/*" element={<Guard><Page><Account /></Page></Guard>} />
            <Route path="/login" element={<Page><Login /></Page>} />
            <Route path="/register" element={<Page><Register /></Page>} />
            <Route path="/driver/*" element={<Guard roles={['agent']}><Page><Driver /></Page></Guard>} />
            <Route path="/portal/*" element={<Guard roles={['vendor']}><Page><Portal /></Page></Guard>} />
            <Route path="/admin" element={<Guard roles={['admin']}><Page><AdminGate /></Page></Guard>} />
            <Route path="*" element={<Page><NotFound /></Page>} />
          </Routes>
        </AnimatePresence>
      </Suspense>
      <Footer />
      <TabBar />
      <CartDrawer />
      <FlyLayer />
      <OrderNotifier />
    </MotionConfig>
  );
}
