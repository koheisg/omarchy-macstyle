-- Mac-style Cmd+<num> tab switching in Chromium-based browsers.
-- Workspace 1-9 stays the same everywhere else; Super+0 (workspace 10) is
-- untouched because Chrome's Ctrl+0 is "reset zoom", not a tab action.
local util = require("hypr.macstyle.util")

for n = 1, 9 do
  local key = "SUPER + code:" .. tostring(n + 9)
  local label = n == 9 and "Browser last tab / workspace 9" or ("Browser tab " .. n .. " / workspace " .. n)
  local send_tab = util.send_keys("CTRL+" .. n)
  hl.unbind(key)
  o.bind(key, label, function()
    if util.active_window_has_tag("chromium-based-browser") then
      send_tab()
    else
      hl.dispatch(hl.dsp.focus({ workspace = tostring(n) }))
    end
  end)
end
