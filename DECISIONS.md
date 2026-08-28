# DECISIONS

Every judgement call made while building Saji, and why. Ordered roughly by how
much they matter.

---

## Environment constraints hit during the build

These are not product decisions — they are things the build environment made
impossible, recorded so nobody re-litigates them.

### 1. MongoDB binaries could not be downloaded, so integration tests skip here

`mongodb-memory-server` fetches a `mongod` binary from `fastdl.mongodb.org` on
first run. That host is blocked by the sandbox's egress policy (403 on CONNECT),
as are `repo.mongodb.org`, `downloads.mongodb.com` and the npmmirror mirror. No
Docker daemon was available either, and Ubuntu has not shipped a `mongodb-server`
package since 20.04.

**What was done about it, rather than shrugging:**

- The pricing engine was refactored so its core is **pure** —
  `orders/pricing.core.ts` takes a vendor, a product map, a request and a
  settings object, and returns a breakdown. No database, no Express. The entire
  pricing matrix (options, vouchers, points caps, VIP surcharge, minimum order,
  integer-centime invariants, the zero floor) is therefore genuinely tested and
  those tests **run and pass** here. `pricing.service.ts` is now a thin loader
  over it. This is better architecture regardless of the constraint.
- `tests/app.test.ts` exercises the real Express app end-to-end without a
  database: routing, the response envelope, zod validation, the Mongo-operator
  sanitiser, helmet headers, and the 401 on every protected route. It also
  asserts the state machine's internal integrity (every status reachable, every
  allowed transition has an actor, the actor table declares nothing the machine
  forbids).
- The database-backed suites (auth flows, refresh-token reuse detection, role
  guards, ownership, the full order lifecycle across three roles, illegal
  transitions, voucher and points edge cases) are **written and committed** but
  `tests/globalSetup.ts` detects the missing binary, warns, and marks them
  skipped rather than failing the run. They execute normally wherever a MongoDB
  is reachable — set `MONGOMS_SYSTEM_BINARY` to a local `mongod` if the download
  is blocked for you too.

**Status: 56 server tests pass here, 33 skip.** The skipped ones are the honest
gap in this run — they are unverified, not missing.

### 2. `flutter build apk` is unverified — the Android SDK could not be installed

`dl.google.com` is blocked by the same policy, so no Android SDK and no APK.
Mitigations: `flutter analyze` is clean, all 40 Flutter tests pass, and
`flutter build web --release` succeeds — a full whole-program compile of the
same Dart, which is what would catch real compile errors. The Android manifest
(permissions, foreground-service location, `POST_NOTIFICATIONS`, full-screen
intent, `<queries>` for `tel:` and map hand-off) and the iOS `Info.plist`
(location usage strings, background modes, `LSApplicationQueriesSchemes`) are
configured correctly but were not exercised by a device build.

### 3. `freezed` 2.x is incompatible with Dart 3.13 — upgraded to 4.x

The first `build_runner` run hung, then crashed with
`Missing implementation of visitDotShorthandPropertyAccess`: freezed 2.5 and
json_serializable 6.9 pin an `analyzer` whose language version (3.9) cannot
parse Dart 3.13's dot-shorthand syntax used inside the Flutter SDK itself.

Upgraded to `freezed ^4.0.0` / `freezed_annotation ^3.1.0` /
`json_serializable ^6.14.1` / `build_runner ^2.16.0` and migrated the model
classes to freezed 4's `abstract class X with _$X` form. Generation now takes
~40 seconds. Generated `.freezed.dart` / `.g.dart` files are **committed**
rather than gitignored, so a fresh clone compiles without running codegen first.

---

## Deviations from the brief's package list (§3)

### 4. `multer-storage-cloudinary` dropped

It peer-depends on `cloudinary@^1`, which conflicts with the `cloudinary@^2`
the brief specifies. Replaced with `multer.memoryStorage()` plus
`cloudinary.uploader.upload_stream`, which is what §3's own rule ("upload from
the client to the server, server streams to Cloudinary") describes anyway, and
gives direct control over the folder, the returned `publicId`, and deleting the
asset an upload replaces.

