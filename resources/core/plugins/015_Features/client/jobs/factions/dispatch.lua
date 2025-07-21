RegisterClientCallback("core:getStreetName", function(pos)
    local x, y, z = table.unpack(pos)
    local streetNameH, crossingRoadH = GetStreetNameAtCoord(x, y, z)
    local streetName = GetStreetNameFromHashKey(streetNameH)
    local crossingRoad = GetStreetNameFromHashKey(crossingRoadH)
    local place = streetName

    if (crossingRoad ~= "") then
        place = streetName .. ", " .. crossingRoad
    end
    return place
end)
