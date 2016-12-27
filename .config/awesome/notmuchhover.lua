local string = string
local tostring = tostring
local io = io
local print = print
local os = os
local table = table
local pairs = pairs
local capi = {
    mouse = mouse,
    screen = screen
}
local json = require("json")
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require('beautiful')
local notmuchhover = {}

local popup
local thread_format = "<span color='" .. beautiful.fg_normal .. "'>%s: </span><span color='" .. beautiful.fg_focus .."'>%s </span><span color='" .. beautiful.fg_normal .."'>%s </span><span color='" .. beautiful.fg_urgent .."'>(%s)</span>"

function notmuchhover.addToWidget(mywidget, querystring, maxcount)
  mywidget:connect_signal('mouse::enter', function ()
        notmuchhover.isread = "notmuch tag -inbox -unread is:unread .." .. os.time()
        local info = notmuchhover.read_index(querystring,maxcount)
        popup = naughty.notify({
                fg = beautiful.fg_urgent,
                title = querystring,
                text = string.format("<span color='%s'>%s</span>",beautiful.fg_normal,info),
                timeout = 0,
                screen = capi.mouse.screen,
                position = "bottom_right"
        })
  end)
  mywidget:connect_signal('mouse::leave', function ()
    naughty.destroy(popup)
    notmuchhover.isread = nil
  end)
end
function notmuchhover.read_index(querystring,maxcount)
    local info = ""
    local count = 0

    local f = io.popen("notmuch search --format=json "..querystring)
    local out = f:read("*all")
    f:close()
    local threads = json.decode(out)

    for num,thread in pairs(threads) do
        if count == maxcount then break else count = count +1 end
        local date = os.date("%c",thread["timestamp"])
        local subject = thread["subject"]
        subject = string.gsub(subject, "<(.*)>","<%1>")
        local authors = thread["authors"]
        authors = string.gsub(authors, "<(.*)>","")
        local tags = table.concat(thread["tags"],', ')

        info = info .. string.format(thread_format,date,authors,subject,tags) .. '\n' 
    end
   return info
end

return notmuchhover
