#!/usr/bin/env lua
--[[
  Author: Caio Prado
  Created: 2011 Aug 22
  Updated:
--]]
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local vicious = require("vicious")

-- Assuming “Arch Linux”
local fd

fd = io.popen("uname -n")
local hostname = fd:read()
fd:close()

fd = io.popen("uname -m")
local arch = fd:read()
fd:close()

fd = io.popen("uname -sr")
local kernel = fd:read()
fd:close()

fd = io.popen("id -un")
local username = fd:read()
fd:close()

-- Mouse over function
local function sysOver()
  fd = io.popen("uptime")
  local uptime = string.match( fd:read(), ".-up (.-),%s-%d user")
  fd:close()
  
  fd = io.popen("ps -eo pcpu,comm --sort -pcpu --no-header")
  local cpuusage = ""
  for line=1,4 do
    cpuusage = cpuusage .. "\n\t" .. fd:read()
  end
  fd:close()

  fd = io.popen("ps -eo pmem,comm --sort -rss --no-header")
  local memusage = ""
  for line=1,4 do
    memusage = memusage .. "\n\t" .. fd:read()
  end
  fd:close()

  -- Now this might need some tune elsewhere
  ---[=[
  -- hwmon0: CPU, MB
  local hwmonpath = "/sys/class/hwmon/hwmon0/"

  fd = io.open(hwmonpath .. "temp1_input")
  local CPUtemp = fd and fd:read() / 1000 or ""
  if fd then fd:close() end

  fd = io.open(hwmonpath .. "temp2_input")
  local MBtemp = fd and fd:read() /1000 or ""
  if fd then fd:close() end
  
  fd = io.open(hwmonpath .. "fan1_input")
  local CPUfan = fd and fd:read() or ""
  if fd then fd:close() end

  --[=[ hwmon2: ATI video
  hwmonpath = "/sys/class/hwmon/hwmon2/"
  fd = io.open(hwmonpath .. "temp1_input")
  local VIDEOtemp = fd and fd:read() / 1000 or ""
  if fd then fd:close() end
  --]=]

  ---[=[ nvidia-smi: NVidia video
  fd = io.popen("nvidia-smi -q -d TEMPERATURE | grep 'GPU Current Temp' | cut -c39-40")
  local VIDEOtemp = fd and fd:read() or ""
  if fd then fd:close() end
  --]=]
  
  info = [[
KERNEL, ARCHTYPE

<span color='FG_FOCUS'>User:</span> USERNAME
<span color='FG_FOCUS'>Uptime:</span> UPTIME
]]
---[=[ This may not work
.. "\n<span color='FG_FOCUS'>• Temperatures:</span>\n"
.. "	CPU: CPUTEMP°C\n"
--.. "	MB: MBTEMP°C\n"
.. "	VIDEO: VIDEOTEMP°C\n"
--.. "\n<span color='FG_FOCUS'>• Fans:</span>\n	CPU: CPUFANRPM\n"
--]=]
.. [[

<span color='FG_FOCUS'>• CPU usage:</span>CPUUSAGE

<span color='FG_FOCUS'>• MEM usage:</span>MEMUSAGE]]

  ---[=[ Battery information
  fd = io.popen("acpi -b")
  local output = fd and fd:read() or "Battery 0: Disconnected, 0% --:--:--"
  fd:close()

  local state,charge = string.match(output, "Battery 0: (%a+), (%d+)%%")
  local remain
  if state == "Unknown" then
    state = "Charged"
    remain = "--:--:--"
  else
    remain = string.match(output,"%d%d:%d%d:%d%d") or ""
  end

  -- Fill info
  info = info .. [[


<span color='FG_FOCUS'>• Battery State:</span>
	BATSTATE: BATPERCENT%
	Remaining: BATTIME]]
  info = string.gsub(info,"BATSTATE",state)
  info = string.gsub(info,"BATPERCENT",charge)
  info = string.gsub(info,"BATTIME",remain)
  --]=]
  
  info = string.gsub(info,"KERNEL",kernel)
  info = string.gsub(info,"ARCHTYPE",arch)
  info = string.gsub(info,"USERNAME",username)
  info = string.gsub(info,"UPTIME",uptime)
  info = string.gsub(info,"CPUTEMP",CPUtemp)
  info = string.gsub(info,"MBTEMP",MBtemp)
  info = string.gsub(info,"VIDEOTEMP",VIDEOtemp)
  info = string.gsub(info,"CPUFAN",CPUfan)
  info = string.gsub(info,"CPUUSAGE",cpuusage)
  info = string.gsub(info,"MEMUSAGE",memusage)
  info = string.gsub(info,"FG_FOCUS",beautiful.fg_focus)

  sysinfo = naughty.notify({
    fg = beautiful.fg_urgent,
    title = "Arch Linux - " .. hostname,
    text = string.format("<span color='%s'>%s</span>",beautiful.fg_normal,info),
    timeout = 0,
    screen = mouse.screen,
    position = "bottom_left"
  })
end

-- CPU widget
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)

cpugraph = awful.widget.graph({ width=30, height=16 })
cpugraph:set_background_color(beautiful.bg_widget)
cpugraph:set_color(beautiful.fg_widget)
vicious.register(cpugraph, vicious.widgets.cpu, "$1", 2)

-- MEM/SWAP widget
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)

membar = awful.widget.progressbar({ width=7, height=16 })
membar:set_vertical(true)
membar:set_background_color(beautiful.bg_widget)
membar:set_color(beautiful.fg_widget)
membar:set_ticks(true)
membar:set_ticks_gap(1)
membar:set_ticks_size(3)
vicious.register(membar, vicious.widgets.mem, "$1", 3)

syssep = wibox.widget.textbox()
syssep:set_text(" ")

swapbar = awful.widget.progressbar({ width=7, height=16 })
swapbar:set_vertical(true)
swapbar:set_background_color(beautiful.bg_widget)
swapbar:set_color(beautiful.fg_widget)
swapbar:set_ticks(true)
swapbar:set_ticks_gap(1)
swapbar:set_ticks_size(3)
vicious.register(swapbar, vicious.widgets.mem, "$5", 3)

cpuicon:connect_signal('mouse::enter', sysOver)
cpuicon:connect_signal('mouse::leave', function() naughty.destroy(sysinfo) end)
cpugraph:connect_signal('mouse::enter', sysOver)
cpugraph:connect_signal('mouse::leave', function() naughty.destroy(sysinfo) end)
memicon:connect_signal('mouse::enter', sysOver)
memicon:connect_signal('mouse::leave', function() naughty.destroy(sysinfo) end)
membar:connect_signal('mouse::enter', sysOver)
membar:connect_signal('mouse::leave', function() naughty.destroy(sysinfo) end)
swapbar:connect_signal('mouse::enter', sysOver)
swapbar:connect_signal('mouse::leave', function() naughty.destroy(sysinfo) end)
