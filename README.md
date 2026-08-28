# ساجي / Saji

An Arabic-first (RTL) multi-vendor delivery platform for Algeria — food,
groceries, meat, bakery and fruit. One Flutter codebase serves three role-gated
surfaces; one Express API serves all of them.

| Role | Surface | Purpose |
|---|---|---|
| **Customer** | Flutter mobile | browse vendors → menu → cart → order → live tracking |
| **Delivery agent** | Flutter mobile (same binary, role-gated router) | receive assignments, accept/reject, navigate, complete, history |
| **Admin** | Flutter **Web** (desktop) | CRUD vendors/products/offers/agents, confirm orders by phone, assign & track deliveries live |

**Order confirmation is human, by phone.** The admin is the dispatcher; vendors
have no login at v1.

```
Customer places order (pending)
  → Admin sees it live on the dashboard + audible alert
  → Admin PHONES the customer  → confirmed   (or cancelled + reason)
  → Admin phones the vendor    → sent_to_vendor → preparing → ready
  → Admin assigns an online agent → assigned
  → Agent gets a push, sees pickup + dropoff on a map, accepts or rejects
       ├── reject → order returns to the pool, admin reassigns (log reason)
       └── accept → picked_up → on_the_way (live GPS stream) → delivered
  → Customer sees every status change live; admin watches all agents on one map
```

---

## Repository layout

```
server/          Node 20 + Express 4 + Mongoose 8 + TypeScript API
  src/
    config/      env (zod-validated), db, logger, cloudinary, firebase
    middleware/  auth, validate, sanitize, rate limits, upload, error
    modules/     one folder per domain: model / schema / service / routes
    realtime/    socket server, emitter, push, late-order sweeper
    utils/       money, phone, geo, orderCode, pagination
    seed.ts
  tests/         jest + supertest (+ mongodb-memory-server where available)

app/             Flutter — customer + agent mobile, admin web
  lib/
    app/         router (role guards), theme tokens, routes
    core/        money, phone, Result/Failure, network, socket, storage,
                 location, map, notifications, shared widgets
    features/    auth home vendors catalog offers cart checkout orders
                 profile agent admin — each data/ domain/ presentation/
    l10n/        app_ar.arb (full) + fr/en stubs
    dev/         /dev/gallery — every shared widget with sample data
  test/

docker-compose.yml   MongoDB as a single-node replica set (transactions)
```

---

## Prerequisites

- **Node 20+** and npm
- **Flutter 3.35+** (built and verified against 3.47.2 / Dart 3.13)
- **MongoDB 6+ as a replica set** — order creation runs in a transaction.
  `docker compose up` provides this; MongoDB Atlas works too.
- Optional: a Cloudinary account (image uploads) and a Firebase project (push).
  Both degrade gracefully — the app runs fully without either.

---

## Running the API

```bash
cd server
cp ../.env.example .env          # then fill in the secrets
docker compose -f ../docker-compose.yml up -d   # Mongo as replica set rs0
npm install
npm run seed                     # prints the test credentials
npm run dev                      # http://localhost:4000/api/v1
```

Useful scripts:

| Script | What it does |
|---|---|
| `npm run dev` | tsx watch, hot reload |
| `npm run build` / `npm start` | compile to `dist/` and run it |
| `npm run seed` | wipe + reseed Bir El Ater data, print credentials |
| `npm run lint` | eslint |
| `npm run typecheck` | tsc --noEmit |
| `npm test` | jest |

### `.env` keys

See `.env.example` for the annotated list. The ones that matter:

| Key | Notes |
|---|---|
| `MONGO_URI` | must point at a replica set for transactions |
| `JWT_ACCESS_SECRET` / `JWT_REFRESH_SECRET` | generate with `node -e "console.log(require('crypto').randomBytes(48).toString('hex'))"` |
| `CORS_ORIGINS` | comma-separated; `*` only in development |
| `CLOUDINARY_*` | server-side only — never ship these to the app |
| `FIREBASE_*` | server-side only |
| `OTP_ENABLED` | `false` at v1 (see DECISIONS.md) |

