local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local vicious = require("vicious")

udisks = wibox.layout.fixed.horizontal()
local devices = {}

-- Get all udisks device names
local fd = assert(io.popen("udisks --enumerate"))
for line in fd:lines() do
  local name = string.match(line,".*/([^$]*)")
  if name and name ~= "fd0" then
    table.insert(devices,{name = name})
  end
end
fd:close()

-- For each device, get properties
for _,dev in ipairs(devices) do
  fd = assert(io.popen("udisks --show-info /dev/"..dev.name))
  for line in fd:lines() do
    local prop
    prop = tonumber(string.match(line,"system internal:%s*([^$]*)"))
    if prop then dev.internal = prop end
    prop = string.match(line,"mount paths:%s*([^$]*)")
    if prop and prop ~= "" then dev.mount = prop end
    prop = string.match(line,"label:%s*([^$]*)")
    if prop and prop ~= "" then dev.label = prop end
    prop = string.match(line,"native%-path:.*usb%d/.-/(.-)/")
    if prop and prop ~= "" then dev.usb = prop end
  end
  fd:close()
end

-- Get rid of unmounted devices
local function clearUnmounted(devices)
  local toremove = {}
  for i,dev in ipairs(devices) do
    if not dev.mount then
      table.insert(toremove,i)
    end
  end

  table.sort(toremove, function (a,b) return a>b end)
  for _,i in ipairs(toremove) do
    table.remove(devices,i)
  end
end
clearUnmounted(devices)

-- Sort the devices: internal by mount point
--                   removable by dev name
local function sortdevs(devices)
  table.sort(devices, function(a,b)
    if a.internal == b.internal then
      if a.internal == 1 then
        return a.mount < b.mount
      else
        return a.name < b.name
      end
    else
      return a.internal > b.internal
    end
  end)
end
sortdevs(devices)

-- Mouse Over Widget function
local function mouseover(dev)
  local fd = io.popen("findmnt -ln -o SOURCE,AVAIL,USED,USE%,SIZE '" .. dev.mount .. "'")
  local info = fd:read("*l")
  fd:close()

  if not info then
    for i,d in ipairs(devices) do
      if d.name == dev.name then
        table.remove(devices,i)
        break
      end
    end
    return
  end
  local source,avail,used,perc,size = string.match(info,
    "([^%s]*)%s*([^%s]*)%s*([^%s]*)%s*([^%s]*)%s*([^$]*)%s*")

  local focus = "<span color = '".. beautiful.fg_focus .."'>"
  local text = string.format("\n%s• Free:</span>\t%s",focus,avail)
  text = text .. string.format("\n%s• Used:</span>\t%s (%s)",focus,used,perc)
  text = text ..string.format("\n%s• Total:</span>\t%s",focus,size)

  local fsinfo = naughty.notify({
    fg = beautiful.fg_urgent,
    title = source .. " mounted on " .. dev.mount,
    text = "<span color='" .. beautiful.fg_normal .. "'>" .. text .. "</span>",
    timeout = 0,
    screen = mouse.screen,
    position = "bottom_left"
  })

  return fsinfo
end

