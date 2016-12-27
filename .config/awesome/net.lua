--[[
  File: net.lua
  Author: Caio Prado

  This file is meant to be executed by awesome configuration file (rc.lua).
  It defines three widgets: netwidget, dnicon, upicon
   - [dn/up]icon: icons using beautiful theme (define them there)
   - netwidget: Show stats of devices (download/upload in kB). When clicked
     it changes the device showed (popup a notification). Also when the
     mouse is over it, it shows some information about all devices and
     connections.
  
  Depends on: beautiful, awful, naughty
              iproute2: for network info
              wireless_tools: for wireless info
              /proc/net/dev_snmp6: not really sure what provides this
                (probably kernel itself) but this is where it gets
                all network device names.
  External config:
    beautiful.widget_net   = image in theme file
    beautiful.widget_netup = image in theme file
--]]
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local vicious = require("vicious")

colordown = beautiful.fg_widget or "#ffffff"
colorup = beautiful.fg_widget_alt or "#ffffff"

-- Functions to convert between CIDR to subnet mask
local function Bin2Dec(bin)
  local dec = 0
  for i= 1, #bin do
    dec = dec + tonumber(bin:sub(-i,-i)) * 2^(i-1)
  end

  return dec
end

local function subnet2mask(subnet)
  local string = string.rep("1",subnet) .. string.rep("0",32 - subnet)
  
  return
    tostring(Bin2Dec(string:sub(1,8))) .. "." ..
    tostring(Bin2Dec(string:sub(9,16))) .. "." ..
    tostring(Bin2Dec(string:sub(17,24))) .. "." ..
    tostring(Bin2Dec(string:sub(25,32)))
end

-- Get all network devices information
local function GetNetInfo()
  netdev = {}

  -- IP, subnet, gateway
  local dev = io.popen("ls /proc/net/dev_snmp6")
  for device in dev:lines() do
    if device ~= "lo" then
      local props = io.popen("ip route show dev " .. device)
      local output = props:read("*a")
      props:close()

      netdev[device] = {}
      local subnet
      netdev[device].gateway = string.match(output, "^default via (%d+.%d+.%d+.%d+)")
      subnet, netdev[device].ip = string.match(output, "%d+.%d+.%d+.%d+/(%d+).-src (%d+.%d+.%d+.%d+)")
      if subnet then netdev[device].mask = subnet2mask(subnet) end

      props = io.popen("iw dev " .. device .. " link 2>/dev/null")
      output = props:read("*a")
      props:close()
      netdev[device].essid = string.match(output, "SSID: (.-)\n")

      props = io.popen("cat /proc/net/wireless")
      output = props:read("*a")
      props:close()
      local quality = string.match(output,device .. ".-(%d+)%.")

      if quality then
        quality = math.floor(100*quality/70) .. "%"
        netdev[device].link = quality
      end
    end
  end
  dev:close()

  -- DNS servers
  DNS = {}
  local resolv = io.open("/etc/resolv.conf")
  for line in resolv:lines() do
    DNS[#DNS + 1] = string.match(line, "^nameserver%s*(.+)")
  end
  resolv:close()
end

-- START
GetNetInfo()
netwidget = wibox.widget.textbox()
dnicon = wibox.widget.imagebox()
upicon = wibox.widget.imagebox()
dnicon:set_image(beautiful.widget_net)
upicon:set_image(beautiful.widget_netup)

local function start_netwidget ()
  local dev = {}
  for k in pairs(netdev) do
    dev[#dev+1] = k
  end
  local i = 1

  return function ()
    vicious.unregister(netwidget)
    vicious.register(netwidget, vicious.widgets.net,
      "<span color='" .. colordown .. "'>${" .. dev[i] .. " down_kb}</span>" ..
      " " .. 
      "<span color='" .. colorup .. "'>${" .. dev[i] .. " up_kb}</span>",
      3)
    naughty.notify({
      timeout = 1,
      screen = mouse.screen,
      position = "bottom_left",
      text = string.format("<span color='%s'>Showing " .. dev[i] .. " stats…</span>",beautiful.fg_focus)
    })
    i = i+1
    if i > #dev then i = 1 end
  end
end
local netwidget_change_dev = start_netwidget()
netwidget_change_dev() -- initialize

-- Clicking on widget will change device showed
netwidget:buttons(awful.util.table.join(
   awful.button({ }, 0, netwidget_change_dev)
  ))
upicon:buttons(awful.util.table.join(
   awful.button({ }, 0, netwidget_change_dev)
  ))
dnicon:buttons(awful.util.table.join(
   awful.button({ }, 0, netwidget_change_dev)
  ))

-- Mouse over will display some network information
local function netOver()
  GetNetInfo()
  
  local info = ""
  for k in pairs(netdev) do
    if not netdev[k].ip then
      info = info .. string.format("\n<span color='%s'>• %s:</span> Not Connected…",beautiful.fg_focus,k)
    else
      info = info .. string.format("\n<span color='%s'>• %s:</span>\n",beautiful.fg_focus,k) ..
      "\tIP: " .. netdev[k].ip
      if netdev[k].mask then info = info .. "\n\tMask: " .. netdev[k].mask end
      if netdev[k].gateway then info = info .. "\n\tGateway: " .. netdev[k].gateway end
      if netdev[k].essid then info = info .. "\n\tSSID: " .. netdev[k].essid end
      if netdev[k].link then info = info .. "\n\tQuality: " .. netdev[k].link end
    end
    info = info .. "\n"
  end

  if #DNS > 0 then info = info .. string.format("\n<span color='%s'>• DNS Servers:</span>",beautiful.fg_focus) end
  for i,v in ipairs(DNS) do
    info = info .. "\n\t" .. v
  end

  netinfo = naughty.notify({
    fg = beautiful.fg_urgent,
    title = "Network Information",
    text = string.format("<span color='%s'>%s</span>",beautiful.fg_normal,info),
    timeout = 0,
    screen = mouse.screen,
    position = "bottom_left"
  })
end

netwidget:connect_signal('mouse::enter', netOver)
dnicon:connect_signal('mouse::enter', netOver)
upicon:connect_signal('mouse::enter', netOver)
netwidget:connect_signal('mouse::leave', function() naughty.destroy(netinfo) end)
dnicon:connect_signal('mouse::leave', function() naughty.destroy(netinfo) end)
upicon:connect_signal('mouse::leave', function() naughty.destroy(netinfo) end)
