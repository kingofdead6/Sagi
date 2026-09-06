const { app, BrowserWindow, shell } = require('electron');
const path = require('node:path');

const isDev = !app.isPackaged;
const startUrl = process.env.ELECTRON_START_URL || `file://${path.join(__dirname, '..', 'dist', 'index.html')}`;

function createWindow() {
  const win = new BrowserWindow({
    width: 1280,
    height: 820,
    minWidth: 960,
    minHeight: 640,
    icon: path.join(__dirname, '..', 'src', 'assets', 'Logo.png'),    
    webPreferences: {
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: true,
    },
    autoHideMenuBar: true,
  });

  win.loadURL(startUrl);

  if (isDev) win.webContents.openDevTools({ mode: 'detach' });

  // Any link the app tries to open externally goes to the OS browser, never
  // a second Electron window.
  win.webContents.setWindowOpenHandler(({ url }) => {
    shell.openExternal(url);
    return { action: 'deny' };
  });
}

app.whenReady().then(() => {
  createWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});