### 5. `flutter_background_geolocation` / `background_locator_2` not used

The first is a commercially licensed plugin; the second is effectively
unmaintained. The requirement — a GPS stream that survives backgrounding, with a
persistent notification — is met by `geolocator`'s own
`AndroidSettings.foregroundNotificationConfig`, which starts a real Android
foreground service. `LocationTracker` layers the rest of §9's spec on top:
throttling by both time (12s) and distance (20m), socket push for immediacy, and
a bounded queue that flushes to `POST /agent/location/batch` when the connection
returns. iOS uses background location modes; other platforms degrade to a plain
stream rather than failing.

### 6. `riverpod_annotation` / `riverpod_generator` not used

Plain `Provider` / `StateNotifierProvider` / `FutureProvider` throughout. Adding
a second code-generation pipeline on top of freezed doubled build_runner time
for no behavioural gain, and the generated providers would have been the same
shape. `riverpod_lint` / `custom_lint` were dropped for the same reason;
`very_good_analysis` is enabled and `flutter analyze` is clean.

### 7. `permission_handler` and `web` added

`permission_handler` for the notification permission on Android 13+.
`package:web` for the admin dashboard's CSV download — see §10 below. Both are
small and neither replaces anything the brief specified.

### 8. No charting package for analytics

The analytics panels needed one bar chart over a short daily series. A
dependency-free `_BarChart` (~40 lines, with tooltips) was cheaper than adding
`fl_chart` and is easier to restyle to the admin tokens.

---

## Product and implementation decisions

### 9. Transactions, with a compensating-write fallback

Order creation runs inside a Mongoose session when the connected server supports
transactions. `config/db.ts` detects this at connect time via the `hello`
command, and `withSession()` falls back to a non-transactional path when it
finds a standalone server, logging a warning. In that path the writes are
ordered so the risky ones come first and are individually compensated: points
are deducted with a guarded `$inc` (`points: { $gte: n }`) so a concurrent order
cannot double-spend them, the voucher is incremented with a guarded `$expr`
check against `maxUses`, and if the voucher claim fails the points are handed
back before the error propagates. `docker-compose.yml` therefore starts Mongo as
a single-node replica set (`rs0`) so the transactional path is the default
locally, and the test harness uses `MongoMemoryReplSet`.

### 10. CSV export downloads through the authenticated client

The naive approach — pointing the browser at `/admin/orders/export` — cannot
carry the `Authorization` header, and putting a token in a URL is worse. So the
CSV is fetched through the same Dio client as everything else, then handed to
the platform through a conditional import: a real `Blob` download on web
(`package:web`), the clipboard elsewhere. A UTF-8 BOM is prepended so Excel
opens the Arabic columns correctly, and the fields are semicolon-separated for
the same reason.

### 11. Voucher evaluation is split between the database and the pure core

Eligibility (window, quota, per-user limit) needs the database and lives in
`evaluateVoucher`. The discount arithmetic is pure and lives in
`voucherDiscount` inside the pricing core, so it is covered by the tests that
actually run. A voucher whose minimum the basket misses is reported as a
`warning` on the quote rather than silently dropped, so the checkout screen can
tell the customer why nothing changed.

### 12. Points are deducted at creation and refunded on cancellation

Earned points are only credited on `delivered`. Spent points are deducted when
the order is created (so a second order cannot spend the same balance) and
refunded if the order is later cancelled. A voucher use is **not** refunded on
cancellation — that is deliberate, to stop a voucher being farmed by ordering
and cancelling; it can be revisited if it annoys real customers.

### 13. A rejected or expired assignment returns to `ready`, not `preparing`

