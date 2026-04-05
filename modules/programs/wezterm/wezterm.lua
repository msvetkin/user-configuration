local wezterm = require 'wezterm';
wezterm.add_to_config_reload_watch_list(wezterm.config_dir)

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.audible_bell = "Disabled"

config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.font = wezterm.font 'Liberation Mono'
config.font_size = 12
-- config.color_scheme = 'Materia (base16)'
-- config.color_scheme = 'Material Darker (base16)'
config.color_scheme = 'kanagawabones'

config.keys = {
  { key = 'Escape', mods = 'ALT', action = wezterm.action.ActivateCopyMode },
}

for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'ALT',
    action = wezterm.action.ActivateTab(i - 1),
  })
end


return config

