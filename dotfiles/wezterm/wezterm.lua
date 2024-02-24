-- Pull in the wezterm API
local wezterm = require 'wezterm'
-- This will hold the configuration.
local config = wezterm.config_builder()

-- ================================
-- Actual config

-- Colour scheme
config.color_scheme = 'Dracula'
-- config.color_scheme = 'Andromeda'
-- config.color_scheme = 'Blue Matrix'

-- Keep cursor visible
config.hide_mouse_cursor_when_typing = false

-- Set shell
config.default_prog = { 'nu' }

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

-- ================================
-- Return the configuration to wezterm
return config
