{deprecate, ipcMain} = require 'electron'

# This module is deprecated, we mirror everything from ipcMain.
deprecate.warn 'ipc module', 'ipcMain module'

module.exports = ipcMain
