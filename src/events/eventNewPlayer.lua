local tetrisLogoText = string.format('<textformat leading="-40"><p align="center"><b>%s%s%s%s%s%s</b></p><p align="center">%s</p></textformat>',
'<font size="100" color="#FFFF00" face="serif" letterspacing="5">T</font>',
'<font size="100" color="#00FF00" face="serif" letterspacing="5">E</font>',
'<font size="100" color="#FFAA00" face="serif" letterspacing="5">T</font>',
'<font size="100" color="#FF0000" face="serif" letterspacing="5">R</font>',
'<font size="100" color="#00FFFF" face="serif" letterspacing="5">I</font>',
'<font size="100" color="#0000FF" face="serif" letterspacing="5">S</font>',
'<font size="64" color="#303030" face="serif" letterspacing="2">TFM</font>'
)
function eventNewPlayer(playerName)
    ui.addTextArea(enum.textArea.TETRIS_LOGO, tetrisLogoText, playerName, 0, 0, 800, 400, 0, 0, 0, true)

    playerData[playerName] = PlayerData:new(playerName)

	ui.addTextArea(enum.textArea.HELP, "<a href='event:helpQuestionMark'><p align='center'><font size='16'><b>?</b></font></p></a>", playerName, 760, 35, 25, 25, 0x111111, 0x111111, 1.0, true)
    tfm.exec.respawnPlayer(playerName)
    addStartGameButton(playerName)

    tfm.exec.bindKeyboard(playerName, enum.key.LEFT, true, true)
    tfm.exec.bindKeyboard(playerName, enum.key.UP, true, true)
    tfm.exec.bindKeyboard(playerName, enum.key.RIGHT, true, true)
    tfm.exec.bindKeyboard(playerName, enum.key.DOWN, true, true)
    tfm.exec.bindKeyboard(playerName, enum.key.SPACE, true, true)
    tfm.exec.bindKeyboard(playerName, enum.key.ESC, true, true)
    tfm.exec.bindKeyboard(playerName, enum.key.P, true, true)
end