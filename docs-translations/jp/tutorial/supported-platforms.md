<!-- # Supported Platforms -->
# サポートするプラットフォーム

<!-- Following platforms are supported by Electron: -->
Electron では以下のプラットフォームをサポートしています：

### OS X

<!-- Only 64bit binaries are provided for OS X, and the minimum OS X version
supported is OS X 10.8. -->

OS X によって提供されている 64bit バイナリーのみと OS X 10.8.系で提供されている最小のものをサポートしています。

### Windows

<!-- Windows 7 and later are supported, older operating systems are not supported
(and do not work). -->

Windows 7 以降のものをサポートしていて、古いバージョンに関しては今後サポートする予定はありません。

<!-- Both `x86` and `amd64` (x64) binaries are provided for Windows. Please note, the
`ARM` version of Windows is not supported for now. -->

Windows で提供されいてる `x86` と `amd64`(x64) の両方をサポートしています。`ARM` バージョンの Windows は現在サポートしていません。

### Linux

<!-- The prebuilt `ia32`(`i686`) and `x64`(`amd64`) binaries of Electron are built on
Ubuntu 12.04, the `arm` binary is built against ARM v7 with hard-float ABI and
NEON for Debian Wheezy. -->

Ubuntu 上でビルドされた `ia32`(`i686`)　と `x64`(`amd64`) バイナリーの Electron をサポートしています。また　ARM v7 に対してビルドされた `arm` バイナリーのhard-float ABI　と Debian Wheezy のための NEON。


<!-- Whether the prebuilt binary can run on a distribution depends on whether the
distribution includes the libraries that Electron is linked to on the building
platform, so only Ubuntu 12.04 is guaranteed to work, but following platforms
are also verified to be able to run the prebuilt binaries of Electron: -->




* Ubuntu 12.04 and later
* Fedora 21
* Debian 8
