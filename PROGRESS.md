# ساجي / Saji — build progress

| # | Milestone | Status |
|---|-----------|--------|
| 1 | Repo + tooling (monorepo, docker-compose, lint configs) | ✅ done |
| 2 | Backend core (config, auth, JWT + roles, validation, rate limits) | ✅ done |
| 3 | Domain models + CRUD (all §5 schemas, catalog, Cloudinary uploads) | ✅ done |
| 4 | Order engine (state machine, server-side pricing, transitions) | ✅ done |
| 5 | Sockets + push (rooms, FCM, late/expiry sweeper) | ✅ done |
| 6 | Seed (`npm run seed`, Bir El Ater data, printed credentials) | ✅ done |
| 7 | Flutter foundation (tokens, ARB, RTL, Dio, socket, widgets, gallery) | ✅ done |
| 8 | Customer app (auth → home → vendor → cart → checkout → tracking) | ✅ done |
| 9 | Admin web (shell, dashboard, orders board, drawer, assign) | ✅ done |
| 10 | Agent app (online toggle, location stream, offers, delivery) | ✅ done |
| 11 | Admin CRUD + fleet map + analytics + settings | ✅ done |
| 12 | Hardening (offline cache, states, platform config, docs) | ✅ done |

## Verification status

Everything below was actually run in this environment.

| Check | Result |
|---|---|
| `npm run lint` (server) | clean |
| `npm run typecheck` (server) | clean |
| `npm run build` + boot the compiled app | succeeds |
| `npm test` (server) | **56 passing**, 33 skipped |
| `flutter analyze` | clean, 0 issues |
| `flutter test` | **40 passing** |
| `flutter build web --release` | succeeds |

### What the 33 skipped server tests are

The database-backed suites — auth flows, refresh-token reuse detection, role
guards, ownership, the full three-role order lifecycle, illegal transitions,
voucher and points edge cases. They are written and committed but need a real
MongoDB, and `fastdl.mongodb.org` is blocked by this sandbox's egress policy, so
`tests/globalSetup.ts` marks them skipped rather than failing the run. They
execute normally anywhere a MongoDB is reachable. See DECISIONS.md §1.

### What is not verified here

- `flutter build apk` — the Android SDK could not be installed
  (`dl.google.com` is blocked). The manifest and Gradle config are in place and
  the same Dart compiles cleanly for web. See DECISIONS.md §2.
- Live end-to-end behaviour against a running server — no MongoDB was
  obtainable, so the API was exercised through its no-database wiring tests
  rather than a real order.
