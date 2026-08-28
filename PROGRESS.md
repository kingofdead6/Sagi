# ساجي / Saji — build progress

| # | Milestone | Status |
|---|-----------|--------|
| 1 | Repo + tooling (monorepo, docker-compose, lint configs) | ✅ done |
| 2 | Backend core (config, auth, JWT + roles, validation, rate limits) | ✅ done |
| 3 | Domain models + CRUD (all §5 schemas, catalog, uploads) | ✅ done |
| 4 | Order engine (state machine, server-side pricing, transitions) | ✅ done |
| 5 | Sockets + push (rooms, FCM, late/expiry sweeper) | ✅ done |
| 6 | Seed (`npm run seed`, Bir El Ater data, printed credentials) | ✅ done |
| 7 | Flutter foundation (tokens, ARB, RTL, Dio, socket, widgets, gallery) | 🔄 in progress |
| 8 | Customer app (auth → home → vendor → cart → checkout → tracking) | ⬜ pending |
| 9 | Admin web (shell, dashboard, orders board, drawer, assign) | ⬜ pending |
| 10 | Agent app (online toggle, location stream, offers, delivery) | ⬜ pending |
| 11 | Admin CRUD + fleet map + analytics + settings | ⬜ pending |
| 12 | Hardening (push wiring, offline cache, states, docs, report) | ⬜ pending |

## Verification status

- `npm run lint` — clean
- `npm run typecheck` — clean
- `npm test` — 46 passing; 33 integration tests skip in this environment
  (MongoDB binaries cannot be downloaded here, see DECISIONS.md)
- `flutter analyze` — clean
