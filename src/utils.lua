table.copy = function(tableToCopy, deep)
    deep = deep or false
    local newTable = {}
    for i, element in pairs(tableToCopy) do
        if type(element) == 'table' then
            if deep then
                newTable[i] = table.copy(element, deep)
            end
        else
            newTable[i] = element
        end
    end
    return newTable
end

scheduledFunctionCalls = {}

function doLater(callback, ticksLater, forgetAfterNewRound)
    scheduledFunctionCalls[#scheduledFunctionCalls + 1] = {
        func = callback,
        tick = eventLoopTicks + ticksLater,
        forgetAfterNewRound = forgetAfterNewRound
    }
end

function addStartGameButton(playerName)
    ui.addTextArea(enum.textArea.START_GAME, '<a href="event:startGame"><p align="center"><b>Start game</b></p></a>', playerName, 350, 370, 100, 20, nil, nil, 0.9, true)
end

function removeStartGameButton(playerName)
    ui.removeTextArea(enum.textArea.START_GAME, playerName)
end

function openHelpPopup(playerName)
    local text = [[
<p align='center'><font size='20' color='#BABD2F'><b>Tetris</b></font></p>
<b>Welcome to the module!</b>

...

<font color='#2ECF73' size='13'><b>Good luck!</b></font>
<p align='right'><font color='#606090' size='10'><b><i>Made by Khajiitos#0000</i><b></font></p>]]
    ui.addPopup(1, 0, text, playerName, 150, 30, 500, true)
end