§6 says "reject → order returns to the pool". `ready` is the pool: the food is
made and waiting for a courier. `ALLOWED.assigned` therefore includes `ready`,
and `ACTOR['assigned->ready']` allows both the agent (explicit reject) and the
admin (the sweeper's expiry path, which acts as the system).

### 14. The late-order sweeper de-duplicates its alerts

`realtime/sweeper.ts` runs on an interval, expires stale offers, and raises
`order:late` **once per order** — it keeps a set of already-flagged ids and
clears an id once the order stops being late, so a delayed order does not spam
the dashboard every minute but a fresh delay does re-alert.

### 15. Customer tracking renders from `order.events`, never from a guess

`OrderStatus.stepIndex` folds the eleven server statuses onto the five steps the
customer sees, and the timestamps come from the embedded audit trail. The
courier's marker only appears once the order is `on_the_way` — the server
enforces this too, by only routing `agent:location` into the customer's room for
an order in that state.

### 16. The cart is single-vendor and persisted

Adding from a second vendor prompts to clear (§9). The basket is written through
to Hive on every mutation, so closing the app mid-order loses nothing, and a
corrupt cache starts empty rather than crashing.

### 17. Vendor deletion is a soft delete

`DELETE /admin/vendors/:id` sets `isActive: false` and `isOpen: false`, and
refuses outright while the vendor has non-terminal orders. Historical orders
keep a readable vendor.

### 18. `POST /orders/quote` is the only source of a displayed total

The Dart `Cart` computes an `estimatedSubtotal` for instant feedback when a
quantity changes, and it is labelled as an estimate in the code. Every figure on
the checkout screen comes from the server's quote, and the confirm button shows
the server's total.

### 19. OTP is built but disabled

`OTP_ENABLED=false`, per §12. The screen exists and is reachable; the endpoints
return 503 with an Arabic message while the flag is off. Algerian SMS delivery
is unreliable and the admin phones every customer anyway — flipping the flag and
wiring a provider is all that is left.

### 20. Refresh tokens rotate, with reuse detection

Stored hashed (SHA-256), never in plaintext. Presenting an already-consumed
token revokes the entire family and forces a re-login — the standard defence
against a stolen refresh token. The Dio interceptor refreshes transparently on a
401 and retries once; concurrent 401s share a single in-flight refresh so a
burst of requests cannot rotate the token several times over.

### 21. `PATCH /auth/me` is `.strict()`

Sending `role` or `points` is a 400, not a silent drop. Every admin update
schema whitelists its fields explicitly and no raw `req.body` reaches a Mongoose
update, so operator injection has no path in.

### 22. French and English are stub locales

`app_ar.arb` carries all 381 keys. `app_fr.arb` and `app_en.arb` have the same
key set with the Arabic values, so a mis-set locale renders readable Arabic
rather than throwing on a missing key. Arabic RTL is the only shipped locale at
v1 and the direction is set once, in `MaterialApp`.

### 23. Text scaling is clamped to 0.9–1.3

The Figma layouts are dense (a 342px card on a 390px frame). Clamping keeps them
legible under accessibility settings without letting a 2× scale destroy them.

### 24. Order code collisions retry, then give up

`generateUniqueOrderCode` tries 12 times and throws rather than looping forever.
`DR` + 6 digits is a million-code space; at Bir El Ater volumes a collision is
already unlikely, and a caller that somehow exhausts 12 attempts has a real
problem worth surfacing.

### 25. Drag-reorder is only offered within one vendor

`POST /admin/products/reorder` writes absolute `sortOrder` values, which are
only meaningful inside a single menu. The products list is therefore a plain
list when the vendor filter is "all", and becomes a `ReorderableListView` with
drag handles once a vendor is selected. A failed reorder snaps the list back to
the server's order rather than leaving the UI lying about what was saved.

### 26. The admin dashboard degrades below 1024px

It is designed for desktop (§1). Under `AppSizes.adminMinWidth` the fixed
sidebar moves into a `Drawer` and the top bar becomes an `AppBar`, so a tablet is
usable in a pinch rather than broken.

---

## Not built

- **Bundle offers** are in the enum and selectable, but the pricing core treats
  them as a no-op discount — the "buy X get Y" rules were not specified.
- **App icon and splash artwork.** The launcher uses Flutter's default icon; the
  in-app splash screen is built and branded. Generating raster icon sets needed
  image tooling not available in this environment.
