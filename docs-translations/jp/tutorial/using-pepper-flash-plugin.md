<!-- # Using Pepper Flash Plugin -->
# Pepper Flash Plugin を使用方法

<!-- Electron now supports the Pepper Flash plugin. To use the Pepper Flash plugin in
Electron, you should manually specify the location of the Pepper Flash plugin
and then enable it in your application. -->

Electron は　Pepper Flash plugin　をサポートしています。Electron で Pepper Flash plugin を使うために、Pepper Flash plugin のパスを直接指定しなければなりません。その後アプリケーション内で可能にします。

<!-- ## Prepare a Copy of Flash Plugin -->
## Flash Plugin のコピーを準備する

<!-- On OS X and Linux, the details of the Pepper Flash plugin can be found by
navigating to `chrome://plugins` in the Chrome browser. Its location and version
are useful for Electron's Pepper Flash support. You can also copy it to another
location. -->

OS X と Linux 上では Pepper Flash plugin の詳細を Chrome ブラウザで `chrome://plugins` と入力することで確認することができます。Pepper Flash Plugin のパスとバージョンは Electron の Pepper Flash のサポートに役立ちます。これを別の場所にコピーすることもできます。


<!-- ## Add Electron Switch -->
## Electron のオプション追加

<!-- You can directly add `--ppapi-flash-path` and `ppapi-flash-version` to the
Electron command line or by using the `app.commandLine.appendSwitch` method
before the app ready event. Also, add the `plugins` switch of `browser-window`.
For example: -->

直接 `--ppapi-flash-path` と `ppapi-flash-version` を Electron の実行時に渡すか app の ready event の前に `app.commandLine.appendSwitch` を使います。または `browser-window` の `plugins` オプションを追加します。例えば：

```javascript
// Specify flash path.
// On Windows, it might be /path/to/pepflashplayer.dll
// On OS X, /path/to/PepperFlashPlayer.plugin
// On Linux, /path/to/libpepflashplayer.so
app.commandLine.appendSwitch('ppapi-flash-path', '/path/to/libpepflashplayer.so');

// Specify flash version, for example, v17.0.0.169
app.commandLine.appendSwitch('ppapi-flash-version', '17.0.0.169');

app.on('ready', function() {
  mainWindow = new BrowserWindow({
    'width': 800,
    'height': 600,
    'web-preferences': {
      'plugins': true
    }
  });
  mainWindow.loadURL('file://' + __dirname + '/index.html');
  // Something else
});
```

<!-- ## Enable Flash Plugin in a `<webview>` Tag -->
## `<webview>` タグ内で Flash Plugin を可能にする

<!-- Add `plugins` attribute to `<webview>` tag. -->
`<webview` タグに `plugins` 属性を追加する

```html
<webview src="http://www.adobe.com/software/flash/about/" plugins></webview>
```
