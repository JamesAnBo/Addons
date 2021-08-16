_addon.name = 'AtTheTone'
_addon.author = 'Aessk'
_addon.version = '1.0.0'
_addon.commands = {'att', 'tone', 'atthetone'}

require('luau')


windower.register_event('addon command', function(...)

	local tone = windower.ffxi.get_info()
	local rtime = os.date('%I:%M:%S %p',now)
	local rday = os.date('%A',now)
	local ghour = (tone.time / 60):floor()
	local gminute = (tone.time % 60)
	local gday = res.days[tone.day].english
	
	
	
	local cmd  = (...) and (...):lower()

	if cmd == 'realtime' or cmd == 'rt' then
		windower.add_to_chat(220, 'Real time: '..rtime..' on '..rday)
		--windower.send_command('@input /p Real time: '..rtime..' on '..rday)
		
	elseif cmd == 'gametime' or cmd == 'gt' then
		if gminute < 10 then
			windower.add_to_chat(220, 'Game time: '..ghour..':0'..gminute..' on '..gday)
			--windower.send_command('@input /p Game time: '..ghour..':0'..gminute..' on '..gday)
		else
			windower.add_to_chat(220, 'Game time: '..ghour..':'..gminute..' on '..gday)
			--windower.send_command('@input /p Game time: '..ghour..':'..gminute..' on '..gday)
		end
		
	else
		if gminute < 10 then
			windower.add_to_chat(220, 'Game time: '..ghour..':0'..gminute..' || Real time: '..rtime)
			--windower.send_command('@input /p Game time: '..ghour..':0'..gminute..' || Real time: '..rtime)
		else
			windower.add_to_chat(220, 'Game time: '..ghour..':'..gminute..' || Real time: '..rtime)
			--windower.send_command('@input /p Game time: '..ghour..':'..gminute..' || Real time: '..rtime)
		end
		
	end
end)