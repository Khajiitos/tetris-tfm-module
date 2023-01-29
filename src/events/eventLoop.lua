function eventLoop(currentTime, timeRemaining)
    for playerName, playerData in pairs(playerData) do
        if playerData.game then
            playerData.game:onEventLoop()
        end
    end
end