-- Construct widgets
local function updateWidgets(devices)
  udisks:reset()

  -- Fill size and usage info
  local fd = assert(io.popen("findmnt -lnt ext2,ext3,ext4,fuseblk,vfat,iso9660 -o TARGET,AVAIL"))
  for line in fd:lines() do
    local dev,free = string.match(line,"^(.*[^%s])%s+([^%s]+)$")
    for _,t in ipairs(devices) do
      if t.mount == dev then
        t.free = free
      end
    end
  end
  fd:close()

  for _,dev in ipairs(devices) do
    -- Select icon image
    local icon = wibox.widget.imagebox()
    if dev.name == "sr0" then
      icon:set_image(beautiful.widget_cdrom)
    elseif dev.internal == 0 then
      icon:set_image(beautiful.widget_pen)
    elseif dev.mount == "/" then
      icon:set_image(beautiful.widget_root)
    elseif dev.mount == "/boot" then
      icon:set_image(beautiful.widget_boot)
    elseif dev.mount == "/home" then
      icon:set_image(beautiful.widget_home)
    elseif dev.mount == "/mnt/win" then
      icon:set_image(beautiful.widget_win)
    else
      icon:set_image(beautiful.widget_hd)
    end

    -- Click to unmount removable devices
    if dev.internal == 0 then
      icon:buttons(awful.util.table.join(awful.button({ }, 1, function()
        os.execute("umount " .. dev.mount)
      end)))
    end

    -- Mouse over signals
    local fsinfo
    icon:connect_signal('mouse::enter', function() fsinfo = mouseover(dev) end)
    icon:connect_signal('mouse::leave', function() naughty.destroy(fsinfo) end)
  
    -- Write widget
    udisks:add(icon)

    -- If not CDRom… create text widget of free space
    if dev.name ~= "sr0" then
      local text = wibox.widget.textbox()
      text:set_text(dev.free or "?")

      -- Click to unmount removable devices
      if dev.internal == 0 then
        text:buttons(awful.util.table.join(awful.button({ }, 1, function()
          os.execute("umount " .. dev.mount)
        end)))
      end

      -- Mouse over signals
      text:connect_signal('mouse::enter', function() fsinfo = mouseover(dev) end)
      text:connect_signal('mouse::leave', function() naughty.destroy(fsinfo) end)

      -- Write widget
      udisks:add(text)
    end
  end

  -- Check NFS mount
  fd = io.open("/home/cagprado/.config/awesome/nas")
  if fd then
    local target,source,avail,used,perc,size = string.match(fd:read("*a"),
      "([^%s]*)%s*([^%s]*)%s*([^%s]*)%s*([^%s]*)%s*([^%s]*)%s*([^$]*)%s*")
    fd:close()

    local icon = wibox.widget.imagebox()
    icon:set_image(beautiful.widget_hd)
    icon:buttons(awful.util.table.join(awful.button({ }, 1, function()
      os.execute("umount -l " .. target)
      awful.util.spawn("ssh root@nas poweroff")
      os.remove("/home/cagprado/.config/awesome/nas")
      updateWidgets(devices)
    end)))

    local text = wibox.widget.textbox()
    text:set_text(avail or "?")
    text:buttons(awful.util.table.join(awful.button({ }, 1, function()
      os.execute("umount -l " .. target)
      awful.util.spawn("ssh root@nas poweroff")
      os.remove("/home/cagprado/.config/awesome/nas")
      updateWidgets(devices)
    end)))

    -- Mouse over signals
    local fsinfo
    function nfsOver()
      local focus = "<span color = '".. beautiful.fg_focus .."'>"
      local text = string.format("\n%s• Free:</span>\t%s",focus,avail)
      text = text .. string.format("\n%s• Used:</span>\t%s (%s)",focus,used,perc)
      text = text ..string.format("\n%s• Total:</span>\t%s",focus,size)

      fsinfo = naughty.notify({
        fg = beautiful.fg_urgent,
        title = source .. " mounted on " .. target,
        text = "<span color='" .. beautiful.fg_normal .. "'>" .. text .. "</span>",
        timeout = 0,
        screen = mouse.screen,
        position = "bottom_left"
      })
    end
    icon:connect_signal('mouse::enter', nfsOver)
    icon:connect_signal('mouse::leave', function() naughty.destroy(fsinfo) end)
    text:connect_signal('mouse::enter', nfsOver)
    text:connect_signal('mouse::leave', function() naughty.destroy(fsinfo) end)

    udisks:add(icon)
    udisks:add(text)
  end
end
updateWidgets(devices)

local timer = timer({ timeout = 7})
timer:connect_signal('timeout', function () updateWidgets(devices) end)
timer:start()

-- Update devices table
local function fs_update (data)
  local dev = { name = string.match(data.path,"[^/]*$") }

  local fd = assert(io.popen("udisks --show-info /dev/"..dev.name))
  for line in fd:lines() do
    local prop
    prop = tonumber(string.match(line,"system internal:%s*([^$]*)"))
    if prop then dev.internal = prop end
    prop = string.match(line,"mount paths:%s*([^$]*)")
    if prop and prop ~= "" then dev.mount = prop end
    prop = string.match(line,"label:%s*([^$]*)")
    if prop and prop ~= "" then dev.label = prop end
    prop = string.match(line,"native%-path:.*usb%d/.-/(.-)/")
    if prop and prop ~= "" then dev.usb = prop end
  end
  fd:close()

  if dev.mount then
    table.insert(devices,dev)
    sortdevs(devices)
  else
    for i,d in ipairs(devices) do
      if d.name == dev.name then
        table.remove(devices,i)
        break
      end
    end
  end
  updateWidgets(devices)
end

-- Listen to dbus signals from UDisks
dbus.add_match("system","type='signal',interface='org.freedesktop.UDisks.Device',member='Changed'")
dbus.connect_signal("org.freedesktop.UDisks.Device", fs_update)

