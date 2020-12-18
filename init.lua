
local mh = worldedit.manip_helpers

local function check_region(name)
	return worldedit.volume(worldedit.pos1[name], worldedit.pos2[name])
end

local function set_param1(pos1, pos2, param1)
	pos1, pos2 = worldedit.sort_pos(pos1, pos2)

	local manip, area = mh.init(pos1, pos2)
	local param1_data = manip:get_light_data()

	-- Set param1 for every node
	for i in area:iterp(pos1, pos2) do
		param1_data[i] = param1
	end

	-- Update map
	manip:set_light_data(param1_data)
	manip:write_to_map(false)
	manip:update_map()

	return worldedit.volume(pos1, pos2)
end

worldedit.register_command("param1", {
	params = "<param1>",
	description = "Set param1 of all nodes in the current WorldEdit region to <param1>",
	privs = {worldedit=true},
	require_pos = 2,
	parse = function(param)
		local param1 = tonumber(param)
		if not param1 then
			return false
		elseif param1 < 0 or param1 > 14 then
			return false, "Param1 is out of range (must be between 0 and 14 inclusive!)"
		end
		return true, param1
	end,
	nodes_needed = check_region,
	func = function(name, param1)
		local count = set_param1(worldedit.pos1[name], worldedit.pos2[name], param1)
		worldedit.player_notify(name, count .. " nodes altered")
	end,
})
