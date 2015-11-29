<!-- # DevTools Extension -->
# DevTools 拡張

<!-- To make debugging easier, Electron has basic support for the
[Chrome DevTools Extension][devtools-extension]. -->

デバックを簡単にするために Electron では基本的に [Chrome DevTools Extension][devtools-extension] をサポートしています。

<!-- For most DevTools extensions you can simply download the source code and use
the `BrowserWindow.addDevToolsExtension` API to load them. The loaded extensions
will be remembered so you don't need to call the API every time when creating
a window. -->

多くの DevTools 拡張はソースコードをダウンロードして `BrowserWindow.addDevToolsExtension` API を使用して拡張を読み込むだけです。読み込まれた拡張は記憶されるので window を作成するたびに API を呼ぶ必要はありません。

<!-- ** NOTE: React DevTools does not work, follow the issue here https://github.com/atom/electron/issues/915 ** -->

** 注意： React DevTools は現在動きません。詳細は https://github.com/atom/electron/issues/915 を参照してください。 **

<!-- For example, to use the [React DevTools Extension](https://github.com/facebook/react-devtools)
, first you need to download its source code: -->

例えば、[React DevTools Extension](https://github.com/facebook/react-devtools) を使うためにはソースコードをまずダウンロードする必要があります：

```bash
$ cd /some-directory
$ git clone --recursive https://github.com/facebook/react-devtools.git
```

<!-- Follow the instructions in [`react-devtools/shells/chrome/Readme.md`](https://github.com/facebook/react-devtools/blob/master/shells/chrome/Readme.md) to build the extension. -->

拡張をビルドするためには [`react-devtools/shells/chrome/Readme.md`](https://github.com/facebook/react-devtools/blob/master/shells/chrome/Readme.md) を参照してください。

<!-- Then you can load the extension in Electron by opening DevTools in any window,
and running the following code in the DevTools console: -->

どこの window で　DevTools を開くと Electron で拡張が読み込まれ、以下のコードを

```javascript
const BrowserWindow = require('electron').remote.BrowserWindow;
BrowserWindow.addDevToolsExtension('/some-directory/react-devtools/shells/chrome');
```

<!-- To unload the extension, you can call the `BrowserWindow.removeDevToolsExtension`
API with its name and it will not load the next time you open the DevTools: -->

拡張をアップロードするためにはその拡張の名前と一緒に `BrowserWindow.removeDevToolsExtension` API を呼びます。次ぐに DevTools を開いたときには読み込まれません：

```javascript
BrowserWindow.removeDevToolsExtension('React Developer Tools');
```

<!-- ## Format of DevTools Extension -->
## DevTools 拡張のフォーマット

<!-- Ideally all DevTools extensions written for the Chrome browser can be loaded by
Electron, but they have to be in a plain directory. For those packaged with
`crx` extensions, there is no way for Electron to load them unless you find a
way to extract them into a directory. -->

すべての Chrome ブラウザのために書かれた DevTools 拡張は Electron で読み込むことができますが、plain ディレクトリ内にある必要があります。パッケージされ拡張子が `crx` の拡張は、それらの拡張を plain ディレクトリに切り出す方法を見つけないかぎり Electron でそれらを読み込む方法はありません。

## Background Pages

<!-- Currently Electron doesn't support the background pages feature in Chrome
extensions, so some DevTools extensions that rely on this feature may
not work in Electron. -->

現在 Electron は Chrome 拡張の background pages 機能はサポートしていません。なので、いつかのこの機能に依存している拡張は Electron ではうまく動かないとでしょう。

## `chrome.*` APIs

<!-- TODO: 翻訳がよくわからないけど一旦仮で -->
<!-- Some Chrome extensions may use `chrome.*` APIs for features and while there has
been some effort to implement those APIs in Electron, not all have been
implemented. -->

いくつかの Chrome 拡張は `chrome.*` API を使用していることでしょう。Electron でこれらのAPIが実装されない限り、実装されません。

<!-- Given that not all `chrome.*` APIs are implemented if the DevTools extension is
using APIs other than `chrome.devtools.*`, the extension is very likely not to
work. You can report failing extensions in the issue tracker so that we can add
support for those APIs. -->

もし DevTools 拡張が `chrome.devtools.*` 以外の API を使用して場合にすべての `chrome.*` API が実装されないことを考えると、拡張はおそらくうまく動かないです。それらの API をサポートするために、失敗した拡張を issue として報告することができます。

[devtools-extension]: https://developer.chrome.com/extensions/devtools
