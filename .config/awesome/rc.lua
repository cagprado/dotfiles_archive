-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local vicious = require("vicious")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

local keydoc = require("keydoc")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/cagprado/.config/awesome/themes/caio/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "roxterm"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper[s], s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
local tags = {}
if screen.count() > 1 then
  tags[1] = awful.tag({ "main", "talk", "tests", "var" }, 1, layouts[2])
  tags[2] = awful.tag({ "net", "view", "articles" }, 2, layouts[2])
  for s = 3,screen.count() do
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[2])
  end
else
  tags[1] = awful.tag({ "main", "net", "talk", "view", "articles", "tests", "var" }, 1, layouts[2])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
                                     
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox

-- Separator
sep = wibox.widget.imagebox()
sep:set_image(beautiful.widget_sep)

-- Clock widget
dofile("/home/cagprado/.config/awesome/clock.lua")

-- System widgets
dofile("/home/cagprado/.config/awesome/sys.lua")

-- Disk free space widget
dofile("/home/cagprado/.config/awesome/udisks.lua")

-- Network usage widget
dofile("/home/cagprado/.config/awesome/net.lua")

-- Volume widget
dofile("/home/cagprado/.config/awesome/vol.lua")

-- Notmuch widget
dofile("/home/cagprado/.config/awesome/mail.lua")

-- Create a wibox for each screen and add it
mywibox = {}
mywibox2 = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 16 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(clockwidget)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)

    mywibox2[s] = awful.wibox({ position = "bottom", screen = s, height = 16 })

    -- Widgets that are aligned to the left
    local left_layout2 = wibox.layout.fixed.horizontal()
    if s == 1 then
      left_layout2:add(wibox.widget.systray())
      left_layout2:add(sep)
    end
    left_layout2:add(cpuicon)
    left_layout2:add(cpugraph)
    left_layout2:add(memicon)
    left_layout2:add(membar)
    left_layout2:add(syssep)
    left_layout2:add(swapbar)
    left_layout2:add(sep)
    left_layout2:add(udisks)
    left_layout2:add(sep)
    left_layout2:add(dnicon)
    left_layout2:add(netwidget)
    left_layout2:add(upicon)

    -- Widgets that are aligned to the right
    local right_layout2 = wibox.layout.fixed.horizontal()
    right_layout2:add(mailicon)
    right_layout2:add(mailtext)
    right_layout2:add(volicon)
    right_layout2:add(volstatus)

    -- Now bring it all together
    local layout2 = wibox.layout.align.horizontal()
    layout2:set_left(left_layout2)
    layout2:set_right(right_layout2)

    mywibox2[s]:set_widget(layout2)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    keydoc.group("Tag Manipulation"),
      awful.key({ modkey,           }, "Escape", awful.tag.history.restore, "Switch to previous tag"),
      awful.key({ modkey,           }, "Left",   awful.tag.viewprev       , "Switch to left tag"),
      awful.key({ modkey,           }, "Right",  awful.tag.viewnext       , "Switch to right tag"),

    keydoc.group("Focus"),
      awful.key({ modkey,           }, "j",
          function ()
              awful.client.focus.byidx( 1)
              if client.focus then client.focus:raise() end
          end,"Focus next window"),
      awful.key({ modkey,           }, "k",
          function ()
              awful.client.focus.byidx(-1)
              if client.focus then client.focus:raise() end
          end,"Focus previous window"),
      awful.key({ modkey,           }, "w", function () mymainmenu:show() end),
      awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,"Focus next screen"),
      awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,"Focus previous screen"),
      awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,"Jump to urgent client"),
      awful.key({ modkey,           }, "Tab",
          function ()
              awful.client.focus.history.previous()
              if client.focus then
                  client.focus:raise()
              end
          end,"Focus last window"),
      awful.key({ modkey, "Control" }, "n", awful.client.restore,"Restore minimized clients"),

    keydoc.group("Layout Manipulation"),
      awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,"Swap with next window"),
      awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,"Swap with previous window"),
      awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end,"Increase master width factor"),
      awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end,"Decrease master width factor"),
      awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end,"Increase number of masters"),
      awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end,"Decrease number of masters"),
      awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end,"Increase number of columns"),
      awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end,"Decrease number of columns"),
      awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end,"Next Layout"),
      awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end,"Previous Layout"),

    keydoc.group("Misc"),
      awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end,"Open terminal"),
      awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end,"Run prompt"),
      awful.key({ modkey }, "x",
                function ()
                    awful.prompt.run({ prompt = "Run Lua code: " },
                    mypromptbox[mouse.screen].widget,
                    awful.util.eval, nil,
                    awful.util.getdir("cache") .. "/history_eval")
                end,"Run Lua code prompt"),
      awful.key({ modkey, "Shift" }, "r", function() menubar.show() end,"Show Menubar"),
      awful.key({ modkey }, "F1", keydoc.display, "Display this help"),
      awful.key({ modkey, "Control" }, "r", awesome.restart,"Restart Awesome"),
      awful.key({ modkey, "Shift"   }, "q", awesome.quit,"Quit Awesome")
)

keydoc.group("Client Manipulation")
clientkeys = awful.util.table.join(
      awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end,"Toggle Fullscreen"),
      awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,"Kill client"),
      awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,"Toggle Floating"),
      awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,"Raise window"),
      awful.key({ modkey,           }, "n",
          function (c)
              -- The client currently has the input focus, so it cannot be
              -- minimized, since minimized clients can't have the focus.
              c.minimized = true
          end,"Minimize window"),
      awful.key({ modkey,           }, "m",
          function (c)
              c.maximized_horizontal = not c.maximized_horizontal
              c.maximized_vertical   = not c.maximized_vertical
          end,"Maximize window"),
      awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,"Swap with Master"),
      awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ,"Move to next screen")
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        keydoc.group("Tag Manipulation"),
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end,i==1 and "Display only this tag" or nil),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end,i==1 and "Toggle display of this tag" or nil),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end,i==1 and "Move window to this tag" or nil),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end,i==1 and "Toggle this tag on window" or nil))
end

-- My own keybindings
dofile("/home/cagprado/.config/awesome/keys.lua")

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Return tag by querying name
function tagsbyname(name)
  for i,a in pairs(tags) do
    for j,v in pairs(a) do
      if v.name == name then return v end
    end
  end
end

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "mpv" },
      properties = { fullscreen = false } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "feh" },
      properties = { floating = true } },
    { rule = { class = "google-chrome" },
      properties = { tag = tagsbyname("net") } },
    { rule = { class = "Canvas" },
      properties = { tag = tagsbyname("view") } },
    { rule = { name = "Mendeley Desktop" },
      properties = { tag = tagsbyname("articles") } },
    { rule = { name = "weechat" },
      properties = { tag = tagsbyname("talk") } },
    { rule = { class = "Skype" },
      properties = { tag = tagsbyname("talk") } },
    { rule = { class = "Exe" },
      properties = { floating = true } },
    { rule = { class = "VidyoDesktop" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    --[[
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)
    --]]

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Startup programs
awful.util.spawn("startup.sh")
-- }}}
