PlayerData = {
    playerName = nil,
    game = nil
}

function PlayerData:new(playerName)
    local o = {}
    setmetatable(o, self)
    o.__index = self
    o.playerName = playerName
    return o
end