function eventNewPlayer(playerName)
    playerData[playerName] = PlayerData:new(playerName)
	ui.addTextArea(enum.textArea.HELP, "<a href='event:helpQuestionMark'><p align='center'><font size='16'><b>?</b></font></p></a>", playerName, 760, 35, 25, 25, 0x111111, 0x111111, 1.0, true)
    tfm.exec.respawnPlayer(playerName)
    addStartGameButton(playerName)

    tfm.exec.bindKeyboard(playerName, enum.key.LEFT, true, true)
    tfm.exec.bindKeyboard(playerName, enum.key.UP, true, true)
    tfm.exec.bindKeyboard(playerName, enum.key.RIGHT, true, true)
    tfm.exec.bindKeyboard(playerName, enum.key.DOWN, true, true)
end