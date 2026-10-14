local M = {}

-- Synthesize key presses on the focused surface. Down/up are sent separately
-- (like Omarchy's clipboard bindings) to avoid stuck synthetic keys. Each step
-- is "KEY" or "MOD+MOD+KEY"; steps are sent one after another.
function M.send_keys(...)
  local steps = { ... }
  return function()
    for i, step in ipairs(steps) do
      local mods, key = step:match("^(.*)%+([^+]+)$")
      mods = mods and mods:gsub("%+", " ") or ""
      key = key or step
      hl.timer(function()
        hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
        hl.timer(function()
          hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
        end, { timeout = 30, type = "oneshot" })
      end, { timeout = 1 + (i - 1) * 60, type = "oneshot" })
    end
  end
end

-- Omarchy tags windows from rules (default/hypr/apps/*.lua), e.g. "terminal" and
-- "chromium-based-browser". Rule-set tags carry a trailing "*".
function M.active_window_has_tag(name)
  local window = hl.get_active_window()
  if not window then
    return false
  end

  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == name then
      return true
    end
  end

  return false
end

return M