---

## Running the Flutter surfaces

All three surfaces are the same binary; the router sends each role to its own
home and keeps it there. Point the app at your API with `--dart-define`:

```bash
cd app
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed + json
```

**Customer / agent (Android emulator)** — `10.0.2.2` is the host from inside
the emulator:

```bash
flutter run --dart-define=SAJI_API_URL=http://10.0.2.2:4000
```

**Customer / agent (physical device)** — use your machine's LAN address:

```bash
flutter run --dart-define=SAJI_API_URL=http://192.168.1.20:4000
```

**Admin dashboard (web, desktop widths)**:

```bash
flutter run -d chrome --dart-define=SAJI_API_URL=http://localhost:4000
# release build:
flutter build web --release --dart-define=SAJI_API_URL=https://api.example.com
```

**Widget gallery** — every shared widget with sample data, no backend needed:
navigate to `/dev/gallery`.

Which surface you see is decided by the role on your account, not by a build
flag: log in as the admin to get the dashboard, as an agent to get the courier
app, as a customer to get the storefront.

### Push notifications (optional)

`firebase_core` is initialised inside a `try/catch`, so the app runs fully
without Firebase. To enable push, add `android/app/google-services.json`, apply
the `com.google.gms.google-services` Gradle plugin, and set the `FIREBASE_*`
keys on the server.

---

## Running the tests

```bash
cd server && npm test          # jest + supertest
cd app && flutter test         # unit + widget
cd app && flutter analyze      # must be clean
```

**Note on the server suite.** Integration tests use
`mongodb-memory-server`, which downloads a MongoDB binary on first run. Where
that download is unavailable, `tests/globalSetup.ts` detects it, prints a
warning, and the database-backed suites skip instead of failing — the pure unit
suites (pricing matrix, state machine, money, phone, geo, and the no-database
API wiring checks) still run. Point `MONGOMS_SYSTEM_BINARY` at a local `mongod`
to run everything.

---

## Architecture notes

**Money is always an integer number of centimes** (1 دج = 100 سنتيم), client and
server. One `Money` value object in Dart, one `money.ts` helper in Node. No
floats anywhere near an amount.

**Prices are computed server-side, always.** The client sends
`{vendorId, items:[{productId, qty, optionValueIds[]}], voucherCode?, pointsToUse?, deliveryType, addressId}`
and the API re-prices from the database. A client-sent total is rejected by the
strict zod schema, not merely ignored.

**The order state machine lives in one file** — `orders/order.state.ts` — as
`ALLOWED` plus `ACTOR`, and every status write goes through
`orderService.transition()`, which validates the transition, the actor's role,
appends to the embedded audit trail, and emits the realtime event. The Dart enum
mirrors it for UI only.

**Ownership is checked in the service layer**, never from a client-sent role:
`requireAuth` re-reads the user's role from the database on every request.

**Realtime**: Socket.IO with JWT handshake auth and four room kinds — `admin`,
`agent:{id}`, `order:{id}`, `customer:{id}`. A customer only receives the
courier's position while their order is `on_the_way`.

**Maps** are OpenStreetMap via `flutter_map`, so the same widget runs on mobile
and in the web dashboard. Geocoding goes through Nominatim behind a `MapService`
interface, and every screen survives it failing — Algerian reverse-geocoding
often does, so the address fields stay editable.

---

## Deployment

`Dockerfile` (multi-stage, non-root Node 20 Alpine) and `docker-compose.yml` are
included; the target assumed is Railway or Render for the API with MongoDB Atlas
for the database. Nothing is actually deployed.

```bash
docker build -t saji-api ./server
docker run --env-file server/.env -p 4000:4000 saji-api
```

---

See `DECISIONS.md` for every judgement call made while building this, and
`PROGRESS.md` for the milestone checklist and what is verified.
