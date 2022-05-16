local S = minetest.get_translator(minetest.get_current_modname())
local mcl_cozy_print_actions = minetest.settings:get_bool("mcl_cozy_print_actions") ~= false

-- functions
local function print_action_sit(name)
	if mcl_cozy_print_actions then
		minetest.chat_send_all("* "..name..S(" sits"))
	end
end
local function print_action_lay(name)
	if mcl_cozy_print_actions then
		minetest.chat_send_all("* "..name..S(" lies"))
	end
end
local function print_action_stand(name)
	if mcl_cozy_print_actions then
		minetest.chat_send_all("* "..name..S(" stands up"))
	end
end

-- to support both Mineclonia and MineClone 2/5
local function actionbar_show_status(player)
	if minetest.get_modpath("mcl_title") then
		mcl_title.set(player, "actionbar", {text=S("Move to stand up"), color="white", stay=60})
	elseif minetest.get_modpath("mcl_tmp_message") then
		mcl_tmp_message.message(player, S("Move to stand up"))
	else
		minetest.log("warning", "[mcl_cozy] Didn't found any mod to set titles in actionbar (mcl_title or mcl_tmp_message)!")
	end
end

minetest.register_globalstep(function(dtime)
	local players = minetest.get_connected_players()
	for i=1, #players do
		local name = players[i]:get_player_name()
		if mcl_player.player_attached[name] and not players[i]:get_attach() and
			(players[i]:get_player_control().up == true or
			players[i]:get_player_control().down == true or
			players[i]:get_player_control().left == true or
			players[i]:get_player_control().right == true or
			players[i]:get_player_control().jump == true or
			players[i]:get_player_control().sneak == true) then
				players[i]:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
				players[i]:set_physics_override(1, 1, 1)
				mcl_player.player_attached[name] = false
				mcl_player.player_set_animation(players[i], "stand", 30)
		end
		-- check the node below player (and if it's air, just unmount)
		if minetest.get_node(vector.offset(players[i]:get_pos(),0,-1,0)).name == "air" then
			players[i]:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
			players[i]:set_physics_override(1, 1, 1)
			mcl_player.player_attached[name] = false
		end
	end
end)

minetest.register_chatcommand("sit", {
	description = S("Sit down"),
	func = function(name)
		local player = minetest.get_player_by_name(name)
		-- check the node below player (and if it's air, just don't sit)
		if minetest.get_node(vector.offset(player:get_pos(),0,-1,0)).name == "air" then return end
		if mcl_player.player_attached[name] then
			player:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
			player:set_physics_override(1, 1, 1)
			mcl_player.player_attached[name] = false
			mcl_player.player_set_animation(player, "stand", 30)
			print_action_stand(name)
		else
			player:set_eye_offset({x=0, y=-7, z=2}, {x=0, y=0, z=0})
			player:set_physics_override(0, 0, 0)
			mcl_player.player_attached[name] = true
			mcl_player.player_set_animation(player, "sit", 30)
			print_action_sit(name)
			actionbar_show_status(player)
		end
	end
})

minetest.register_chatcommand("lay", {
	description = S("Lay down"),
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if minetest.get_node(vector.offset(player:get_pos(),0,-1,0)).name == "air" then return end
		if mcl_player.player_attached[name] then
			player:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
			player:set_physics_override(1, 1, 1)
			mcl_player.player_attached[name] = false
			mcl_player.player_set_animation(player, "stand", 30)
			print_action_stand(name)
		else
			player:set_eye_offset({x=0, y=-13, z=0}, {x=0, y=0, z=0})
			player:set_physics_override(0, 0, 0)
			mcl_player.player_attached[name] = true
			mcl_player.player_set_animation(player, "lay", 0)
			print_action_lay(name)
			actionbar_show_status(player)
		end
	end
})
