<!-- # Mac App Store Submission Guide -->
# Mac App Store への申請ガイド

<!-- Since v0.34.0, Electron allows submitting packaged apps to the Mac App Store
(MAS). This guide provides information on: how to submit your app and the
limitations of the MAS build. -->

v0.34.0　から Electron はパッケージ化したアプリを Mac App Store（MAS）へ申請することができます。どのようにアプリを申請するのかと MAS ビルドの限界について説明します。

<!-- ## How to Submit Your App -->
## アプリの申請方法

<!-- The following steps introduce a simple way to submit your app to Mac App Store.
However, these steps do not ensure your app will be approved by Apple; you
still need to read Apple's [Submitting Your App][submitting-your-app] guide on
how to meet the Mac App Store requirements. -->

これから説明するシンプルな方法に従ってアプリを Mac App Store に申請します。しかし、これらの手順は アプリが Apple に承認されるかを確実にするものではありません。どのように Mac App Store の必須要件を満たすかについての Apple の [Submitting Your App][submitting-your-app] を読む必要があります。

<!-- ### Get Certificate -->
### 証明書取得

To submit your app to the Mac App Store, you first must get a certificate from
Apple. You can follow these [existing guides][nwjs-guide] on web.

Mac App Store にアプリを申請するためにはまずは Apple から証明書を取得する必要があります。[existing guides][nwjs-guide] に書かれていることに従ってください。

<!-- ### Sign Your App -->
### アプリのサイン

<!-- After getting the certificate from Apple, you can package your app by following
[Application Distribution](application-distribution.md), and then proceed to
signing your app. This step is basically the same with other programs, but the
key is to sign every dependency of Electron one by one. -->

Apple から証明書を取得した後、[Application Distribution](application-distribution.md)に従ってアプリをパッケージ化することができます。次にアプリのサインインになります。この手順は基本的には他のプログラムと同じものですが Electron のすべての依存しているものをひとつずつサインするのが重要なことです。

First, you need to prepare two entitlements files.
はじめに2つの権限ファイルを用意する必要があります。

`child.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>com.apple.security.app-sandbox</key>
    <true/>
    <key>com.apple.security.inherit</key>
    <true/>
  </dict>
</plist>
```

`parent.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>com.apple.security.app-sandbox</key>
    <true/>
  </dict>
</plist>
```

And then sign your app with the following script:
そして次に以下のスクリプトでアプリにサインします：

```bash
#!/bin/bash

# Name of your app.
APP="YourApp"
# The path of you app to sign.
APP_PATH="/path/to/YouApp.app"
# The path to the location you want to put the signed package.
RESULT_PATH="~/Desktop/$APP.pkg"
# The name of certificates you requested.
APP_KEY="3rd Party Mac Developer Application: Company Name (APPIDENTITY)"
INSTALLER_KEY="3rd Party Mac Developer Installer: Company Name (APPIDENTITY)"

FRAMEWORKS_PATH="$APP_PATH/Contents/Frameworks"

codesign --deep -fs "$APP_KEY" --entitlements child.plist "$FRAMEWORKS_PATH/Electron Framework.framework/Libraries/libnode.dylib"
codesign --deep -fs "$APP_KEY" --entitlements child.plist "$FRAMEWORKS_PATH/Electron Framework.framework/Electron Framework"
codesign --deep -fs "$APP_KEY" --entitlements child.plist "$FRAMEWORKS_PATH/Electron Framework.framework/"
codesign --deep -fs "$APP_KEY" --entitlements child.plist "$FRAMEWORKS_PATH/$APP Helper.app/"
codesign --deep -fs "$APP_KEY" --entitlements child.plist "$FRAMEWORKS_PATH/$APP Helper EH.app/"
codesign --deep -fs "$APP_KEY" --entitlements child.plist "$FRAMEWORKS_PATH/$APP Helper NP.app/"
codesign  -fs "$APP_KEY" --entitlements parent.plist "$APP_PATH"
productbuild --component "$APP_PATH" /Applications --sign "$INSTALLER_KEY" "$RESULT_PATH"
```

<!-- If you are new to app sandboxing under OS X, you should also read through
Apple's [Enabling App Sandbox][enable-app-sandbox] to have a basic idea, then
add keys for the permissions needed by your app to the entitlements files. -->

もし OS X でサウンドバックスアプリを作ったない場合は、基本的な考えを理解するために　[Enabling App Sandbox][enable-app-sandbox] も読むべきです。その後、アプリの権限ファイルのなかで必要とされている権限の key を追加します。

<!-- ### Upload Your App and Submit for Review -->
### アプリをアップロードしてレビューを申請

<!-- After signing your app, you can use Application Loader to upload it to iTunes
Connect for processing, making sure you have [created a record][create-record]
before uploading. Then you can [submit your app for review][submit-for-review]. -->

アプリにサインした後、Application Loader を使ってアプリを iTunes Connect にアップロードします。アップロードする前に [created a record][create-record] を確実に用意しておいてください。その後 [レビューにアプリを申請する][submit-for-review]

<!-- ## Limitations of MAS Build -->
## MAS ビルドの限界

<!-- TODO: 翻訳見直し -->
<!-- In order to satisfy all requirements for app sandboxing, the following modules
have been disabled in the MAS build: -->

アプリのサウンドボックスのためにすべての必須要件を満たすために、以下のモジュールは MAS ビルドで使えなくなります。

* `crash-reporter`
* `auto-updater`

<!-- and the following behaviors have been changed: -->
以下の処理は変更されました：

<!-- * Video capture may not work for some machines.
* Certain accessibility features may not work.
* Apps will not be aware of DNS changes. -->

* ビデオのキャプチャーはいくつかのマシーンで動きません。
* いくつかのアクセサビリティ機能は動きません。
* アプリは DNS の変更を気にする必要はありません。

<!-- TODO: 翻訳見直し -->
<!-- Also, due to the usage of app sandboxing, the resources which can be accessed by
 the app are strictly limited; you can read [App Sandboxing][app-sandboxing] for
 more information. -->

またアプリのサウンドボックスのために、アプリが厳しく制限されたによってアクセスできるリソース。より詳細な情報は [App Sandboxing][app-sandboxing] をお読みください。

[submitting-your-app]: https://developer.apple.com/library/mac/documentation/IDEs/Conceptual/AppDistributionGuide/SubmittingYourApp/SubmittingYourApp.html
[nwjs-guide]: https://github.com/nwjs/nw.js/wiki/Mac-App-Store-%28MAS%29-Submission-Guideline#first-steps
[enable-app-sandbox]: https://developer.apple.com/library/ios/documentation/Miscellaneous/Reference/EntitlementKeyReference/Chapters/EnablingAppSandbox.html
[create-record]: https://developer.apple.com/library/ios/documentation/LanguagesUtilities/Conceptual/iTunesConnect_Guide/Chapters/CreatingiTunesConnectRecord.html
[submit-for-review]: https://developer.apple.com/library/ios/documentation/LanguagesUtilities/Conceptual/iTunesConnect_Guide/Chapters/SubmittingTheApp.html
[app-sandboxing]: https://developer.apple.com/app-sandboxing/
