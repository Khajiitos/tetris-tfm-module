function eventKeyboard(playerName, keyCode, down, xPlayerPosition, yPlayerPosition)
    if playerData[playerName].game then
        playerData[playerName].game:onKeyPress(keyCode)
    end
end