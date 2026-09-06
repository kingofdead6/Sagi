# Saji Admin — standalone app

The Saji admin panel, extracted from the landing-page project into its own
Vite + React app so it can run as a browser page or be packaged as a desktop
app with Electron.

## Setup

```bash
npm install
```

By default this talks to the same hosted API the mobile app uses
(`https://sagi-h2du.onrender.com/api/v1`). To point at a backend running
locally instead:

```bash
cp .env.example .env   # uncomment and set VITE_API_URL
```

## Run in a browser

```bash
npm run dev
```

## Run as a desktop app (Electron, dev mode)

```bash
npm run electron:dev
```

## Package a desktop build

```bash
npm run electron:build   # installer for the current OS, output in release/
npm run electron:pack    # unpacked app only, for quick local testing
```

`VITE_API_URL` is baked in at build time — set it in `.env` (or the shell
environment) before running `electron:build` so the packaged app points at
the right backend.