--
---- device lists
--local removable_list = {}
--local system_list = {}
--
---- Create removable widget
--local function addremovable (device,mount,label,usb)
--  local icon = wibox.widget.imagebox()
--  local fsinfo
--  icon:set_image(device == "/dev/sr0" and beautiful.widget_cdrom or beautiful.widget_pen)
--  icon:connect_signal('mouse::enter', function()
--    fsinfo = naughty.notify({
--      fg = beautiful.fg_urgent,
--      title = label,
--      text = "<span color='" .. beautiful.fg_normal .. "'>" .. device .. " mounted on " .. mount .. (usb and ("\nUSB Port: " .. usb) or "") .. "</span>",
--      timeout = 0,
--      screen = mouse.screen,
--      position = "bottom_left"
--    })
--
--  end)
--  icon:connect_signal('mouse::leave', function() naughty.destroy(fsinfo) end)
--  icon:buttons(awful.util.table.join(awful.button({ }, 1, function()
--    os.execute("umount " .. device)
--  end)))
--  udisks:add(icon)
--
--  if device ~= "/dev/sr0" then
--    local text = wibox.widget.textbox()
--    vicious.register(text,vicious.widgets.fs, "${" .. mount .. " avail_gb} GB", 19)
--    text:buttons(awful.util.table.join(awful.button({ }, 1, function()
--      os.execute("umount " .. device)
--    end)))
--    udisks:add(text)
--  end
--end
--
---- Create removable widgets from device list
--local function create_removable ()
--  local mount,label,system
--
--  for _,device in pairs(removable_list) do
--    local fd = io.popen("udisks --show-info " .. device)
--    for line in fd:lines() do
--      mount = mount or string.match(line,"mount paths:%s*([^$]*)")
--      label = label or string.match(line,"label:%s*([^$]*)")
--      system = system or string.match(line,"native%-path:.*usb%d/.-/(.-)/")
--    end
--    fd:close()
--    addremovable(device,mount,label,system)
--  end
--end
--
---- Mouse over system widgets
--local fsinfo
--local function mouseover()
--  local fd = io.popen("findmnt -t ext2,ext3,ext4,fuseblk,vfat -o TARGET,AVAIL,USED,USE%,SIZE")
--  local info = fd:read("*a")
--  fd:close()
--
--  fsinfo = naughty.notify({
--    fg = beautiful.fg_urgent,
--    title = "File System Information",
--    text = string.format("<span font_desc='%s' color='%s'>%s</span>",monofont,beautiful.fg_normal,info);
--    timeout = 0,
--    screen = mouse.screen,
--    position = "bottom_left"
--  })
--end
--
---- Create system widget
--local function addsystem(device,mount,label)
--  local icon = wibox.widget.imagebox()
--  if mount == "/" then
--    icon:set_image(beautiful.widget_root)
--  elseif mount == "/boot" then
--    icon:set_image(beautiful.widget_boot)
--  elseif mount == "/home" then
--    icon:set_image(beautiful.widget_home)
--  else
--    icon:set_image(beautiful.widget_hd)
--  end
--
--  icon:connect_signal('mouse::enter', mouseover)
--  icon:connect_signal('mouse::leave', function() naughty.destroy(fsinfo) end)
--  udisks:add(icon)
--
--  local text = wibox.widget.textbox()
--  vicious.register(text,vicious.widgets.fs,
--      "${" .. mount .. " avail_" .. ((mount == "/boot") and "mb} MB" or "gb} GB"), 19)
--  text:connect_signal('mouse::enter',mouseover)
--  text:connect_signal('mouse::leave', function() naughty.destroy(fsinfo) end)
--  udisks:add(text)
--end
--
---- Create system widgets from device list
--local function create_system ()
--  for _,v in pairs(system_list) do
--    addsystem(v.device,v.mount,v.label)
--  end
--end
--
---- Update status of data.path (mounted/umounted)
--local function fs_update (data)
--  local device = "/dev/" .. string.match(data.path,"[^/]*$")
--
--  -- find out information
--  local mount,label,system
--
--  local fd = io.popen("udisks --show-info " .. device)
--  for line in fd:lines() do
--    mount = mount or string.match(line,"mount paths:%s*([^$]*)")
--    label = label or string.match(line,"label:%s*([^$]*)")
--    system = system or string.match(line,"native%-path:.*usb%d/.-/(.-)/")
--  end
--  fd:close()
--
--  -- Decide what to do
--  if mount == "" then -- Not mounted
--    for i,v in pairs(removable_list) do
--      if device == v then
--        table.remove(removable_list,i)
--        udisks:reset()
--        create_system()
--        create_removable()
--      end
--    end
--  else -- Mounted
--    table.insert(removable_list,device)
--    addremovable(device,mount,label,system)
--  end
--end
--
---- FIRST RUN: Generate lists
--local i=0
--for line in fd:lines() do
--  local name = string.match(line,"device%-file:%s*([^$]*)")
--  if name then
--    i = i+1
--    devices[i] = { name = name }
--  elseif i>0 then
--    devices[i].internal = devices[i].internal or tonumber(string.match(line,"system internal:%s*([^$]*)"))
--    devices[i].mount = devices[i].mount or string.match(line,"mount paths:%s*([^$]*)")
--    devices[i].label = devices[i].label or string.match(line,"label:%s*([^$]*)")
--    devices[i].system = devices[i].system or string.match(line,"native%-path:.*usb%d/.-/(.-)/")
--  end
--end
--fd:close()
--
--for i=1,#devices do
--  if devices[i].mount ~= "" then
--    if devices[i].internal == 1 then
--      table.insert(system_list, { device = devices[i].name, mount = devices[i].mount, label = devices[i].label})
--    else
--      table.insert(removable_list,devices[i].name)
--    end
--  end
--end
--
--create_system()
--create_removable()
--
---- Listen to dbus signals from UDisks
--dbus.add_match("system","type='signal',interface='org.freedesktop.UDisks.Device',member='Changed'")
--dbus.connect_signal("org.freedesktop.UDisks.Device", fs_update)
