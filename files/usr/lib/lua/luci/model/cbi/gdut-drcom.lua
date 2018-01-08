--[[
LuCI - Lua Configuration Interface

Copyright 2010 Jo-Philipp Wich <xm@subsignal.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
]]--

require("luci.sys")

m = Map("gdut_drcom", translate("gdut-drcom Client"), translate("Configure gdut-drcom client. Configure gdut-drcom client. Visit the project home: https://github.com/chenhaowen01/gdut-drcom-for-openwrt for help!"))

s = m:section(TypedSection, "gdut_drcom", "")
s.addremove = false
s.anonymous = true

enable = s:option(Flag, "enable", translate("Enable"))

enabledial = s:option(Flag, "enabledial", translate("Enable PPPoE Dial"))
enabledial.default = enabledial.enabled

interface = s:option(ListValue, "interface", translate("Interface"), translate("Please select your dial interface. (Generally it's named WAN/wan.)"))
interface:depends("enabledial", "1")

cur = luci.model.uci.cursor()
net = cur:get_all("network")
for k, v in pairs(net) do
	for k1, v1 in pairs(v) do
		if v1 == "interface" then
			interface:value(k)
			if k == "WAN" or k == "wan" then
				interface.default = k
			end
		end
	end
end

username = s:option(Value, "username", translate("Username"))
username:depends("enabledial", "1")
password = s:option(Value, "password", translate("Password"))
password:depends("enabledial", "1")
password.password = true

macaddr = s:option(Value, "macaddr", translate("Mac address"))
macaddr.datatype="macaddr"
remote_ip = s:option(Value, "remote_ip", translate("Remote ip"))
remote_ip.datatype="ipaddr"
keep_alive_flag = s:option(Value, "keep_alive1_flag", translate("Keep alive1 flag"))
enable_crypt = s:option(Flag, "enable_crypt", translate("Enable crypt"))

local apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("/etc/init.d/gdut-drcom restart")
end

return m

