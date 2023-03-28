local wezterm = require("wezterm")
local keymaps = {}

local function map(key, mods, action)
    table.insert(keymaps, {
        key = key,
        mods = mods,
        action = action,
    })
end

map("\\", "CTRL", wezterm.action.SendString("\x01\x7c"))
map("-", "CTRL", wezterm.action.SendString("\x01\x2d"))
map(
    "|",
    "CTRL|SHIFT",
    wezterm.action.SplitPane({
        direction = "Right",
        size = { Percent = 50 },
    })
)
local config = {
    -- window_background_image = "/Users/aaron/Documents/wallpapers/499580.jpg",
    -- window_background_image_hsb = {
    -- 	brightness = 0.04,
    -- 	hue = 1.0,
    -- 	saturation = 1.0,
    -- },
    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = true,
    allow_square_glyphs_to_overflow_width = "Never",
    use_fancy_tab_bar = false,
    font = wezterm.font({
        -- family = "FiraCode Nerd Font Mono",
        -- family = "Hack Nerd Font",
        family = "JetBrainsMono Nerd Font",
        -- family = "VictorMono Nerd Font",
        weight = "Regular",
    }),
    harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    keys = keymaps,
    force_reverse_video_cursor = true,
    colors = {
        foreground = "#dcd7ba",
        background = "#000000",
        --
        cursor_bg = "#c8c093",
        cursor_fg = "#c8c093",
        cursor_border = "#c8c093",
        --
        -- 	selection_fg = "#c8c093",
        -- 	selection_bg = "#2d4f67",
        --
        -- 	scrollbar_thumb = "#16161d",
        -- 	split = "#16161d",
        --
        -- 	ansi = { "#090618", "#c34043", "#76946a", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
        -- 	brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
        -- 	indexed = { [16] = "#ffa066", [17] = "#ff5d62" },
    },
}

return config
