-- Mac/Cocoa-style Ctrl text navigation: Ctrl+<key> -> emacs nav in apps,
-- original Ctrl+<key> in terminals (so tmux prefix / readline keep working).
local util = require("hypr.macstyle.util")

for _, nav in ipairs({
  { "A", "Cocoa beginning-of-line", { "Home" } },
  { "B", "Cocoa back-char", { "Left" } },
  { "E", "Cocoa end-of-line", { "End" } },
  { "F", "Cocoa forward-char", { "Right" } },
  { "N", "Cocoa next-line", { "Down" } },
  { "P", "Cocoa previous-line", { "Up" } },
  { "D", "Cocoa delete-char", { "Delete" } },
  { "H", "Cocoa backspace", { "BackSpace" } },
  { "K", "emacs kill-line", { "SHIFT+End", "Delete" } },
  { "U", "kill backward to BOL", { "SHIFT+Home", "Delete" } },
  { "W", "backward-kill-word", { "CTRL+BackSpace" } },
}) do
  local in_terminal = util.send_keys("CTRL+" .. nav[1])
  local in_app = util.send_keys(table.unpack(nav[3]))
  o.bind("CTRL + " .. nav[1], nav[2], function()
    if util.active_window_has_tag("terminal") then
      in_terminal()
    else
      in_app()
    end
  end)
end
