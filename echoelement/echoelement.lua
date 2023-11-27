_addon.name = 'EchoElement'
_addon.version = '0.1'
_addon.author = 'Nirot'
_addon.commands = {'ee','echoelement'}

require 'strings'
require('chat')

--[[
	For colors I'm going with the following:
	Neutral (beige)- 121
	Red - 39
	Ice Blue - 207
	Water Blue - 219
	Green - 215
	Brown - 205
	Purple - 16
--]]


function ee_command(cmd, ...)
    if cmd == 'fire' then
		windower.add_to_chat(001,string.char(31,121).. '[Absorbs]' ..string.char(31,207).. 'ICE' ..string.char(31,121).. ' --> ' ..string.char(31,121).. '[Weak to]' ..string.char(31,39).. 'FIRE')
	elseif cmd == 'ice' then
		windower.add_to_chat(001,string.char(31,121).. '[Absorbs]' ..string.char(31,215).. 'WIND' ..string.char(31,121).. ' --> ' ..string.char(31,121).. '[Weak to]' ..string.char(31,207).. 'ICE')
	elseif cmd == 'wind' then
		windower.add_to_chat(001,string.char(31,121).. '[Absorbs]' ..string.char(31,205).. 'EARTH' ..string.char(31,121).. ' --> ' ..string.char(31,121).. '[Weak to]' ..string.char(31,215).. 'WIND')
	elseif cmd == 'earth' then
		windower.add_to_chat(001,string.char(31,121).. '[Absorbs]' ..string.char(31,16).. 'THUNDER' ..string.char(31,121).. ' --> ' ..string.char(31,121).. '[Weak to]' ..string.char(31,205).. 'EARTH')
	elseif cmd == 'thunder' then
		windower.add_to_chat(001,string.char(31,121).. '[Absorbs]' ..string.char(31,219).. 'WATER' ..string.char(31,121).. ' --> ' ..string.char(31,121).. '[Weak to]' ..string.char(31,16).. 'THUNDER')
	elseif cmd == 'water' then
		windower.add_to_chat(001,string.char(31,121).. '[Absorbs]' ..string.char(31,39).. 'FIRE' ..string.char(31,121).. ' --> ' ..string.char(31,121).. '[Weak to]' ..string.char(31,219).. 'WATER')
--for testing
--	elseif cmd == 'cure' then  
--		windower.add_to_chat(001,string.char(31,121).. '[Absorbs]' ..string.char(31,39).. 'DARK' ..string.char(31,121).. ' --> ' ..string.char(31,121).. '[Weak to]' ..string.char(31,219).. 'CURE')
	end
end

windower.register_event ('addon command', ee_command)
