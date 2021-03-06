local sprotoparser = require "sprotoparser"
local proto_config = require "proto_config"

local proto = {}

function split(s,sep)
   local sep = sep or " "
   local fields = {}
   local pattern = string.format("([^%s]+)",sep)
   string.gsub(s,pattern,function(c) fields[#fields+1]=c end)
   return fields
end

local function walk(config)
	local res = ""
	for k,v in pairs(config) do
		local realsproto = string.gsub(v.sproto,"$%d+",function(s)
                local num = tonumber(split(s,"$")[1]) + v.basecode
                return tonumber(num)
		end)
		res = res..v.sproto
	end
	return res
end

function proto:init(gamename)
	proto_config:init(gamename)
	local c2s = walk(proto_config.c2s)
	local s2c = walk(proto_config.s2c)

	self.c2s = sprotoparser.parse(c2s)
	self.s2c = sprotoparser.parse(s2c)
end

return proto
