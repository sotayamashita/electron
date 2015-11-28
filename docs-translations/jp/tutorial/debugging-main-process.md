<!-- # Debugging the Main Process -->
# Main Process のデバック方法

<!-- The browser window DevTools can only debug the renderer process scripts (i.e.
the web pages). In order to provide a way to debug the scripts from the main
process, Electron has provided the `--debug` and `--debug-brk` switches. -->

browser window の DevTools でのみ例えばウェブページのような renderer process のスクリプトをデバックすることができます。main process のスクリプトをデバックするために、Electron では `--debug` と `--debug-brk` オプションが用意されています。

<!-- ## Command Line Switches -->
## コマンドライン スイッチ

<!-- Use the following command line switches to debug Electron's main process: -->

Electron の main process をデバックするために以下のコマンドラインオプションを使います：

### `--debug=[port]`

<!-- When this switch is used Electron will listen for V8 debugger protocol
messages on `port`. The default `port` is `5858`. -->

このオプションを使うと Electron は V8 debugger protocol メッセージを特定のポートで見ることができます。`port` のデフォルト番号は `5858` です。



### `--debug-brk=[port]`

<!-- Like `--debug` but pauses the script on the first line. -->
`--debug`オプションと違って最初の行でスクリプトを停止します。


<!-- ## Use node-inspector for Debugging -->
## デバックのために node-inspector を使用します

<!-- __Note:__ Electron uses node v0.11.13, which currently doesn't work very well
with node-inspector, and the main process will crash if you inspect the
`process` object under node-inspector's console. -->

__注意:__ Electron は node-inspector がうまく動かない node v0.11.13 を使用しています。そして node-inspector の コンソール上で `process` オブジェクトを調べると main process はクラッシュしてしまうかもしれません。

<!-- ### 1. Start the [node-inspector][node-inspector] server -->
### 1. [node-inspector][node-inspector] サーバをスタートする

```bash
$ node-inspector
```

<!-- ### 2. Enable debug mode for Electron -->
### 2. Electron でデバックモードを有効にする

<!-- You can either start Electron with a debug flag like: -->
Electron をデバックフラグを立ててスタートする：

```bash
$ electron --debug=5858 your/app
```

<!-- or, to pause your script on the first line: -->
もしくは、最初の行でスクリプトを停止するためには以下のようになります：

```bash
$ electron --debug-brk=5858 your/app
```

<!-- ### 3. Load the debugger UI -->
### 3. デバック画面をロードする

<!-- Open http://127.0.0.1:8080/debug?ws=127.0.0.1:8080&port=5858 in the Chrome browser. -->
Chrome ブラウザで http://127.0.0.1:8080/debug?ws=127.0.0.1:8080&port=5858 を開いてください。

[node-inspector]: https://github.com/node-inspector/node-inspector
