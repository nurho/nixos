-- Pull in the wezterm API
local wezterm = require 'wezterm'
-- This will hold the configuration.
local config = wezterm.config_builder()

-- ================================
-- Actual config
wezterm.on('gui-startup', function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- ################################
-- ### APPEARANCE               ###
-- ################################

-- Colour scheme
config.color_scheme = 'Dracula'
-- config.color_scheme = 'Andromeda'
-- config.color_scheme = 'Blue Matrix'

-- Keep cursor visible
config.hide_mouse_cursor_when_typing = false

-- Set shell
config.default_prog = { 'fish' }

-- Disable ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- Tab bar appearance
config.use_fancy_tab_bar = false
config.colors = {
  tab_bar = {
    background = '#282a36',
    active_tab = {
      bg_color = '#44475a',
      fg_color = '#f8f8f2',
      intensity = 'Bold',
    },

    inactive_tab = {
      bg_color = '#282a36',
      fg_color = '#6272a4',
      italic = true,
    },

    inactive_tab_hover = {
      bg_color = '#44475a',
      fg_color = '#f8f8f2',
      intensity = 'Bold',
    },

    new_tab = {
      bg_color = '#44475a',
      fg_color = '#f8f8f2',
    },

    new_tab_hover = {
      bg_color = '#50fa7b',
      fg_color = '#6272a4',
      italic = true,
    }
  }
}


-- ################################
-- ### KEYBINDS                 ###
-- ################################

local act = wezterm.action
config.keys = {
  {key = 'q', mods = 'ALT', action = act.ActivatePaneByIndex(0)},
  {key = 'w', mods = 'ALT', action = act.ActivatePaneByIndex(1)},
  {key = 'e', mods = 'ALT', action = act.ActivatePaneByIndex(2)},
  {key = 'r', mods = 'ALT', action = act.ActivatePaneByIndex(3)},
  {key = 'Backspace', mods = 'ALT', action = act.CloseCurrentPane { confirm = false }},
  {key = 'Backspace', mods = 'ALT|SHIFT', action = act.CloseCurrentTab { confirm = false }},
  {key = 'v', mods = 'ALT', action = act.SplitVertical { domain = 'CurrentPaneDomain' }},
  {key = 'h', mods = 'ALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }},
  {key = 't', mods = 'ALT', action = act.SpawnTab 'DefaultDomain'},
  {key = 'j', mods = 'ALT', action = act.ActivateTabRelative(-1)},
  {key = 'k', mods = 'ALT', action = act.ActivateTabRelative(1)},
  {key = 'j', mods = 'ALT|SHIFT', action = act.MoveTabRelative(-1)},
  {key = 'k', mods = 'ALT|SHIFT', action = act.MoveTabRelative(1)},
  {key = '#', mods = 'ALT', action = act.EmitEvent 'rust-layout'},
}
for i = 1, 9 do
  table.insert(config.keys, {key = tostring(i), mods = 'ALT', action = act.ActivateTab(i - 1)})
end
-- ================================
-- Return the configuration to wezterm
return config
