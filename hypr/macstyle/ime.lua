-- Mac-style IME switching: keyd (keyd/default.conf in this repo) turns a
-- left/right Meta tap into F13/F14 (keycode 191/192). Bind by keycode because
-- Hyprland does not resolve the F13/F14 keysym from keyd's virtual keyboard.
o.bind("code:191", "IME off (English)", "fcitx5-remote -c")
o.bind("code:192", "IME on (Japanese)", "fcitx5-remote -o")
