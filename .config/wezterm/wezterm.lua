-- local wezterm = require("wezterm")
-- local keymaps = {}
--
-- local function map(key, mods, action)
--     table.insert(keymaps, {
--         key = key,
--         mods = mods,
--         action = action,
--     })
-- end
--
-- map("\\", "CTRL", wezterm.action.SendString("\x01\x7c"))
-- map("-", "CTRL", wezterm.action.SendString("\x02\x2d"))
-- map(
--     "|",
--     "CTRL|SHIFT",
--     wezterm.action.SplitPane({
--         direction = "Right",
--         size = { Percent = 50 },
--     })
-- )
-- local config = {
--     enable_tab_bar = false,
--     hide_tab_bar_if_only_one_tab = true,
--     -- allow_square_glyphs_to_overflow_width = "Never",
--     use_fancy_tab_bar = false,
--     font_size = 9,
--     font = wezterm.font_with_fallback({
--         { family = "JetBrains Mono", weight = "Regular" },
--         { family = "Hack Nerd Font", weight = "Regular" },
--         -- { family = "SplineSansMono" },
--     }),
--     -- freetype_load_target = "Light",
--     -- freetype_render_target = "HorizontalLcd",
--     -- harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
--     window_padding = {
--         left = 0,
--         right = 0,
--         top = 0,
--         bottom = 0,
--     },
--     keys = keymaps,
--     force_reverse_video_cursor = true,
--     color_scheme_dirs = { wezterm.home_dir },
--     enable_wayland = false,
-- }
-- wezterm.add_to_config_reload_watch_list(config.color_scheme_dirs[1] .. config.color_scheme .. ".toml")
--
-- return config

local wezterm = require("wezterm")

local padding = 0

return {
    cell_width = 1.0,
    color_scheme = "tokyonight_night",
    max_fps = 200,
    default_prog = { "zsh" },
    -- display_pixel_geometry = "BGR",
    enable_wayland = false,

    -- Basic configurations
    font = wezterm.font_with_fallback({
        { family = "Spline Sans Mono" },
        { family = "FiraCode Nerd Font" },
    }),
    -- font = wezterm.font("JetBrains Mono"),
    -- font = wezterm.font("Hack Nerd Font"),
    -- font = wezterm.font("Hack Nerd Font Bold"),
    font_size = 9,
    -- enable_tab_bar = true,
    font_rules = {
        {
            intensity = "Bold",
            font = wezterm.font("Spline Sans Mono", { weight = "DemiBold" }),
        },
    },
    enable_tab_bar = false,
    line_height = 0.95,
    window_decorations = "RESIZE",
    -- window_decorations = "NONE",
    -- window_background_opacity = 0.85,
    window_background_opacity = 0.9,
    -- window_background_opacity = 1,

    window_padding = {
        bottom = padding,
        left = padding,
        right = padding,
        top = padding,
    },
    window_close_confirmation = "NeverPrompt",
}
