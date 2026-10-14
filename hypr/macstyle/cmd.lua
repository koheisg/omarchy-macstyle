-- Mac-style Cmd shortcuts: Super+<key> -> Ctrl+<key> in non-terminal apps.
-- In terminals they do nothing, so e.g. Super+W in tmux doesn't kill the window.
-- The window actions they displace move to Super+Alt+<key>.
local util = require("hypr.macstyle.util")

for _, key in ipairs({ "W", "T", "F", "L", "S", "P", "SUPER + ALT + F", "SUPER + ALT + S" }) do
  hl.unbind(key:find("+", 1, true) and key or "SUPER + " .. key)
end
o.bind("SUPER + ALT + W", "Close window", hl.dsp.window.close())
o.bind("SUPER + ALT + T", "Toggle floating", hl.dsp.window.float({ action = "toggle" }))
o.bind("SUPER + ALT + F", "Fullscreen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("SUPER + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("SUPER + ALT + S", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))
o.bind("SUPER + ALT + P", "Pseudo window", hl.dsp.window.pseudo())

local function passthrough(chord)
  local send = util.send_keys(chord)
  return function()
    if not util.active_window_has_tag("terminal") then
      send()
    end
  end
end

for _, key in ipairs({ "W", "T", "N", "A", "Z", "R", "F", "L", "S", "P" }) do
  o.bind("SUPER + " .. key, "Mac-style Cmd+" .. key, passthrough("CTRL+" .. key))
end
o.bind("SUPER + SHIFT + Z", "Mac-style Cmd+Shift+Z", passthrough("CTRL+SHIFT+Z"))
