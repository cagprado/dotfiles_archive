#!/usr/bin/env lua
--[[
	Author: Caio Prado
	Created: 2012 Apr 08
	Updated:
--]]

require("json")

local id = io.read()

local fd = io.popen("notmuch show --format=json id:"..id)
local msg = json.decode(fd:read("*a"))
fd:close()

-- Body of the message
local body = msg[1][1][1]['body']

-- Function to find ids of images
local function findkey(tab,key,value)
  -- find image in this level
  local id = {}
  if tab[key] and string.find(tab[key],value) then
    table.insert(id,tab['id'])
  end

  -- descend level
  for _,v in pairs(tab) do
    if type(v) == 'table' then
      local tempid = {findkey(v,key,value)}
      for _,v in ipairs(tempid) do
        table.insert(id,v)
      end
    end
  end

  return unpack(id)
end
local parts = {findkey(body,"content-type","image")}

-- Is there any image to show?
if #parts == 0 then return 1 end

-- Create image temporary files
os.execute("mkdir -p /tmp/inline_img")
filenames = {}
for i,v in ipairs(parts) do
  filenames[i] = "/tmp/inline_img/"..id.."_"..v..".png"
  local fd = io.open(filenames[i],"w")
  local pd = io.popen("notmuch show --part="..v.." id:"..id)
  fd:write(pd:read("*a"))
  fd:close()
  pd:close()
end

os.execute("geeqie -f /tmp/inline_img")
os.execute("rm -rf /tmp/inline_img/")
