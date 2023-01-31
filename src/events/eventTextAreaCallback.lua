function eventTextAreaCallback(textAreaID, playerName, callback)
    if callback == 'helpQuestionMark' then
        if playerData[playerName].openHelpTab == enum.helpTab.CLOSED then
            createHelpPage(playerName)
        else
            changeHelpTab(playerName, enum.helpTab.CLOSED)
        end
    elseif callback == 'startGame' then
        local game = TetrisGame:new(playerName)
        playerData[playerName].game = game
        game:startGame()
        removeStartGameButton(playerName)
    elseif callback == 'unpause' then
        playerData[playerName].game:togglePause()
    elseif callback == "helpClose" then
        changeHelpTab(playerName, enum.helpTab.CLOSED)
    elseif callback == "helpTabDescription" then 
        changeHelpTab(playerName, enum.helpTab.DESCRIPTION)
    elseif callback == "helpTabKeys" then 
        changeHelpTab(playerName, enum.helpTab.KEYS)
    end
end