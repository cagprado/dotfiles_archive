local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local vicious = require("vicious")

-- udisks widgets
udisks = wibox.layout.fixed.horizontal()

-- device lists
local removable_list = {}
local system_list = {}

-- Create removable widget
local function addremovable (device,mount,label,usb)
  local icon = wibox.widget.imagebox()
  local fsinfo
  icon:set_image(device == "/dev/sr0" and beautiful.widget_cdrom or beautiful.widget_pen)
  icon:connect_signal('mouse::enter', function()
    fsinfo = naughty.notify({
      fg = beautiful.fg_urgent,
      title = label,
      text = "<span color='" .. beautiful.fg_normal .. "'>" .. device .. " mounted on " .. mount .. (usb and ("\nUSB Port: " .. usb) or "") .. "</span>",
      timeout = 0,
      screen = mouse.screen,
      position = "bottom_left"
    })

  end)
  icon:connect_signal('mouse::leave', function() naughty.destroy(fsinfo) end)
  icon:buttons(awful.util.table.join(awful.button({ }, 1, function()
    os.execute("umount " .. device)
  end)))
  udisks:add(icon)

  if device ~= "/dev/sr0" then
    local text = wibox.widget.textbox()
    vicious.register(text,vicious.widgets.fs, "${" .. mount .. " avail_gb} GB", 19)
    text:buttons(awful.util.table.join(awful.button({ }, 1, function()
      os.execute("umount " .. device)
    end)))
    udisks:add(text)
  end
end

-- Create removable widgets from device list
local function create_removable ()
  local mount,label,system

  for _,device in pairs(removable_list) do
    local fd = io.popen("udisks --show-info " .. device)
    for line in fd:lines() do
      mount = mount or string.match(line,"mount paths:%s*([^$]*)")
      label = label or string.match(line,"label:%s*([^$]*)")
      system = system or string.match(line,"native%-path:.*usb%d/.-/(.-)/")
    end
    fd:close()
    addremovable(device,mount,label,system)
  end
end

-- Mouse over system widgets
local fsinfo
local function mouseover()
  local fd = io.popen("findmnt -t ext2,ext3,ext4,fuseblk,vfat -o TARGET,AVAIL,USED,USE%,SIZE")
  local info = fd:read("*a")
  fd:close()

  fsinfo = naughty.notify({
    fg = beautiful.fg_urgent,
    title = "File System Information",
    text = string.format("<span font_desc='%s' color='%s'>%s</span>",monofont,beautiful.fg_normal,info);
    timeout = 0,
    screen = mouse.screen,
    position = "bottom_left"
  })
end

-- Create system widget
local function addsystem(device,mount,label)
  local icon = wibox.widget.imagebox()
  if mount == "/" then
    icon:set_image(beautiful.widget_root)
  elseif mount == "/boot" then
    icon:set_image(beautiful.widget_boot)
  elseif mount == "/home" then
    icon:set_image(beautiful.widget_home)
  else
    icon:set_image(beautiful.widget_hd)
  end

  icon:connect_signal('mouse::enter', mouseover)
  icon:connect_signal('mouse::leave', function() naughty.destroy(fsinfo) end)
  udisks:add(icon)

  local text = wibox.widget.textbox()
  vicious.register(text,vicious.widgets.fs,
      "${" .. mount .. " avail_" .. ((mount == "/boot") and "mb} MB" or "gb} GB"), 19)
  text:connect_signal('mouse::enter',mouseover)
  text:connect_signal('mouse::leave', function() naughty.destroy(fsinfo) end)
  udisks:add(text)
end

-- Create system widgets from device list
local function create_system ()
  for _,v in pairs(system_list) do
    addsystem(v.device,v.mount,v.label)
  end
end

-- Update status of data.path (mounted/umounted)
local function fs_update (data)
  local device = "/dev/" .. string.match(data.path,"[^/]*$")

  -- find out information
  local mount,label,system

  local fd = io.popen("udisks --show-info " .. device)
  for line in fd:lines() do
    mount = mount or string.match(line,"mount paths:%s*([^$]*)")
    label = label or string.match(line,"label:%s*([^$]*)")
    system = system or string.match(line,"native%-path:.*usb%d/.-/(.-)/")
  end
  fd:close()

  -- Decide what to do
  if mount == "" then -- Not mounted
    for i,v in pairs(removable_list) do
      if device == v then
        table.remove(removable_list,i)
        udisks:reset()
        create_system()
        create_removable()
      end
    end
  else -- Mounted
    table.insert(removable_list,device)
    addremovable(device,mount,label,system)
  end
end

-- FIRST RUN: Generate lists
local fd = io.popen("udisks --dump")
local devices = {}

local i=0
for line in fd:lines() do
  local name = string.match(line,"device%-file:%s*([^$]*)")
  if name then
    i = i+1
    devices[i] = { name = name }
  elseif i>0 then
    devices[i].internal = devices[i].internal or tonumber(string.match(line,"system internal:%s*([^$]*)"))
    devices[i].mount = devices[i].mount or string.match(line,"mount paths:%s*([^$]*)")
    devices[i].label = devices[i].label or string.match(line,"label:%s*([^$]*)")
    devices[i].system = devices[i].system or string.match(line,"native%-path:.*usb%d/.-/(.-)/")
  end
end
fd:close()

for i=1,#devices do
  if devices[i].mount ~= "" then
    if devices[i].internal == 1 then
      table.insert(system_list, { device = devices[i].name, mount = devices[i].mount, label = devices[i].label})
    else
      table.insert(removable_list,devices[i].name)
    end
  end
end

create_system()
create_removable()

-- Listen to dbus signals from UDisks
dbus.add_match("system","type='signal',interface='org.freedesktop.UDisks.Device',member='Changed'")
dbus.connect_signal("org.freedesktop.UDisks.Device", fs_update)
