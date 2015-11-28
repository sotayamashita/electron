<!-- based on 5cacf79 -->

# Menu

The `menu` class is used to create native menus that can be used as
application menus and
[context menus](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XUL/PopupGuide/ContextMenus).
This module is a main process module which can be used in a render process via
the `remote` module.

`menu` クラスは　アプリケーションメニューと[コンテキストメニュー](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XUL/PopupGuide/ContextMenus)といったネイティブメニューを作るために使われます。このモジュールは `remote` モジュールを経由して render process で使われる main process モジュールです

Each menu consists of multiple [menu items](menu-item.md) and each menu item can
have a submenu.

それぞれのメニューは複数の [menu items](menu-item.md) で構成され、それぞれが submenu を持つことができます。

Below is an example of creating a menu dynamically in a web page
(render process) by using the [remote](remote.md) module, and showing it when
the user right clicks the page:

以下は　[remote](remote.md) モジュールを使用することでウェブ上（render process）で動的にメニューを作成する例です。ウェブページ上でユーザーが右クリックした際に表示されます。

```html
<!-- index.html -->
<script>
const remote = require('electron').remote;
const Menu = remote.Menu;
const MenuItem = remote.MenuItem;

var menu = new Menu();
menu.append(new MenuItem({ label: 'MenuItem1', click: function() { console.log('item 1 clicked'); } }));
menu.append(new MenuItem({ type: 'separator' }));
menu.append(new MenuItem({ label: 'MenuItem2', type: 'checkbox', checked: true }));

window.addEventListener('contextmenu', function (e) {
  e.preventDefault();
  menu.popup(remote.getCurrentWindow());
}, false);
</script>
```

An example of creating the application menu in the render process with the
simple template API:

シンプルな template API で render process 側でアプリケーションメニューを作成する例です：

```javascript
var template = [
  {
    label: 'Edit',
    submenu: [
      {
        label: 'Undo',
        accelerator: 'CmdOrCtrl+Z',
        role: 'undo'
      },
      {
        label: 'Redo',
        accelerator: 'Shift+CmdOrCtrl+Z',
        role: 'redo'
      },
      {
        type: 'separator'
      },
      {
        label: 'Cut',
        accelerator: 'CmdOrCtrl+X',
        role: 'cut'
      },
      {
        label: 'Copy',
        accelerator: 'CmdOrCtrl+C',
        role: 'copy'
      },
      {
        label: 'Paste',
        accelerator: 'CmdOrCtrl+V',
        role: 'paste'
      },
      {
        label: 'Select All',
        accelerator: 'CmdOrCtrl+A',
        role: 'selectall'
      },
    ]
  },
  {
    label: 'View',
    submenu: [
      {
        label: 'Reload',
        accelerator: 'CmdOrCtrl+R',
        click: function(item, focusedWindow) {
          if (focusedWindow)
            focusedWindow.reload();
        }
      },
      {
        label: 'Toggle Full Screen',
        accelerator: (function() {
          if (process.platform == 'darwin')
            return 'Ctrl+Command+F';
          else
            return 'F11';
        })(),
        click: function(item, focusedWindow) {
          if (focusedWindow)
            focusedWindow.setFullScreen(!focusedWindow.isFullScreen());
        }
      },
      {
        label: 'Toggle Developer Tools',
        accelerator: (function() {
          if (process.platform == 'darwin')
            return 'Alt+Command+I';
          else
            return 'Ctrl+Shift+I';
        })(),
        click: function(item, focusedWindow) {
          if (focusedWindow)
            focusedWindow.toggleDevTools();
        }
      },
    ]
  },
  {
    label: 'Window',
    role: 'window',
    submenu: [
      {
        label: 'Minimize',
        accelerator: 'CmdOrCtrl+M',
        role: 'minimize'
      },
      {
        label: 'Close',
        accelerator: 'CmdOrCtrl+W',
        role: 'close'
      },
    ]
  },
  {
    label: 'Help',
    role: 'help',
    submenu: [
      {
        label: 'Learn More',
        click: function() { require('electron').shell.openExternal('http://electron.atom.io') }
      },
    ]
  },
];

if (process.platform == 'darwin') {
  var name = require('electron').app.getName();
  template.unshift({
    label: name,
    submenu: [
      {
        label: 'About ' + name,
        role: 'about'
      },
      {
        type: 'separator'
      },
      {
        label: 'Services',
        role: 'services',
        submenu: []
      },
      {
        type: 'separator'
      },
      {
        label: 'Hide ' + name,
        accelerator: 'Command+H',
        role: 'hide'
      },
      {
        label: 'Hide Others',
        accelerator: 'Command+Shift+H',
        role: 'hideothers'
      },
      {
        label: 'Show All',
        role: 'unhide'
      },
      {
        type: 'separator'
      },
      {
        label: 'Quit',
        accelerator: 'Command+Q',
        click: function() { app.quit(); }
      },
    ]
  });
  // Window menu.
  template[3].submenu.push(
    {
      type: 'separator'
    },
    {
      label: 'Bring All to Front',
      role: 'front'
    }
  );
}

menu = Menu.buildFromTemplate(template);
Menu.setApplicationMenu(menu);
```

## Class: Menu

### `new Menu()`

Creates a new menu.

