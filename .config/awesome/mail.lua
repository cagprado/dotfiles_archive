#!/usr/bin/env lua
querystring = "is:unread"

local notmuch = require("notmuch")
local notmuchhover = require("notmuchhover")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local vicious = require("vicious")

local function dirEmpty (dirname)
  local fd = io.popen("find " .. dirname .. " -maxdepth 0 -empty")
  local output = fd:read()
  fd:close()
  return output and true or false
end

mailicon = wibox.widget.imagebox()
mailicon:set_image(beautiful.widget_mail)

mailtext = wibox.widget.textbox()
vicious.register(mailtext, notmuch,
    function (widget, args) return args["count"] end,
  10, querystring)

local function mail_spawn ()
  awful.util.spawn("roxterm -T alot -e alot")
end

local function removeread ()
  local isread = notmuchhover.isread
  if isread then awful.util.spawn(isread) end
  vicious.force({ mailtext })
end

local function retrySend ()
  awful.util.spawn("msmtp-queue -r")
end

mailtext:buttons(awful.util.table.join(awful.button({ }, 1, mail_spawn),
                                       awful.button({ }, 2, retrySend),
                                       awful.button({ }, 3, removeread)))
mailicon:buttons(awful.util.table.join(awful.button({ }, 1, mail_spawn),
                                       awful.button({ }, 2, retrySend),
                                       awful.button({ }, 3, removeread)))
notmuchhover.addToWidget(mailicon,querystring,30)
notmuchhover.addToWidget(mailtext,querystring,30)

local timer = timer({ timeout = 30 })
timer:connect_signal('timeout',function ()
  if dirEmpty("/home/cagprado/.msmtp.queue") then
    mailicon:set_image(beautiful.widget_mail)
  else
    mailicon:set_image(beautiful.widget_mailerror)
  end
end)
timer:start()
