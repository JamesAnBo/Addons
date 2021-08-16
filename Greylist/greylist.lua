_addon.name = 'Greylist'
_addon.version = '0.40'
_addon.author = 'Aessk'
_addon.commands = {'greylist','gl'}

-- Some people are very nice, but I want to avoid for certain content.
-- Whenever someone on your greylist sends a tell it just says "<name> is on your greylist."
--
-- //gl
-- lists all the names
--
-- //gl add <name>
-- //gl a <name>
-- add a name
--
-- //gl remove <name>
-- //gl r <name>
-- remove a name
--
-- //gl save
-- //gl s
-- saves the current character's local list to global for all characters
--
-- //gl find <name>
-- //gl f <name>
-- Searches list for a name. Tells you if they are on your greylist or not.

require('luau')
config = require('config')
packets = require('packets')

defaults = {}
defaults.names = S{}

settings = config.load(defaults)

-- Adds names to The List.
function add_name(...)
	
    local names = S{...}
    local duplicates = names * settings.names
    if not duplicates:empty() then
        notice(('User'):plural(duplicates) .. ' ' .. duplicates:format() .. ' is already on your greylist.')
    end
    local new = names - settings.names
    if not new:empty() then
        settings.names = settings.names + new
        log('Added ' .. new:format() .. ' to your greylist.')
    end
    settings:save()
end

-- Removes names from The List.
function rm_name(...)
    local names = S{...}
    local dummy = names - settings.names
    if not dummy:empty() then
        notice(('User'):plural(dummy) .. ' ' .. dummy:format() .. ' was not found on your greylist.')
    end
    local remove = names * settings.names
    if not remove:empty() then
        settings.names = settings.names - remove
        log('Removed ' .. remove:format() .. ' from your greylist.')
    end
    settings:save()
end

windower.register_event('addon command', function(command, ...)
    command = command and command:lower() or 'status'
    local args = T{...}
	
	if command == 'add' or command == 'a' then
		add_name(args[1]:lower())
	elseif command == 'remove' or command == 'r' then
		rm_name(args[1]:lower())
	elseif command == 'find' or command == 'f' then
		if settings.names:contains(args[1]:lower()) then
			windower.add_to_chat(123,args[1].. ' is on your greylist.')
		else
			windower.add_to_chat(204,args[1].. ' is NOT on your greylist.')
		end
	elseif command == 'save' or command == 's' then
        settings:save(args[1] or 'all')
        log('Settings saved.')
    elseif args:empty() then
        log(settings.names:empty() and '(empty)' or settings.names:format('csv'))
    else
        warning('Unkown command \'' .. command .. '\', ignored.')
    end
end)

windower.register_event('incoming chunk', function(id,data)
    if id == 0x017 then -- 0x017 Is incoming chat.
        local chat = packets.parse('incoming', data)
		if chat['Mode'] == 3 then -- chat mode 3 is tells
			if settings.names:contains(chat['Sender Name']:lower()) then
				windower.add_to_chat(004, '***** ' ..chat['Sender Name'].. ' is on your greylist *****')
			end
		end
	end
end)