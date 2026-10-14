-- Mac-style keys for Omarchy. Load everything from ~/.config/hypr/bindings.lua:
--   require("hypr.macstyle")
-- or only the parts you want:
--   require("hypr.macstyle.ime")    -- left/right Cmd tap -> IME off/on (needs keyd)
--   require("hypr.macstyle.cmd")    -- Super+<key> -> Ctrl+<key> outside terminals
--   require("hypr.macstyle.emacs")  -- Ctrl+A/E/B/F/... -> Cocoa text navigation outside terminals
--   require("hypr.macstyle.tabs")   -- Super+1-9 -> tab 1-9 in Chromium-based browsers

require("hypr.macstyle.ime")
require("hypr.macstyle.cmd")
require("hypr.macstyle.emacs")
require("hypr.macstyle.tabs")
