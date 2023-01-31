PlayerData = {
    playerName = nil,
    game = nil,
    openHelpTab = enum.helpTab.CLOSED
}

function PlayerData:new(playerName)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.playerName = playerName
    return o
end