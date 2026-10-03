# Saji — website

The full Saji experience in the browser, talking to the same `/api/v1` backend as the mobile app. One site, three roles:

| Who | Where | What they can do |
| --- | --- | --- |
| Customer (and guests) | `/`, `/stores`, `/stores/:id` | Browse categories, offers and stores; search, filter (open now, has deals) and sort (featured, nearest, fastest, top rated); open a menu and pick product options |
| | `/checkout` | Choose/add an address on a map, normal or VIP delivery, apply a voucher (or tap one of "my vouchers"), spend loyalty points, leave a note — every total priced live by the server |
| | `/orders`, `/orders/:id` | Active and past orders, live tracking (status stepper + driver on the map over Socket.IO), timeline, cancel while pending, rate store and driver, order again |
| | `/account` | Profile, points, addresses, vouchers, password, browser notifications and sound, language, support |
| Delivery agent | `/driver` | Go online/offline, live delivery requests with countdown, accept/decline with a reason, active delivery map and directions, slide-to-confirm pickup → on the way → delivered (cash confirmation required), GPS sharing, stats and history |
| Shop owner | `/portal` | Open/close the shop, manage sections, add/edit products with photos and options, availability, drag to reorder. New products and edits show as *awaiting approval* until an admin publishes them |
| Admin | `/admin` | Sent to the existing standalone admin panel (`web-admin/`) rather than duplicating it |

Arabic (RTL, default), French and English, matching the app.

## Run it

```bash
npm install
cp .env.example .env   # optional — defaults to the hosted API
npm run dev            # http://localhost:5175
npm run build          # static output in dist/
```

| Variable | Default | Purpose |
| --- | --- | --- |
| `VITE_API_URL` | `https://sagi-h2du.onrender.com` | Backend base URL (no `/api/v1`) |
| `VITE_ADMIN_URL` | `http://localhost:5174` | Where admins are sent |

The build is a static single-page app: on any host, rewrite unknown paths to `index.html` so deep links like `/orders/…` work on refresh. The API must allow the site's origin in `CORS_ORIGINS` (the default `*` already does).

## Layout

```
src/
  lib/        api client (token refresh), every endpoint (services.js), socket, formatting
  state/      language/RTL, session, cart, toasts, location
  components/ UI kit, layout, catalog cards, product modal, maps, animated effects
  pages/      one file per screen; Driver and Portal are the two staff hubs
  i18n/       ar / fr / en — identical keys
```

Money is always priced by the server (`/orders/quote`); the client never computes a total it submits. The cart is single-store, like the app. Animations use Framer Motion and respect the system "reduce motion" setting.
