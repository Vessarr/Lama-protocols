--[[
    lama is a MUD server made in Lua.
    Copyright (C) 2013 Curtis Erickson

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

--- Singleton that provides Protocols management utilities.
-- author Vessarr

--[[ To instal in lama server
1.put protocals.lua into main globals folder of lama server
2.add protocols.lua to the required files in loader.lua
3.modify both player.lua and client.lua in obj folder so the calls to Client:send go to Protocols:convert instead with (client, msg, i, j) aug
4.add client.options.XTERM and client.options.ANSI with the default you want set to 1(you can easily allow for the player to pick which they want)
5.add colors to mud
]]

module("Protocols", package.seeall)

--- Singleton that provides Protocols management utilities.
--  @ class table
--  @ name Protocols
local Protocols		= {}

--- Protocols information
--the escape key used for entering a given Protocols code into a message
Protocols.esc 				= "~"

--ansi Protocols codes
Protocols.ccodes	= {}
Protocols.ccodes.a	= {}
Protocols.ccodes.a["BK"] = "\027[0;30m"
Protocols.ccodes.a["bk"] = "\027[1;30m"
Protocols.ccodes.a["RD"] = "\027[0;31m"
Protocols.ccodes.a["rd"] = "\027[1;31m"
Protocols.ccodes.a["GR"] = "\027[0;32m"
Protocols.ccodes.a["gr"] = "\027[1;32m"
Protocols.ccodes.a["YW"] = "\027[0;33m"
Protocols.ccodes.a["yw"] = "\027[1;33m"
Protocols.ccodes.a["BL"] = "\027[0;34m"
Protocols.ccodes.a["bl"] = "\027[1;34m"
Protocols.ccodes.a["MR"] = "\027[0;35m"
Protocols.ccodes.a["my"] = "\027[1;35m"
Protocols.ccodes.a["CY"] = "\027[0;36m"
Protocols.ccodes.a["cy"] = "\027[1;36m"
Protocols.ccodes.a["WH"] = "\027[1;37m"
Protocols.ccodes.a["wh"] = "\027[0;37m"
Protocols.ccodes.ab = {}
Protocols.ccodes.ab["BBK"] = "\027[1;40m"
Protocols.ccodes.ab["BRD"] = "\027[1;41m"
Protocols.ccodes.ab["BGR"] = "\027[1;42m"
Protocols.ccodes.ab["BYW"] = "\027[1;43m"
Protocols.ccodes.ab["BBL"] = "\027[1;44m"
Protocols.ccodes.ab["BMR"] = "\027[1;45m"
Protocols.ccodes.ab["BCY"] = "\027[1;46m"
Protocols.ccodes.ab["BWH"] = "\027[1;47m"

--xterm Protocols codes
Protocols.ccodes.x	= {}
Protocols.ccodes.x["BK"] = "\027[38;5;000m"
Protocols.ccodes.x["bk"] = "\027[38;5;008m"
Protocols.ccodes.x["RD"] = "\027[38;5;001m"
Protocols.ccodes.x["rd"] = "\027[38;5;009m"
Protocols.ccodes.x["GR"] = "\027[38;5;002m"
Protocols.ccodes.x["gr"] = "\027[38;5;010m"
Protocols.ccodes.x["YW"] = "\027[38;5;003m"
Protocols.ccodes.x["yw"] = "\027[38;5;011m"
Protocols.ccodes.x["BL"] = "\027[38;5;004m"
Protocols.ccodes.x["bl"] = "\027[38;5;012m"
Protocols.ccodes.x["MR"] = "\027[38;5;005m"
Protocols.ccodes.x["mr"] = "\027[38;5;014m"
Protocols.ccodes.x["CY"] = "\027[38;5;006m"
Protocols.ccodes.x["cy"] = "\027[38;5;014m"
Protocols.ccodes.x["WH"] = "\027[38;5;015m"
Protocols.ccodes.x["wh"] = "\027[38;5;007m"
Protocols.ccodes.x["OR"] = "\027[38;5;172m"
Protocols.ccodes.x["or"] = "\027[38;5;214m"
Protocols.ccodes.x["PK"] = "\027[38;5;199m"
Protocols.ccodes.x["pk"] = "\027[38;5;211m"
Protocols.ccodes.x["BN"] = "\027[38;5;052m"
Protocols.ccodes.x["bn"] = "\027[38;5;094m"
Protocols.ccodes.x["LB"] = "\027[38;5;095m"
Protocols.ccodes.x["lb"] = "\027[38;5;101m"
Protocols.ccodes.x["TN"] = "\027[38;5;227m"
Protocols.ccodes.x["DG"] = "\027[38;5;022m"
Protocols.ccodes.x["dg"] = "\027[38;5;034m"
Protocols.ccodes.x["LG"] = "\027[38;5;040m"
Protocols.ccodes.x["lg"] = "\027[38;5;076m"
Protocols.ccodes.x["SG"] = "\027[38;5;029m"
Protocols.ccodes.x["sg"] = "\027[38;5;035m"
Protocols.ccodes.xb = {}
Protocols.ccodes.xb["BBK"] = "\027[48;5;000m"
Protocols.ccodes.xb["BRD"] = "\027[48;5;001m"
Protocols.ccodes.xb["BGR"] = "\027[48;5;002m"
Protocols.ccodes.xb["BYW"] = "\027[48;5;003m"
Protocols.ccodes.xb["BBL"] = "\027[48;5;004m"
Protocols.ccodes.xb["BMR"] = "\027[48;5;005m"
Protocols.ccodes.xb["BCY"] = "\027[48;5;006m"
Protocols.ccodes.xb["BWH"] = "\027[48;5;015m"
Protocols.ccodes.xb["BSG"] = "\027[48;5;029m"
Protocols.ccodes.xb["BTN"] = "\027[48;5;227m"
Protocols.ccodes.xb["BGY"] = "\027[48;5;238m"
Protocols.ccodes.xb["BBN"] = "\027[48;5;052m"
Protocols.ccodes.xb["Bbn"] = "\027[48;5;094m"

--remember to add any new Protocols codes made for .x or .xb into the .s table with what you want it swapped with
--for when only ASCI support

--differnce between xterm and ansi for swaps and removals when no xterm support
Protocols.ccodes.s = {}
Protocols.ccodes.s["OR"] = Protocols.ccodes.a["RD"]
Protocols.ccodes.s["or"] = Protocols.ccodes.a["rd"]
Protocols.ccodes.s["PK"] = Protocols.ccodes.a["MG"]
Protocols.ccodes.s["pk"] = Protocols.ccodes.a["mg"]
Protocols.ccodes.s["BN"] = ""
Protocols.ccodes.s["bn"] = ""
Protocols.ccodes.s["TN"] = ""
Protocols.ccodes.s["DG"] = Protocols.ccodes.a["GR"]
Protocols.ccodes.s["dg"] = Protocols.ccodes.a["gr"]
Protocols.ccodes.s["LG"] = Protocols.ccodes.a["GR"]
Protocols.ccodes.s["lg"] = Protocols.ccodes.a["gr"]
Protocols.ccodes.s["SG"] = Protocols.ccodes.a["GR"]
Protocols.ccodes.s["sg"] = Protocols.ccodes.a["gr"]
Protocols.ccodes.s["BSG"] = Protocols.ccodes.ab["BGR"]
Protocols.ccodes.s["BTN"] = Protocols.ccodes.ab["BYW"]
Protocols.ccodes.s["BGY"] = ""
Protocols.ccodes.s["BBN"] = ""
Protocols.ccodes.s["Bbn"] = ""


--call before sending a msg to a client to add and remove Protocol codes as needed
function Protocols:convert(client, msg, i, j)
	if client.options.XTERM == 1 then --does the client support xterm color
		msg = string.gsub(msg, "" .. Protocols.esc .. "(%d)(%d)(%d)]", "\027[38;5;%1%2%3m")
		for c in pairs(Protocols.ccodes.x) do
			msg = string.gsub(msg, "" .. Protocols.esc .. c .. "", Protocols.ccodes.x[c])
		end
		for c in pairs(Protocols.ccodes.xb) do
			msg = string.gsub(msg, "" .. Protocols.esc .. c .. "", Protocols.ccodes.xb[c])
		end
	elseif client.options.ANSI == 1 then --or does the client support ansi color
		msg = string.gsub(msg, "" .. Protocols.esc .. "(%d)(%d)(%d)]", "")
		for c in pairs(Protocols.ccodes.a) do
			msg = string.gsub(msg, "" .. Protocols.esc .. c .. "", Protocols.ccodes.a[c])
		end
		for c in pairs(Protocols.ccodes.ab) do
		msg = string.gsub(msg, "" .. Protocols.esc .. c .. "", Protocols.ccodes.ab[c])
		end
		for c in pairs(Protocols.ccodes.s) do
			msg = string.gsub(msg, "" .. Protocols.esc .. c .. "", Protocols.ccodes.s[c])
		end
	else --no color Protocols support on, remove all Protocol color codes
		msg = Protocols:strip(msg)
	end
	return client:send(msg,i,j)--msg is directly sent to clients send function
end

--remove all Protocol color codes from a msg and return it. can be used to easily strip Protocols from players chats or whenever you dont want a player to be able to send Protocols codes
function Protocols:strip(msg)
	msg = string.gsub(msg, "" .. Protocols.esc .. "(%d)(%d)(%d)]", "")
	for c in pairs(Protocols.ccodes.x) do
		msg = string.gsub(msg, "" .. Protocols.esc .. c .. "", "")
	end
	for c in pairs(Protocols.ccodes.xb) do
		msg = string.gsub(msg, "" .. Protocols.esc .. c .. "", "")
	end
	return msg
end

_G.Protocols = Protocols


return Protocols
