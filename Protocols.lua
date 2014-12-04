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
3.modify both player.lua and client.lua in obj folder so the calls to Client:send go to Protocols:convert instead
4.add client.options.XTERM and client.options.ANSI with the default you want set to 1 and the other set to 0(you can easily allow for the player to pick which they want)
4.add client.options.LMP for music protocol set to 1 for on or 0 for off.
5.add colors and music to mud
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

--remember to add any new Protocols codes made for .x or .xb into the .s table with what you want it swapped with.
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


--control char codes for encoding a files into a transpherable format
Protocols.cc = {}
Protocols.cc["$SOH"] = "\001"
Protocols.cc["$STX"] = "\002"
Protocols.cc["$ETX"] = "\003"
Protocols.cc["$EOT"] = "\004"
Protocols.cc["$ENQ"] = "\005"
Protocols.cc["$ACK"] = "\006"
Protocols.cc["$BEL"] = "\007"
Protocols.cc["$BS"] = "\008"
Protocols.cc["$HT"] = "\009"
Protocols.cc["$LF"] = "\010"
Protocols.cc["$VT"] = "\011"
Protocols.cc["$FF"] = "\012"
Protocols.cc["$CR"] = "\013"
Protocols.cc["$SO2"] = "\014"
Protocols.cc["$SI1"] = "\015"
Protocols.cc["$DLE"] = "\016"
Protocols.cc["$DC1"] = "\017"
Protocols.cc["$DC2"] = "\018"
Protocols.cc["$DC3"] = "\019"
Protocols.cc["$DC4"] = "\020"
Protocols.cc["$NAK"] = "\021"
Protocols.cc["$SYN"] = "\022"
Protocols.cc["$EBT"] = "\023"
Protocols.cc["$CAN"] = "\024"
Protocols.cc["$EM"] = "\025"
Protocols.cc["$SUB"] = "\026"
Protocols.cc["$ESC"] = "\027"
Protocols.cc["$FS"] = "\028"
Protocols.cc["$GS"] = "\029"
Protocols.cc["$RS"] = "\030"
Protocols.cc["$US"] = "\031"
Protocols.cc["$DEL"] = "\127"

--other chars codes
Protocols.fc = {}
Protocols.fc["$NBS"] = "\160"
Protocols.fc["$IEM"] = "\161"
Protocols.fc["$CSN"] = "\162"
Protocols.fc["$PSN"] = "\163"
Protocols.fc["$CUS"] = "\164"
Protocols.fc["$YNS"] = "\165"
Protocols.fc["$BRB"] = "\166"
Protocols.fc["$SSN"] = "\167"
Protocols.fc["$DIA"] = "\168"
Protocols.fc["$CPS"] = "\169"
Protocols.fc["$FOI"] = "\170"
Protocols.fc["$LDQ"] = "\171"
Protocols.fc["$NSN"] = "\172"
Protocols.fc["$STH"] = "\173"
Protocols.fc["$RGS"] = "\174"
Protocols.fc["$MAC"] = "\175"
Protocols.fc["$DGS"] = "\176"
Protocols.fc["$PMS"] = "\177"
Protocols.fc["$SS2"] = "\178"
Protocols.fc["$SS3"] = "\179"
Protocols.fc["$AAC"] = "\180"
Protocols.fc["$MCS"] = "\181"
Protocols.fc["$PIS"] = "\182"
Protocols.fc["$MDD"] = "\183"
Protocols.fc["$CID"] = "\184"
Protocols.fc["$SS1"] = "\185"
Protocols.fc["$MOI"] = "\186"
Protocols.fc["$RDQ"] = "\187"
Protocols.fc["$FOQ"] = "\188"
Protocols.fc["$FOH"] = "\189"
Protocols.fc["$FTQ"] = "\190"
Protocols.fc["$IQM"] = "\191"
Protocols.fc["$AWG"] = "\192"
Protocols.fc["$AWA"] = "\193"
Protocols.fc["$AWC"] = "\194"
Protocols.fc["$AWT"] = "\195"
Protocols.fc["$AWD"] = "\196"
Protocols.fc["$AWR"] = "\197"
Protocols.fc["$CAE"] = "\198"
Protocols.fc["$CCD"] = "\199"
Protocols.fc["$EWG"] = "\200"
Protocols.fc["$EWA"] = "\201"
Protocols.fc["$EWC"] = "\202"
Protocols.fc["$EWD"] = "\203"
Protocols.fc["$IWG"] = "\204"
Protocols.fc["$IWA"] = "\205"
Protocols.fc["$IWC"] = "\206"
Protocols.fc["$IWD"] = "\207"
Protocols.fc["$ETH"] = "\208"
Protocols.fc["$NWT"] = "\209"
Protocols.fc["$OWG"] = "\210"
Protocols.fc["$OWA"] = "\211"
Protocols.fc["$OWC"] = "\212"
Protocols.fc["$OWT"] = "\213"
Protocols.fc["$OWD"] = "\214"
Protocols.fc["$MPS"] = "\215"
Protocols.fc["$OWS"] = "\216"
Protocols.fc["$UWG"] = "\217"
Protocols.fc["$UWA"] = "\218"
Protocols.fc["$UWC"] = "\219"
Protocols.fc["$UWD"] = "\220"
Protocols.fc["$YWA"] = "\221"
Protocols.fc["$THO"] = "\222"
Protocols.fc["$SHS"] = "\223"
Protocols.fc["$SAG"] = "\224"
Protocols.fc["$SAA"] = "\225"
Protocols.fc["$SAC"] = "\226"
Protocols.fc["$SAT"] = "\227"
Protocols.fc["$SAD"] = "\228"
Protocols.fc["$SAR"] = "\229"
Protocols.fc["$SAE"] = "\230"
Protocols.fc["$SCC"] = "\231"
Protocols.fc["$SEG"] = "\232"
Protocols.fc["$SEA"] = "\233"
Protocols.fc["$SEC"] = "\234"
Protocols.fc["$SED"] = "\235"
Protocols.fc["$SIG"] = "\236"
Protocols.fc["$SIA"] = "\237"
Protocols.fc["$SIC"] = "\238"
Protocols.fc["$SID"] = "\239"
Protocols.fc["$SET"] = "\240"
Protocols.fc["$SNT"] = "\241"
Protocols.fc["$SOG"] = "\242"
Protocols.fc["$SOA"] = "\243"
Protocols.fc["$SOC"] = "\244"
Protocols.fc["$SOT"] = "\245"
Protocols.fc["$SOD"] = "\246"
Protocols.fc["$DVS"] = "\247"
Protocols.fc["$SOS"] = "\248"
Protocols.fc["$SUG"] = "\249"
Protocols.fc["$SUA"] = "\250"
Protocols.fc["$SUC"] = "\251"
Protocols.fc["$SUD"] = "\252"
Protocols.fc["$SYA"] = "\253"
Protocols.fc["$SLT"] = "\254"
Protocols.fc["$SYD"] = "\255"

