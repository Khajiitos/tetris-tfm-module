function eventTextAreaCallback(textAreaID, playerName, callback)
    if callback == 'helpQuestionMark' then
        openHelpPopup(playerName)
    elseif callback == 'startGame' then
        local game = TetrisGame:new(playerName)
        playerData[playerName].game = game
        game:startGame()
        removeStartGameButton(playerName)
    elseif callback == 'unpause' then
        playerData[playerName].game:togglePause()
    end
end