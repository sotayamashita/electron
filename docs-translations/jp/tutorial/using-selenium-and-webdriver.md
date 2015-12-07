<!-- # Using Selenium and WebDriver -->
# Selenium と WebDriver の使用方法

<!-- From [ChromeDriver - WebDriver for Chrome][chrome-driver]: -->
[ChromeDriver - WebDriver for Chrome][chrome-driver] から抜粋：

<!-- > WebDriver is an open source tool for automated testing of web apps across many
> browsers. It provides capabilities for navigating to web pages, user input,
> JavaScript execution, and more. ChromeDriver is a standalone server which
> implements WebDriver's wire protocol for Chromium. It is being developed by
> members of the Chromium and WebDriver teams. -->

> WebDriver は複数のブラウザでウェブアプリケーションのテストを自動的にするオープンソースツールです。
> ウェブページの遷移、ユーザーからの入力、JavaScriptの実行などを提供しています。ChromeDriver は
> Chromium のプロトコルを実装する WebDriver の単独で動作するサーバです。Chromium と WebDriver
> のチームによって開発されてきました。

<!-- In order to use `chromedriver` with Electron you have to tell it where to
find Electron and make it think Electron is the Chrome browser. -->

Electron で　`chromedriver` を使用するために `chromedriver` に Electron の場所を指定しなければなりません。Electron を Chrome ブラウザとして認識させます。

## Setting up with WebDriverJs

<!-- [WebDriverJs](https://code.google.com/p/selenium/wiki/WebDriverJs) provides
a Node package for testing with web driver, we will use it as an example. -->

[WebDriverJs](https://code.google.com/p/selenium/wiki/WebDriverJs)　は web driver でテストするための Node パッケージ を提供していて、例として使用します。

<!-- ### 1. Start ChromeDriver -->
### 1. ChromeDriver を起動する

<!-- First you need to download the `chromedriver` binary, and run it: -->
はじめに `chromedriver` バイナリーをダウンロードして実行します：

```bash
$ ./chromedriver
Starting ChromeDriver (v2.10.291558) on port 9515
Only local connections are allowed.
```

<!-- Remember the port number `9515`, which will be used later -->
`9515` というポート番号を覚えておいてください。後ほど使用します。

### 2. Install WebDriverJS
### 2. WebDriverJS をインストール

```bash
$ npm install selenium-webdriver
```

<!-- ### 3. Connect to ChromeDriver -->
### 3. ChromeDriver に接続する

<!-- The usage of `selenium-webdriver` with Electron is basically the same with
upstream, except that you have to manually specify how to connect chrome driver
and where to find Electron's binary: -->

手動で chrome ドライバーと接続しElectron のバイナリーを指定する必要があることを除いては、Electron での`selenium-webdriver` の使用は基本的に上流の方法と同様です：

```javascript
const webdriver = require('selenium-webdriver');

var driver = new webdriver.Builder()
  // The "9515" is the port opened by chrome driver.
  .usingServer('http://localhost:9515')
  .withCapabilities({
    chromeOptions: {
      // Here is the path to your Electron binary.
      binary: '/Path-to-Your-App.app/Contents/MacOS/Atom',
    }
  })
  .forBrowser('electron')
  .build();

driver.get('http://www.google.com');
driver.findElement(webdriver.By.name('q')).sendKeys('webdriver');
driver.findElement(webdriver.By.name('btnG')).click();
driver.wait(function() {
 return driver.getTitle().then(function(title) {
   return title === 'webdriver - Google Search';
 });
}, 1000);

driver.quit();
```

<!-- ## Setting up with WebdriverIO -->
## WebdriverIO の準備をする

<!-- [WebdriverIO](http://webdriver.io/) provides a Node package for testing with web
driver. -->

[WebdriverIO](http://webdriver.io/) は web driver をテストするための Node パッケージを提供します。

<!-- ### 1. Start ChromeDriver -->
### 1. ChromeDriver を起動する

<!-- First you need to download the `chromedriver` binary, and run it: -->
はじめに `chromedriver` バイナリーをダウンロードして、実行します：

```bash
$ chromedriver --url-base=wd/hub --port=9515
Starting ChromeDriver (v2.10.291558) on port 9515
Only local connections are allowed.
```

<!-- Remember the port number `9515`, which will be used later -->
`9515` というポート番号を覚えておいてください。後ほど使用します。

<!-- ### 2. Install WebdriverIO -->
### 2. WebdriverIO をインストールする

```bash
$ npm install webdriverio
```

<!-- ### 3. Connect to chrome driver -->
### 3. chrome ドライバーを接続する

```javascript
const webdriverio = require('webdriverio');
var options = {
    host: "localhost", // Use localhost as chrome driver server
    port: 9515,        // "9515" is the port opened by chrome driver.
    desiredCapabilities: {
        browserName: 'chrome',
        chromeOptions: {
          binary: '/Path-to-Your-App/electron', // Path to your Electron binary.
          args: [/* cli arguments */]           // Optional, perhaps 'app=' + /path/to/your/app/
        }
    }
};

var client = webdriverio.remote(options);

client
    .init()
    .url('http://google.com')
    .setValue('#q', 'webdriverio')
    .click('#btnG')
    .getTitle().then(function(title) {
        console.log('Title was: ' + title);
    })
    .end();
```

<!-- ## Workflow -->
## ワークフロー

<!-- To test your application without rebuilding Electron, simply
[place](https://github.com/atom/electron/blob/master/docs/tutorial/application-distribution.md)
your app source into Electron's resource directory. -->

Electron を再ビルドしないでアプリケーションをテストするために、Electron のリソースディレクトリにアプリケーションを[置きます](https://github.com/atom/electron/blob/master/docs/tutorial/application-distribution.md)。

<!-- Alternatively, pass an argument to run with your electron binary that points to
your app's folder. This eliminates the need to copy-paste your app into
Electron's resource directory. -->

また、実行するためにアプリケーションフォルダを引数を渡します。Electron リソースディレクトリにアプリケーションをコピー＆ペーストする必要がありません。


[chrome-driver]: https://sites.google.com/a/chromium.org/chromedriver/
