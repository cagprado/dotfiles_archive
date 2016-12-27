#!/usr/bin/env lua
--[[
	Author: Caio Prado
	Created: 2011 Aug 23
	Updated:
--]]
local awful = require("awful")
local vicious = require("vicious")

globalkeys = awful.util.table.join(globalkeys,
        -- LAPTOP
	awful.key({ }, "XF86TouchpadToggle", function()
			awful.util.spawn("touchpad.sh")
		end),
	awful.key({ }, "XF86MonBrightnessDown", function()
			awful.util.spawn("xbacklight - 1")
		end),
	awful.key({ }, "XF86MonBrightnessUp", function()
			awful.util.spawn("xbacklight + 1")
		end),
        -- GENERAL
	awful.key({ }, "XF86Sleep", function()
			awful.util.spawn("slimlock")
		end),
	awful.key({ modkey }, "p", function()
			awful.util.spawn("slimlock")
		end),
	awful.key({ }, "XF86Mail", function()
			awful.util.spawn(terminal .. " -T alot -e alot")
		end),
	awful.key({ }, "XF86HomePage", function()
			awful.util.spawn("google-chrome-stable")
		end),
	awful.key({ }, "XF86Messenger", function()
			awful.util.spawn(terminal .. " -T weechat -e weechat-curses")
		end),
	awful.key({ }, "XF86Tools", function()
			awful.util.spawn(terminal .. " -T ncmpcpp -e ncmpcpp")
		end),
	awful.key({ }, "XF86AudioPlay", function()
			awful.util.spawn("mpc toggle")
		end),
	awful.key({ }, "XF86AudioPrev", function()
			awful.util.spawn("mpc prev")
		end),
	awful.key({ }, "XF86AudioNext", function()
			awful.util.spawn("mpc next")
		end),
	awful.key({ }, "XF86AudioStop", function()
			awful.util.spawn("mpc stop")
		end),
	awful.key({ }, "XF86AudioLowerVolume", function()
                        io.popen("ponymix --max-volume 150 decrease 3"):read("*a")
			vicious.force({ volicon,volstatus })
		end),
	awful.key({ }, "XF86AudioRaiseVolume", function()
                        io.popen("ponymix --max-volume 150 increase 1"):read("*a")
			vicious.force({ volicon,volstatus })
		end),
	awful.key({ }, "XF86AudioMute", function()
                        io.popen("ponymix toggle"):read("*a")
			vicious.force({ volicon,volstatus })
		end),
	awful.key({ }, "XF86Documents", function()
			awful.util.spawn(terminal)
		end),
	awful.key({ }, "XF86Pictures", function()
			awful.util.spawn("imgscan.sh")
		end),
        awful.key({ modkey }, "s", function()
			awful.util.spawn("screen.sh single")
		end),
        awful.key({ modkey, "Shift" }, "s", function()
			awful.util.spawn("screen.sh")
		end),
	awful.key({ }, "XF86Calculator", function()
			awful.util.spawn(terminal .. " -T orpie -e orpie")
		end)
)
