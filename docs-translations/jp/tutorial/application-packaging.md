<!-- # Application Packaging -->
# アプリケーションパッケージング

<!-- To mitigate [issues](https://github.com/joyent/node/issues/6960) around long
path names on Windows, slightly speed up `require` and conceal your source code
from cursory inspection, you can choose to package your app into an [asar][asar]
archive with little changes to your source code. -->
Windows で長いパス名の[問題](https://github.com/joyent/node/issues/6960)を緩和するために、`require` がスピードアップして粗雑な調査からソースコードを隠します。ソースコードに少しの変更を加えて [asar][asar] アーカイブをしてアプリをパッケージを選べます。

<!-- ## Generating `asar` Archive -->
## `asar` アーカイブを作成する

<!-- An [asar][asar] archive is a simple tar-like format that concatenates files
into a single file. Electron can read arbitrary files from it without unpacking
the whole file. -->
[asar][asar]　アーカイブは単純な tar のように複数のファイルを１つに連結する形式です。Electron [asar][asar]　アーカイブからパッケージを解答しなくても任意のファイルを読み込むことができます。

<!-- Steps to package your app into an `asar` archive: -->
アプリを `asar` アーカイブにするパッケージ化するための手順：

<!-- ### 1. Install the asar Utility -->
### 1. asar ユーティリティをインストール

```bash
$ npm install -g asar
```

<!-- ### 2. Package with `asar pack` -->
### 2. `asar pack` でパッケージ

```bash
$ asar pack your-app app.asar
```

<!-- ## Using `asar` Archives -->
## `asar` アーカイブを使用

<!-- In Electron there are two sets of APIs: Node APIs provided by Node.js and Web
APIs provided by Chromium. Both APIs support reading files from `asar` archives. -->

Electron には2つのAPIがあります。Node.js が提供する API と Chromium が提供する APIの２つです。どちらの API も `asar` アーカイブからファイルを読み取りをサポートしています。

### Node API

<!-- With special patches in Electron, Node APIs like `fs.readFile` and `require`
treat `asar` archives as virtual directories, and the files in it as normal
files in the filesystem. -->
`fs.readFile` と `require` のような Node API は `asar` アーカイブをヴァーチャルディレクトリとして扱います。それらのファイルはファイルシステムの中では普通のファイルです。

<!-- For example, suppose we have an `example.asar` archive under `/path/to`: -->
例えば `path/to` 下に　`example.asar` アーカイブを持っているとします：

```bash
$ asar list /path/to/example.asar
/app.js
/file.txt
/dir/module.js
/static/index.html
/static/main.css
/static/jquery.min.js
```

Read a file in the `asar` archive:
`asar`　アーカイブファイルを読み込みます：

```javascript
const fs = require('fs');
fs.readFileSync('/path/to/example.asar/file.txt');
```

<!-- List all files under the root of the archive: -->
アーカイブのルート以下のファイルの一覧を表示：

```javascript
const fs = require('fs');
fs.readdirSync('/path/to/example.asar');
```

<!-- Use a module from the archive: -->
アーカイブからモジュールを使う：

```javascript
require('/path/to/example.asar/dir/module.js');
```

<!-- You can also display a web page in an `asar` archive with `BrowserWindow`: -->
`BrowserWindow` を使うことで `asar` アーカイブのファイルを表示することできます：

```javascript
const BrowserWindow = require('electron').BrowserWindow;
var win = new BrowserWindow({width: 800, height: 600});
win.loadURL('file:///path/to/example.asar/static/index.html');
```

### Web API

<!-- In a web page, files in an archive can be requested with the `file:` protocol.
Like the Node API, `asar` archives are treated as directories. -->

ウェブページ上で、アーカイブ内のファイルを `file:` プロトコルを使用してリクエストすることができます。Node API のように `asar` アーカイブをディレクトリとして扱うことができます。

<!-- For example, to get a file with `$.get`: -->

例えば `$.get` を使ってファイルを取得します：

```html
<script>
var $ = require('./jquery.min.js');
$.get('file:///path/to/example.asar/file.txt', function(data) {
  console.log(data);
});
</script>
```

<!-- ### Treating an `asar` Archive as a Normal File -->
### `asar` アーカイブを普通のファイルとして扱う

For some cases like verifying the `asar` archive's checksum, we need to read the
content of `asar` archive as file. For this purpose you can use the built-in
`original-fs` module which provides original `fs` APIs without `asar` support:

```javascript
var originalFs = require('original-fs');
originalFs.readFileSync('/path/to/example.asar');
```

## Limitations on Node API

Even though we tried hard to make `asar` archives in the Node API work like
directories as much as possible, there are still limitations due to the
low-level nature of the Node API.

### Archives Are Read-only

The archives can not be modified so all Node APIs that can modify files will not
work with `asar` archives.

### Working Directory Can Not Be Set to Directories in Archive

Though `asar` archives are treated as directories, there are no actual
directories in the filesystem, so you can never set the working directory to
directories in `asar` archives. Passing them as the `cwd` option of some APIs
will also cause errors.

### Extra Unpacking on Some APIs

Most `fs` APIs can read a file or get a file's information from `asar` archives
without unpacking, but for some APIs that rely on passing the real file path to
underlying system calls, Electron will extract the needed file into a
temporary file and pass the path of the temporary file to the APIs to make them
work. This adds a little overhead for those APIs.

APIs that requires extra unpacking are:

* `child_process.execFile`
* `fs.open`
* `fs.openSync`
* `process.dlopen` - Used by `require` on native modules

### Fake Stat Information of `fs.stat`

The `Stats` object returned by `fs.stat` and its friends on files in `asar`
archives is generated by guessing, because those files do not exist on the
filesystem. So you should not trust the `Stats` object except for getting file
size and checking file type.

## Adding Unpacked Files in `asar` Archive

As stated above, some Node APIs will unpack the file to filesystem when
calling, apart from the performance issues, it could also lead to false alerts
of virus scanners.

To work around this, you can unpack some files creating archives by using the
`--unpack` option, an example of excluding shared libraries of native modules
is:

```bash
$ asar pack app app.asar --unpack *.node
```

After running the command, apart from the `app.asar`, there is also an
`app.asar.unpacked` folder generated which contains the unpacked files, you
should copy it together with `app.asar` when shipping it to users.

[asar]: https://github.com/atom/asar
