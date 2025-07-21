function VFW.CreateReportClass(id, player, message)    
    local self = {}

    self.id = id
    self.message = message
    self.player = player
    self.date = os.date("%H:%M:%S")
    self.takenBy = nil

    return self
end