--music and sound codes
Protocols.mcodes = {}
Protocols.mcodes["STOP"] = {["nm"] = "nothing", ["sfn"] = "sounds/", ["cfn"] = "sounds/", ["ext"] = ".mid"  }
Protocols.mcodes["ME1"] = {["nm"] = "seal1", ["sfn"] = "sounds/", ["cfn"] = "sounds/", ["ext"] = ".mid"  }
Protocols.mcodes["MM1"] = {["nm"] = "uniden", ["sfn"] = "sounds/", ["cfn"] = "sounds/", ["ext"] = ".mid"  }
Protocols.mcodes["MM2"] = {["nm"] = "minute_waltz", ["sfn"] = "sounds/", ["cfn"] = "sounds/", ["ext"] = ".mid"  }
Protocols.mcodes["MM3"] = {["nm"] = "quietgrave", ["sfn"] = "sounds/", ["cfn"] = "sounds/", ["ext"] = ".mid"  }

--call before sending a msg to a client to add and remove Protocol codes as needed
function Protocols:convert(client, msg, i, j)
	if client.options.LMP == 1 then--does the client support lama music protocol
		for i,v in pairs(Protocols.mcodes) do
			if string.find(msg, "{M" .. Protocols.esc .. i .. "]") then
				msg = string.gsub(msg, "{M" .. Protocols.esc .. i .. "]", "")
				Protocols:sendfile(v["sfn"],v["cfn"],v["nm"],v["ext"],"y",client.player)
				if v["nm"] ~= "nothing" then
					client.player.cursong = v
				end
			end
		end
	else--no lama music protocol support remove music codes
	msg = Protocols:stripm(msg)
	end

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

function Protocols:stripm(msg)-- removes music code from msg and returns it
	for c in pairs(Protocols.mcodes) do
		msg = string.gsub(msg, "{M" .. Protocols.esc .. c .. "]", "")
	end
	return msg
end

function Protocols:convertfile(data) --converts data from a file
	for i,v in pairs(Protocols.cc) do--convert control codes
		data = string.gsub(data, v, i)
	end
	data = string.gsub(data, "%c", "$NUL")--null cant be matched directly so has to be matched on %c, must be done after all other control chars have been removed

	for i,v in pairs(Protocols.fc) do--convert other necessary chars
		data = string.gsub(data, v, i)
	end
	data = string.gsub(data, "\n", "$NWL")--convert newlines

	return data
end

function Protocols:sendfile(sfl,cfn,name,ext,pl,player)
	local file = io.open(sfl .. name .. ext, "rb")
	local data = {}
	repeat
		local d = file:read(1000)
		if d then
			if pl ~= "pl" then
				d = Protocols:convertfile(d)
			else
				d = string.gsub(d, "{/file}", "$FND")
				d = string.gsub(d, "\t", "$TAB")
				d = string.gsub(d, "\n", "$NWL")
			end
		table.insert(data, d)
		end
	until not d
	file:close(file)

	if pl ~= "y" then
		player:sendMessage("~GRSending file~wh", MessageMode.GENERAL)
	end
	player:sendMessage("{file[" .. cfn .. "[" .. name .. "[" .. ext .. "[" .. pl .. "}", MessageMode.GENERAL)
	for t,v in ipairs(data) do
		Protocols:sleep(0.02)
		local msg = ("\n" .. v)
		player.client:send(msg,i,j)--skip protocol strip just incase the file contains codes
	end
	player:sendMessage("{/file}", MessageMode.GENERAL)


end

function Protocols:sleep(sec)
    socket.select(nil, nil, sec)
end

_G.Protocols = Protocols

return Protocols
