#!/usr/bin/env lua
--[[
  Author: Caio Prado
  Created: 2011 Aug 23
  Updated:
--]]
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local vicious = require("vicious")
vicious.contrib = require("vicious.contrib")

-- Icon
volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_mpd)

-- Volume Status
volstatus = wibox.widget.textbox()
vicious.register(volstatus, vicious.contrib.pulse, 
  function (widget, args)
    if args[1] == 0 then
      return "<span background='" .. beautiful.bg_urgent .. "' color='" .. beautiful.fg_urgent .. "'>mute</span>"
    else
      return args[1] .. "% "
    end
  end, 2, "alsa_output.pci-0000_00_1b.0.analog-stereo"
)
volstatus:buttons(awful.util.table.join(awful.button({ }, 1,
  function ()
    awful.util.spawn("pavucontrol")
  end)))
volicon:buttons(awful.util.table.join(awful.button({ }, 1,
  function ()
    awful.util.spawn("pavucontrol")
  end)))
