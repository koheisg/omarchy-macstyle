# omarchy-macstyle

[Omarchy](https://omarchy.org/)（Arch Linux + Hyprland）のキー操作を macOS に寄せる Hyprland の Lua モジュールである。
Omarchy 4（Hyprland の設定が Lua になった quattro 以降）を対象にしている。

## できること

| モジュール | キー | 動作 |
|---|---|---|
| `ime` | 左 Cmd をタップ／右 Cmd をタップ | 日本語入力をオフ／オン（Mac の英数／かなキーと同じ） |
| `cmd` | Super+W/T/N/A/Z/R/F/L/S/P、Super+Shift+Z | ターミナル以外では Ctrl+同じキーを送る。ターミナルでは何もしない |
| `cmd` | Super+Alt+W/T/F/L/S/P | 上で使えなくなる Omarchy のウィンドウ操作（閉じる、フロート、全画面、レイアウト切り替え、スクラッチパッド、pseudo） |
| `emacs` | Ctrl+A/E/B/F/N/P/D/H/K/U/W | ターミナル以外では Cocoa と同じテキスト移動・削除をする。ターミナルには Ctrl+キーをそのまま送る |
| `tabs` | Super+1〜9 | Chromium 系のブラウザではタブ 1〜9 に移動し、それ以外ではワークスペース 1〜9 に移動する |

ターミナルかどうか、Chromium 系のブラウザかどうかは、Omarchy がウィンドウに付けるタグ（`terminal`、`chromium-based-browser`）で判定する。

Cmd のタップは、keyd が F13/F14 に変換して Hyprland に渡す。
Cmd を押したまま別のキーを押した場合は、普通の Super として働く。

## インストール

```bash
ghq get koheisg/omarchy-macstyle   # または git clone
~/ghq/github.com/koheisg/omarchy-macstyle/install.sh --keyd
```

`install.sh` は次のことをする。

- `~/.config/hypr/macstyle.lua` と `~/.config/hypr/macstyle/` を、このリポジトリへのシンボリックリンクにする
- `~/.config/hypr/bindings.lua` の末尾に `require("hypr.macstyle")` を足す
- post-update フックを `~/.config/omarchy/hooks/post-update.d/omarchy-macstyle` にリンクする
- `--keyd` を付けたときだけ、keyd を入れて `/etc/keyd/default.conf` を置き、サービスを有効にする（sudo のパスワードを聞かれる）

一部のモジュールだけを使うときは、`bindings.lua` の `require("hypr.macstyle")` を次のように書き換える。

```lua
require("hypr.macstyle.cmd")
require("hypr.macstyle.tabs")
```

`ime` を使わないなら、`--keyd` も不要である。

## 更新

```bash
git -C ~/ghq/github.com/koheisg/omarchy-macstyle pull
hyprctl reload
```

## `omarchy update` のあとの確認

post-update フックが、次の状態を確かめて、崩れていれば警告を出す。

- `bindings.lua` から `hypr.macstyle` が読み込まれているか（`omarchy refresh hyprland` で `bindings.lua` が初期化されると外れる）
- `/etc/keyd/default.conf` に Cmd タップの設定が残っていて、keyd が動いているか
- fcitx5 のトリガーキーに `Control+space` が入っていないか

## 注意

- fcitx5 のトリガーキーに `Control+space` が入っていると、fcitx5 が Ctrl+Space を先に受け取る。Omarchy の現在の開発版は、配布する fcitx5 の設定からこれを外している
- `Super+Alt+F`（横幅いっぱい）と `Super+Alt+S`（ウィンドウをスクラッチパッドへ送る）は、Omarchy の割り当てを上書きするので使えなくなる
- Hyprland は keyd の仮想キーボードから来た F13/F14 をキー名で解決できないので、キーコード（`code:191`/`code:192`）で割り当てている
