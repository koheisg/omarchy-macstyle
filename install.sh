#!/bin/bash
# Link the Hyprland modules and the post-update check into ~/.config, and load
# them from ~/.config/hypr/bindings.lua.
#   --keyd  also install keyd/default.conf to /etc/keyd (needs sudo)
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
config="${XDG_CONFIG_HOME:-$HOME/.config}"

link() {
  local source=$1 target=$2
  if [[ -L $target && $(readlink "$target") == "$source" ]]; then
    return
  fi
  if [[ -e $target || -L $target ]]; then
    echo "$target already exists and is not a link to $source — move it away first" >&2
    exit 1
  fi
  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
  echo "linked $target"
}

link "$here/hypr/macstyle.lua" "$config/hypr/macstyle.lua"
link "$here/hypr/macstyle" "$config/hypr/macstyle"
link "$here/hooks/post-update" "$config/omarchy/hooks/post-update.d/omarchy-macstyle"

bindings="$config/hypr/bindings.lua"
if ! grep -qF 'require("hypr.macstyle' "$bindings"; then
  printf '\n-- Mac-style keys: https://github.com/koheisg/omarchy-macstyle\nrequire("hypr.macstyle")\n' >>"$bindings"
  echo "added require(\"hypr.macstyle\") to $bindings"
fi

if [[ ${1:-} == --keyd ]]; then
  command -v keyd >/dev/null || omarchy pkg add keyd
  if [[ -f /etc/keyd/default.conf ]] && ! cmp -s "$here/keyd/default.conf" /etc/keyd/default.conf; then
    sudo cp /etc/keyd/default.conf "/etc/keyd/default.conf.bak.$(date +%s)"
  fi
  sudo install -Dm644 "$here/keyd/default.conf" /etc/keyd/default.conf
  sudo systemctl enable --now keyd
  sudo keyd reload
fi

hyprctl reload >/dev/null
errors=$(hyprctl configerrors 2>/dev/null | grep -v '^\s*$' || true)
[[ -z $errors ]] || { echo "hyprctl configerrors: $errors" >&2; exit 1; }
