RegisterNetEvent('vfw:status:update', function(thirst, hunger)
	local xPlayer = VFW.GetPlayerFromId(source)
	if not xPlayer then
		return
	end

	xPlayer.setMeta("hunger", hunger)
	xPlayer.setMeta("thirst", thirst)
end)