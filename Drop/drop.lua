_addon.name = 'Drop'
_addon.author = 'Arico'
_addon.version = '1'
_addon.commands = {'drop'}

--Item lists function by Aessk


packets = require('packets')
require('luau')
res = require('resources')
require('logger')

drop_lists = T{
    rems = {"Rem's Tale Ch.6","Rem's Tale Ch.7","Rem's Tale Ch.8","Rem's Tale Ch.9","Rem's Tale Ch.10"},
	cells = {"Incus Cell","Undulatus Cell","Castellanus Cell","Virga Cell","Cumulus Cell","Radiatus Cell","Cirrocumulus Cell","Stratus Cell","Duplicatus Cell","Opacus Cell","Praecipitatio Cell","Humilus Cell","Spissatus Cell","Pannus Cell","Fractus Cell","Congestus Cell","Nimbus Cell","Velum Cell","Pileus Cell","Mediocris Cell"},
}



check_inv = function(item_id)
        for k, v in pairs(windower.ffxi.get_items().inventory) do
            if type(v) == 'table' and v.id == item_id then
                return true
            end
        end
    return false
end

get_item_resource = function(item)
    for k, v in pairs(res.items) do
        if v.english:lower() == item:lower() or v.japanese:lower() == item:lower()  then
            return v
        end
    end
    return nil
end

drop_item = function(item_to_drop) 
        for k, v in pairs(windower.ffxi.get_items().inventory) do
        if type(v) == "table" then
            if v.id and v.id == item_to_drop then
                
                local drop_packet = packets.new('outgoing', 0x028, {
                    ["Count"] = v.count,
                    ["Bag"] = 0,
                    ["Inventory Index"] = k,
                })
                packets.inject(drop_packet)
                coroutine.sleep(.5)
            end
    end     
    end
end

windower.register_event('addon command', function (...)

    args = L{...};
    if args[1]:lower() == 'help' then
        log('//drop <\30\02item\30\01>\nDrops a specific \30\02item\30\01. does not require quotes, capitalization, and accepts auto-translate.') 
        return
    end
	
    for i, v in pairs(args) do args[i]=windower.convert_auto_trans(args[i]) end --thanks Akaden
    if args[1]:lower() == 'list' then
        if #args > 1 then
			local list_name = args[2]:lower()
			args:remove(1)
			log(('Attempting to drop list: \30\02%s\30\01.':format(list_name)))
		
			if drop_lists:containskey(list_name) then
				found_items = drop_lists[list_name]
			else 
				found_items = nil
				log(('List \30\02%s\30\01 not found.':format(list_name)))
			end	
			if found_items then
				for k, v in pairs(found_items) do
					local item = get_item_resource(v)
					if item ~= nil then 
						if check_inv(item.id) then
							drop_item(item.id)
						else 
							log(('No \30\02%s\30\01 was found in your inventory.':format(v)))
						end
					else 
						log('\30\02%s\30\01 does not exist.':format(v))
					end	
				end
			end
		else
			log('No list specified.')
		end
    else
		local item_name = table.concat(args, ' ',1,#args):lower()
		item = get_item_resource(item_name)
		if item then
			if check_inv(item.id) then
				drop_item(item.id)
			else 
				log(('No \30\02%s\30\01 was found in your inventory.':format(item_name)))
			end
		else
			log('\30\02%s\30\01 does not exist.':format(item_name))
		end
	end
end)