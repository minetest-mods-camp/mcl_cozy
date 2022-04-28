local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_globalstep(function(dtime)
	local players = minetest.get_connected_players()
	for i=1, #players do
		local name = players[i]:get_player_name()
		if mcl_player.player_attached[name] and not players[i]:get_attach() and
				(players[i]:get_player_control().up == true or
				players[i]:get_player_control().down == true or
				players[i]:get_player_control().left == true or
				players[i]:get_player_control().right == true or
				players[i]:get_player_control().jump == true) then
			players[i]:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
			players[i]:set_physics_override(1, 1, 1)
			mcl_player.player_attached[name] = false
			mcl_player.player_set_animation(players[i], "stand", 30)
		end
	end
end)

minetest.register_chatcommand("sit", {
	description = S("Sit down"),
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if mcl_player.player_attached[name] then
			player:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
			player:set_physics_override(1, 1, 1)
			mcl_player.player_attached[name] = false
			mcl_player.player_set_animation(player, "stand", 30)
		else
			player:set_eye_offset({x=0, y=-7, z=2}, {x=0, y=0, z=0})
			player:set_physics_override(0, 0, 0)
			mcl_player.player_attached[name] = true
			mcl_player.player_set_animation(player, "sit", 30)
		end
	end
})

minetest.register_chatcommand("lay", {
	description = S("Lay down"),
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if mcl_player.player_attached[name] then
			player:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
			player:set_physics_override(1, 1, 1)
			mcl_player.player_attached[name] = false
			mcl_player.player_set_animation(player, "stand", 30)
		else
			player:set_eye_offset({x=0, y=-13, z=0}, {x=0, y=0, z=0})
			player:set_physics_override(0, 0, 0)
			mcl_player.player_attached[name] = true
			mcl_player.player_set_animation(player, "lay", 0)
		end
	end
})