## Methods

The `menu` class has the following methods:

`menu` クラスには以下のメソッドがあります：

### `Menu.setApplicationMenu(menu)`

* `menu` Menu

Sets `menu` as the application menu on OS X. On Windows and Linux, the `menu`
will be set as each window's top menu.

OS X で `menu` をアプリケーションメニューにセットします。Windows や Linux では `menu` はそれぞれのウィンドウの一番上にセットされます。

### `Menu.sendActionToFirstResponder(action)` _OS X_

* `action` String

Sends the `action` to the first responder of application. This is used for
emulating default Cocoa menu behaviors, usually you would just use the
`selector` property of `MenuItem`.

`action` をアプリケーションの初めての反応時におくります。デフォルトの Cocoa メニューの挙動を再現するために使われます。普通、`MenuItem` の `selector` プロパティを使うことでしょう。

### `Menu.buildFromTemplate(template)`

* `template` Array

Generally, the `template` is just an array of `options` for constructing a
[MenuItem](menu-item.md). The usage can be referenced above.

一般的に `template` は [MenuItem](menu-item.md) を構成するただの `options` の配列です。使い方は上記のものを参照してください。

You can also attach other fields to the element of the `template` and they
will become properties of the constructed menu items.

`template` の要素に他のフィールドを加える事ができ、それらは menu items を構成するプロパティになります。

### `Menu.popup([browserWindow, x, y])`

* `browserWindow` BrowserWindow (optional)
* `x` Number (optional)
* `y` Number (**required** if `x` is used)

Pops up this menu as a context menu in the `browserWindow`. You
can optionally provide a `x,y` coordinate to place the menu at, otherwise it
will be placed at the current mouse cursor position.

`browserWindow` でメニューをコンテキストメニューとして表示できます。任意で メニューの場所を決める `x,y` 座標を与えることができます。そうしない場合にはメニューはマウスのカーソルの部分に表示されます。

### `Menu.append(menuItem)`

* `menuItem` MenuItem

Appends the `menuItem` to the menu.

menu に `menuItem` を追加する

### `Menu.insert(pos, menuItem)`

* `pos` Integer
* `menuItem` MenuItem

Inserts the `menuItem` to the `pos` position of the menu.



### `Menu.items()`

Get an array containing the menu's items.

## Notes on OS X Application Menu

## OS X アプリケーションのメニューの注意点

OS X has a completely different style of application menu from Windows and
Linux, here are some notes on making your app's menu more native-like.

OS X は Windows や Linux とくらべて全く異なるアプリケーションメニューのスタイルを持ちます。これはアプリケーションメニューがよりネイティブっぽく作るための注意点です。

### Standard Menus

On OS X there are many system defined standard menus, like the `Services` and
`Windows` menus. To make your menu a standard menu, you should set your menu's
`role` to one of following and Electron will recognize them and make them
become standard menus:



* `window`
* `help`
* `services`

### Standard Menu Item Actions

OS X has provided standard actions for some menu items, like `About xxx`,
`Hide xxx`, and `Hide Others`. To set the action of a menu item to a standard
action, you should set the `role` attribute of the menu item.

### Main Menu's Name

On OS X the label of application menu's first item is always your app's name,
no matter what label you set. To change it you have to change your app's name
by modifying your app bundle's `Info.plist` file. See [About Information
Property List Files][AboutInformationPropertyListFiles] for more information.

## Menu Item Position

You can make use of `position` and `id` to control how the item will be placed
when building a menu with `Menu.buildFromTemplate`.

The `position` attribute of `MenuItem` has the form `[placement]=[id]`, where
placement is one of `before`, `after`, or `endof` and `id` is the unique ID of
an existing item in the menu:

* `before` - Inserts this item before the id referenced item. If the
  referenced item doesn't exist the item will be inserted at the end of
  the menu.
* `after` - Inserts this item after id referenced item. If the referenced
  item doesn't exist the item will be inserted at the end of the menu.
* `endof` - Inserts this item at the end of the logical group containing
  the id referenced item (groups are created by separator items). If
  the referenced item doesn't exist, a new separator group is created with
  the given id and this item is inserted after that separator.

When an item is positioned, all un-positioned items are inserted after
it until a new item is positioned. So if you want to position a group of
menu items in the same location you only need to specify a position for
the first item.

### Examples

Template:

```javascript
[
  {label: '4', id: '4'},
  {label: '5', id: '5'},
  {label: '1', id: '1', position: 'before=4'},
  {label: '2', id: '2'},
  {label: '3', id: '3'}
]
```

Menu:

```
- 1
- 2
- 3
- 4
- 5
```

Template:

```javascript
[
  {label: 'a', position: 'endof=letters'},
  {label: '1', position: 'endof=numbers'},
  {label: 'b', position: 'endof=letters'},
  {label: '2', position: 'endof=numbers'},
  {label: 'c', position: 'endof=letters'},
  {label: '3', position: 'endof=numbers'}
]
```

Menu:

```
- ---
- a
- b
- c
- ---
- 1
- 2
- 3
```

[AboutInformationPropertyListFiles]: https://developer.apple.com/library/ios/documentation/general/Reference/InfoPlistKeyReference/Articles/AboutInformationPropertyListFiles.html
