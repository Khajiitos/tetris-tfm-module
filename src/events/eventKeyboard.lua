function eventKeyboard(playerName, keyCode, down, xPlayerPosition, yPlayerPosition)
    local playerData = playerData[playerName]
    if keyCooldowns[keyCode] then
        if playerData.keysLastUsed[keyCode] then
            if os.time() - playerData.keysLastUsed[keyCode] < keyCooldowns[keyCode] then
                return
            end
        end
        playerData.keysLastUsed[keyCode] = os.time()
    end
    if playerData.game then
        playerData.game:onKeyPress(keyCode)
    end
end