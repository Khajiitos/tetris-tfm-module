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

helpContent = {
    description =
'<p align="center"><font size="24" color="#FFFF00">T</font>' ..
'<font size="24" color="#00FF00">E</font>' ..
'<font size="24" color="#FFAA00">T</font>' ..
'<font size="24" color="#FF0000">R</font>' ..
'<font size="24" color="#00FFFF">I</font>' ..
'<font size="24" color="#0000FF">S</font></p>' ..
[[

This module is a recreation of Tetris.

<font size="8">There is always a <VI>tetromino</VI>, or a block, that falls onto the <T>playfield</T>.
You can move that <VI>tetromino</VI> left or right, you can rotate it or you can make it drop faster.
Once that <VI>tetromino</VI> has touched the ground or another block, it will stay there and another <VI>tetromino</VI> will spawn.

If a whole line has been filled with blocks, it will get cleared and everything above that <S>line</S> will fall down.
For clearing a single <S>line</S> you get <b>100</b> points, for clearing two at the same time you get <b>300</b>, for three you get <b>500</b>, and for four you get <b>400</b> points.

The goal is to reach the highest score you can.
The game ends when the <VI>tetrominoes</VI> reach the top of the <T>playfield</T>.</font>
]],
    keys = [[
Here's a list of keys that the game uses:

<V><b>A/Left</b></V> - Move the current tetromino to the left
<V><b>D/Right</b></V> - Move the current tetromino to the Right
<V><b>W/Up</b></V> - Rotate the current tetromino
<V><b>S/Down</b></V> - Move the current tetromino down
<V><b>Space</b></V> - Hard drop
<V><b>ESC</b></V> - Pauses the game
<V><b>P</b></V> - Enables or disables prediction
]]
}

function changeHelpTab(playerName, tab)
    if tab == enum.helpTab.CLOSED then
        removeHelpPage(playerName)
    elseif tab == enum.helpTab.DESCRIPTION then
        ui.updateTextArea(enum.textArea.HELP_CONTENT, helpContent.description, playerName)
    elseif tab == enum.helpTab.KEYS then
        ui.updateTextArea(enum.textArea.HELP_CONTENT, helpContent.keys, playerName)
    end
    playerData[playerName].openHelpTab = tab
end

function createHelpPage(playerName)
    playerData[playerName].openHelpTab = enum.helpTab.DESCRIPTION
    ui.addTextArea(enum.textArea.HELP_CONTENT, helpContent.description, playerName, 200, 100, 400, 200, 0x0F0F0F, 0x000000, 1.0, true)
    ui.addTextArea(enum.textArea.HELP_CLOSE, '<p align="center"><a href="event:helpClose"><font size="16" color="#FFFFFF">Close</font></a></p>', playerName, 300, 315, 200, 25, 0x0F0F0F, 0x000000, 1.0, true)
    
    ui.addTextArea(enum.textArea.HELP_TAB_DESCRIPTION, '<p align="center"><a href="event:helpTabDescription"><font size="14" color="#FFFFFF">Description</font></a></p>', playerName, 80, 100, 100, 25, 0x0F0F0F, 0x000000, 1.0, true)
    ui.addTextArea(enum.textArea.HELP_TAB_KEYS, '<p align="center"><a href="event:helpTabKeys"><font size="14" color="#FFFFFF">Keys</font></a></p>', playerName, 80, 145, 100, 25, 0x0F0F0F, 0x000000, 1.0, true)
end

function removeHelpPage(playerName)
    ui.removeTextArea(enum.textArea.HELP_CONTENT, playerName)
    ui.removeTextArea(enum.textArea.HELP_CLOSE, playerName)
    ui.removeTextArea(enum.textArea.HELP_TAB_DESCRIPTION, playerName)
    ui.removeTextArea(enum.textArea.HELP_TAB_KEYS, playerName)
end