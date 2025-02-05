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
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	allow_square_glyphs_to_overflow_width = "Never",
	use_fancy_tab_bar = false,
	font_size = 10,
	font = wezterm.font({
		-- family = "FiraCode Nerd Font Mono",
		-- family = "Hack Nerd Font",
		family = "JetBrains Mono",
		-- family = "VictorMono Nerd Font",
		weight = "Regular",
	}),
	freetype_load_target = "HorizontalLcd",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	keys = keymaps,
	force_reverse_video_cursor = true,
	color_scheme_dirs = { wezterm.home_dir },
	color_scheme = "tokyonight_night",
}
wezterm.add_to_config_reload_watch_list(config.color_scheme_dirs[1] .. config.color_scheme .. ".toml")

return config
