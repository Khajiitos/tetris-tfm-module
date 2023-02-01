PlayerData = {
    playerName = nil,
    game = nil,
    openHelpTab = enum.helpTab.CLOSED,
    predictionEnabled = true
}

function PlayerData:new(playerName)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.playerName = playerName
    return o
end