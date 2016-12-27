#!/usr/bin/env lua
--[[
	Author: Caio Prado
	Created: 2011 Oct 29
	Updated:
--]]
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local vicious = require("vicious")

-- {{{ Events
ev = {}
ev[1] = { name = "Deadlines", search = "*(%d%d)*", fg="#ff3333", bg="#000000" }
ev[2] = { name = "Niver",     search = "~(%d%d)~", fg="#ffcc26", bg="#000000" }
ev[3] = { name = "Events",    search = "-(%d%d)-", fg="#00b11b", bg="#000000" }
ev[4] = { name = "Series",    search = "·(%d%d)·", fg="#821cd4", bg="#000000" }
-- }}}

-- {{{ Colors
bg_today = "#888899"
fg_today = "#000000"
bg_tomor = "#000000"
fg_tomor = "#ffcc26"
bg_dates = "#000000"
fg_dates = "#2672ff"

bg_label = "#000000"
fg_label = "#2672ff"
-- }}}

-- {{{ Fonts
monofont = beautiful.monofont or beautiful.font
-- }}}

clockwidget = wibox.widget.textbox()
vicious.register(clockwidget, vicious.widgets.date, " %a, %b %d, %R ")
clockwidget:connect_signal('mouse::enter', function()
    stream = io.popen("pal -r 0 -c 6 --nocolor -f ~/.config/awesome/pal.conf") -- no events
    calendar = stream:read("*a")
    stream:close()

    stream = io.popen("pal -c 0 --nocolor -f ~/.config/awesome/pal.conf") -- no calendar
    events = stream:read("*a")
    stream:close()

    -- Parse Calendar (first line and months color)
    calendar = string.gsub(calendar,"%a%a%a", "<span background='" .. bg_label .. "' color='" .. fg_label .. "'>%0</span>")
    calendar = string.gsub(calendar,"^(.-)\n","<span background='" .. bg_label .. "' color='" .. fg_label .. "'>%1</span>\n")

    -- Color for each event type and remove symbols
    calendar = string.gsub(calendar,"@(%d%d)@","<span background='" .. bg_today .. "' color='" .. fg_today .. "'> %1 </span>")
    for i,event in ipairs(ev) do
      calendar = string.gsub(calendar,event.search,"<span background='" .. event.bg .. "' color='" .. event.fg .. "'> %1 </span>")
    end

    clocktext = string.format("<span font_desc='%s'>%s</span>",monofont,calendar)

    -- Parse Events
    events = string.gsub(events,"* ","\t")
    events = string.gsub(events,"(%a%a%a [ %d]%d %a%a%a %d+)( %- .-)\n","<span background='" .. bg_dates .. "' color='" .. fg_dates .. "'>%1</span>%2\n")
    events = string.gsub(events,"%s*$","")
    events = string.gsub(events,"(</span> %- )(Today)","%1<span background='" .. bg_today .. "' color='" .. fg_today .. "'>%2</span>")
    events = string.gsub(events,"(</span> %- )(Tomorrow)","%1<span background='" .. bg_tomor .. "' color='" .. fg_tomor .. "'>%2</span>")
    for i,event in ipairs(ev) do
      events = string.gsub(events,"\t" .. event.name .. ": ","<span background='" .. event.bg .. "' color='" .. event.fg .. "'>%0</span>")
    end

    clocktext = clocktext .. "\n" .. events

    clockinfo = naughty.notify({
      screen = mouse.screen,
      position = "top_right",
      timeout = 0,
      align = "center",
      text = clocktext
    })
  end)
clockwidget:connect_signal('mouse::leave', function() naughty.destroy(clockinfo) end)
