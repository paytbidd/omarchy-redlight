# Omarchy Red Light

[Omarchy](https://omarchy.org/) bar toggle for a pure red Hyprland screen shader.

The filter maps luminance to red and turns green and blue off. On and off crossfade through gray. Night light is left alone.

The bar icon is **RGB** set in [Chicago Kare](https://chicagokare.xyz/) at 13px — a pixel-faithful recreation of Susan Kare’s original Macintosh Chicago. It stays on the bar: dimmed RGB when off, then G and B fade so only R remains while red is on. Click it, use the Omarchy menu, or Super+Shift+Ctrl+N.

The font is bundled under `fonts/` (MIT, Duane King).

## Install

```bash
omarchy plugin add https://github.com/paytbidd/omarchy-redlight.git --enable
```

Place it in the **center** section, next to the stock indicators / night-light control.

Update later with:

```bash
omarchy plugin update payton.redlight
```

## What you get

- Bar widget `payton.redlight` — click to toggle
- Hyprland shaders bundled in the plugin (`shaders/`)
- `scripts/omarchy-toggle-redlight` — `toggle`, `on`, `off`, `reset`, `restore-if-enabled`, `--status`, `--enabled`

State is `~/.local/state/omarchy/redlight-enabled`. The widget restores the shader when the shell starts if that flag is set.

## Optional keybinds

In `~/.config/hypr/bindings.lua`:

```lua
o.bind("SUPER + SHIFT + CTRL + N", "Toggle red light",
  os.getenv("HOME") .. "/.config/omarchy/plugins/payton.redlight/scripts/omarchy-toggle-redlight")
o.bind("SUPER + CTRL + ALT + N", "Reset screen color",
  os.getenv("HOME") .. "/.config/omarchy/plugins/payton.redlight/scripts/omarchy-toggle-redlight reset")
```

To survive a Hyprland config reload while red is on, add this to `~/.config/hypr/autostart.lua`:

```lua
hl.exec_cmd(os.getenv("HOME") .. "/.config/omarchy/plugins/payton.redlight/scripts/omarchy-toggle-redlight restore-if-enabled")
```

## Notes

- Fade shaders need `debug:damage_tracking = 0` while they run so Hyprland's `time` uniform advances. The toggle script turns tracking off for the fade, then restores it. The static red shader does not use `time`.
- This is a screen shader, not hyprsunset. Night light can stay on underneath; red light replaces the compositor shader.
