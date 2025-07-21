function CreatePlayerGlobal(id, role, permissions, pseudo, total_playtime, roles)
    local self = {}

    self.id = id
    self.role = role
    self.permissions = permissions
    self.pseudo = pseudo
    self.total_playtime = total_playtime
    self.roles = roles

    return self
end
