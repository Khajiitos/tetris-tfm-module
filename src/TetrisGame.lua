TetrisGame = {
    playerName = nil,
    board = {},
    currentPiece = nil,
    currentPieceRotationPhase = 1,
    nextPiece = nil,
    currentPieceX = 4,
    currentPieceY = 1,
    lowestBlockY = GAME_HEIGHT,

    score = 0,
    lines = 0,

    npTextAreaWidth = 0,
    npTextAreaHeight = 0,
    bgTextAreaWidth = 0,
    bgTextAreaHeight = 0,
    npxPosition = 0,
    npyPosition = 0,
    bgxPosition = 0,
    bgyPosition = 0,

    paused = false,
    unpauseTimer = 3.0,

    currentPieceBlockTextAreasIds = {},
    nextPieceBlockTextAreasIds = {},
    predictionBlockTextAreasIds = {}
}

function TetrisGame:new(playerName)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.playerName = playerName
    o.currentPieceBlockTextAreasIds = {}
    o.nextPieceBlockTextAreasIds = {}
    o.currentPiece = piece_prototypes[math.random(#piece_prototypes)]
    o.nextPiece = piece_prototypes[math.random(#piece_prototypes)]
    o.board = {}
    return o
end

function TetrisGame:startGame()
    self.bgTextAreaWidth = ACTUAL_BLOCK_SIZE * GAME_WIDTH
    self.bgTextAreaHeight = ACTUAL_BLOCK_SIZE * GAME_HEIGHT

    self.bgxPosition = (800 - self.bgTextAreaWidth) / 2
    self.bgyPosition = (425 - self.bgTextAreaHeight) / 2

    ui.addTextArea(enum.textArea.GAME_BACKGROUND, '', self.playerName, self.bgxPosition, self.bgyPosition, self.bgTextAreaWidth, self.bgTextAreaHeight, 0x101010, 0x010101, 1.0, true)

    self.npTextAreaWidth = 50 + ACTUAL_BLOCK_SIZE * 4
    self.npTextAreaHeight = 75 + ACTUAL_BLOCK_SIZE * 4

    self.npxPosition = self.bgxPosition + self.bgTextAreaWidth + 15
    self.npyPosition = self.bgyPosition

    ui.addTextArea(enum.textArea.BACKGROUND_NEXT_PIECE, '', self.playerName, self.npxPosition, self.npyPosition, self.npTextAreaWidth, self.npTextAreaHeight, 0x101010, 0x010101, 1.0, true)
    ui.addTextArea(enum.textArea.NEXT_PIECE_TEXT, '<p align="center"><font size="20" color="#FFFFFF" face="serif">NEXT</font></p>', self.playerName, self.npxPosition, self.npyPosition, self.npTextAreaWidth, 50, 0, 0, 0, true)
    ui.addTextArea(enum.textArea.GAME_INFO, '', self.playerName, self.bgxPosition - self.npTextAreaWidth - 15, self.npyPosition, self.npTextAreaWidth, self.npTextAreaHeight, 0x101010, 0x010101, 1.0, true)
    self:addUnpauseTimer()
    self:updateUnpauseTimer()

    self:updateGameInfoTextArea()
    self:updateNextPiecePreview()
    self:drawCurrentPiece()
    self:updatePrediction()

    tfm.exec.freezePlayer(self.playerName, true, false)
end

function TetrisGame:updateGameInfoTextArea()
    local text = string.format([[
<textformat leading="4"><p align="center"><font size="20" color="#FFFFFF" face="serif">SCORE</font>
<font size="16" color="#AAAAAA">%d</font><br>
<font size="20" color="#FFFFFF" face="serif">LINES</font>
<font size="16" color="#AAAAAA">%d</font></p></textformat>
]], self.score, self.lines)

    ui.updateTextArea(enum.textArea.GAME_INFO, text, self.playerName)
end

function TetrisGame:drawCurrentPiece()
    local startX = self.bgxPosition + ((self.currentPieceX - 1) * ACTUAL_BLOCK_SIZE)
    local startY = self.bgyPosition + ((self.currentPieceY - 2) * ACTUAL_BLOCK_SIZE)

    local blocks = self:getCurrentPieceBlocks()

    for i, row in ipairs(blocks) do
        for j, block in ipairs(row) do
            local id = enum.textArea.CURRENT_PIECE_BLOCK_START + #self.currentPieceBlockTextAreasIds
            self.currentPieceBlockTextAreasIds[#self.currentPieceBlockTextAreasIds + 1] = id
            ui.addTextArea(id, '', self.playerName, startX + ((block - 1) * ACTUAL_BLOCK_SIZE), startY + (i * ACTUAL_BLOCK_SIZE), BLOCK_SIZE, BLOCK_SIZE, self.currentPiece.color, 0x010101, 1.0, true)
        end
    end
end

function TetrisGame:undrawCurrentPiece()
    for _, id in ipairs(self.currentPieceBlockTextAreasIds) do
        ui.removeTextArea(id, self.playerName)
    end
    self.currentPieceBlockTextAreasIds = {}
end

function TetrisGame:updateNextPiecePreview()
    for i, id in ipairs(self.nextPieceBlockTextAreasIds) do
        ui.removeTextArea(id, self.playerName)
    end
    self.nextPieceBlockTextAreasIds = {}
    local blocks = self:getNextPieceBlocks()
    local pieceWidth, pieceHeight = 0, 0

    for i, row in ipairs(blocks) do
        for _, rowIndex in ipairs(row) do
            pieceWidth = math.max(pieceWidth, rowIndex)
        end
        if #row ~= 0 then 
            pieceHeight = pieceHeight + 1 
        end
    end

    local startX = self.npxPosition + (self.npTextAreaWidth / 2) - (pieceWidth * ACTUAL_BLOCK_SIZE / 2)
    local startY = self.npyPosition + 50

    for i, row in ipairs(blocks) do
        for j, block in ipairs(row) do
            local id = enum.textArea.NEXT_PIECE_BLOCK_START + #(self.nextPieceBlockTextAreasIds)
            self.nextPieceBlockTextAreasIds[#self.nextPieceBlockTextAreasIds + 1] = id
            ui.addTextArea(id, '', self.playerName, startX + ((block - 1) * ACTUAL_BLOCK_SIZE), startY + (i * ACTUAL_BLOCK_SIZE), BLOCK_SIZE, BLOCK_SIZE, self.nextPiece.color, 0x010101, 1.0, true)
        end
    end
end

function TetrisGame:endGame()
    addStartGameButton(self.playerName)
    ui.removeTextArea(enum.textArea.GAME_BACKGROUND, self.playerName)
    ui.removeTextArea(enum.textArea.BACKGROUND_NEXT_PIECE, self.playerName)
    ui.removeTextArea(enum.textArea.NEXT_PIECE_TEXT, self.playerName)
    ui.removeTextArea(enum.textArea.GAME_INFO, self.playerName)

    for _, id in ipairs(self.currentPieceBlockTextAreasIds) do
        ui.removeTextArea(id, self.playerName)
    end

    for _, id in ipairs(self.nextPieceBlockTextAreasIds) do
        ui.removeTextArea(id, self.playerName)
    end

    for _, id in ipairs(self.predictionBlockTextAreasIds) do
        ui.removeTextArea(id, self.playerName)
    end

    for i = enum.textArea.GAME_BLOCK_START, enum.textArea.GAME_BLOCK_START + GAME_HEIGHT * GAME_WIDTH do
        ui.removeTextArea(i, self.playerName)
    end

    self:playSound('deadmaze/combat/soins.mp3')

    playerData[self.playerName].game = nil
    tfm.exec.freezePlayer(self.playerName, false)
end

function TetrisGame:checkCurrentPiece()
    if self:currentPieceTouchesAnything() then
        self.currentPieceY = self.currentPieceY - 1
        self:installCurrentPiece()
    else
        self:drawCurrentPiece()
    end
end

function TetrisGame:currentPieceTouchesAnything()
    local blocks = self:getCurrentPieceBlocks()
    for i, row in ipairs(blocks) do
        for j, block in ipairs(row) do
            local blockX = self.currentPieceX + block - 1
            local blockY = self.currentPieceY + i - 1
            if blockY > GAME_HEIGHT or blockX < 1 or blockX > GAME_WIDTH or self:block(blockX, blockY) then
                return true
            end
        end
    end
    return false
end

function TetrisGame:checkRow(y)
    for i = 1, 10 do
        if not self:block(i, y) then
            return false
        end 
    end

    self.lines = self.lines + 1
    self:updateGameInfoTextArea()
    self:playSound('tfmadv/buff1.mp3')

    for i = 1, 10 do
        self:placeBlock(i, y, nil)
    end

    for i = y - 1, 1, -1 do
        for j = 1, 10 do
            local block = self:block(j, i)
            if block then
                self:placeBlock(j, i, nil)
                self:placeBlock(j, i + 1, block)
            end
        end
    end

    return true
end

function TetrisGame:installCurrentPiece()
    self:undrawCurrentPiece()
    local currentLines = self.lines
    local blocks = self:getCurrentPieceBlocks()
    for i, row in ipairs(blocks) do
        for j, block in ipairs(row) do
            local blockX = self.currentPieceX + block - 1
            local blockY = self.currentPieceY + i - 1
            self:placeBlock(blockX, blockY, self.currentPiece.color)
            self:checkRow(blockY)
        end
    end
    local linesDif = self.lines - currentLines

    if linesDif == 1 then
        self:addScore(100)
    elseif linesDif == 2 then
        self:addScore(300)
    elseif linesDif == 3 then
        self:addScore(500)
    elseif linesDif == 4 then
        self:addScore(800)
    end

    self.currentPieceY = 1
    self.currentPieceX = 4
    self.currentPiece = self.nextPiece
    self.currentPieceRotationPhase = 1
    self.nextPiece = piece_prototypes[math.random(#piece_prototypes)]
    self:updateNextPiecePreview()
    self:drawCurrentPiece()
    self:playSound('tfmadv/bouton1.mp3')
    self:updatePrediction()

    if self:currentPieceTouchesAnything() then
        self:endGame()
    end
end

function TetrisGame:hardDrop()
    local score = 0
    self.currentPieceY = self.currentPieceY + 1
    while not self:currentPieceTouchesAnything() do
        self.currentPieceY = self.currentPieceY + 1
        score = score + 2
    end
    self.currentPieceY = self.currentPieceY - 1
    self:installCurrentPiece()
    if score ~= 0 then
        self:addScore(score)
    end
end

function TetrisGame:placeBlock(x, y, color)
    if y < 1 then
        return
    end
    local boardIndex = self:boardIndex(x, y)
    self.board[boardIndex] = color
    if color then
        if y < self.lowestBlockY then
            self.lowestBlockY = y
        end
        local textAreaX, textAreaY = self:position(x, y)
        ui.addTextArea(enum.textArea.GAME_BLOCK_START + boardIndex - 1, '', self.playerName, textAreaX, textAreaY, BLOCK_SIZE, BLOCK_SIZE, color, 0x010101, 1.0, true)
    else
        ui.removeTextArea(enum.textArea.GAME_BLOCK_START + boardIndex - 1, self.playerName)
    end
end

function TetrisGame:onEventLoop()
    if self.paused then
        return
    end
    if self.unpauseTimer > 0 then
        self.unpauseTimer = self.unpauseTimer - 0.5
        if self.unpauseTimer > 0 then
            self:updateUnpauseTimer()
            return
        else
            self.unpauseTimer = 0
            ui.removeTextArea(enum.textArea.UNPAUSE_TIMER, self.playerName)
        end
    end
    self:undrawCurrentPiece()
    self.currentPieceY = self.currentPieceY + 1
    self:checkCurrentPiece()
end

function TetrisGame:block(x, y)
    return self.board[x + (y - 1) * GAME_WIDTH]
end

function TetrisGame:boardIndex(x, y)
    return x + (y - 1) * GAME_WIDTH
end

function TetrisGame:position(x, y)
    return self.bgxPosition + (x - 1) * ACTUAL_BLOCK_SIZE, self.bgyPosition + (y - 1) * ACTUAL_BLOCK_SIZE
end

function TetrisGame:rotateCurrentPiece()
    self.currentPieceRotationPhase = self.currentPieceRotationPhase + 1
    if self.currentPieceRotationPhase > 4 then
        self.currentPieceRotationPhase = 1
    end
end

function TetrisGame:rotateCurrentPieceBackwards()
    self.currentPieceRotationPhase = self.currentPieceRotationPhase - 1
    if self.currentPieceRotationPhase < 1 then
        self.currentPieceRotationPhase = 4
    end
end

function TetrisGame:onKeyPress(keyCode)
    if keyCode == enum.key.ESC then
        self:togglePause()
        return
    end
    if self.paused or self.unpauseTimer > 0 then
        return
    end
    if keyCode == enum.key.LEFT then
        self.currentPieceX = self.currentPieceX - 1
        if self:currentPieceTouchesAnything() then
            self.currentPieceX = self.currentPieceX + 1
            return
        end
        self:updatePrediction()
    elseif keyCode == enum.key.UP then 
        self:rotateCurrentPiece()
        if self:currentPieceTouchesAnything() then
            self:rotateCurrentPieceBackwards()
            return
        end
        self:updatePrediction()
        self:playSound('transformice/son/dash.mp3')
    elseif keyCode == enum.key.RIGHT then
        self.currentPieceX = self.currentPieceX + 1
        if self:currentPieceTouchesAnything() then
            self.currentPieceX = self.currentPieceX - 1
            return
        end
        self:updatePrediction()
    elseif keyCode == enum.key.DOWN then
        self.currentPieceY = self.currentPieceY + 1
    elseif keyCode == enum.key.SPACE then
        self:hardDrop()
    elseif keyCode == enum.key.P then
        playerData[self.playerName].predictionEnabled = not playerData[self.playerName].predictionEnabled
        self:updatePrediction()
    end

    self:undrawCurrentPiece()
    self:checkCurrentPiece()
end

function TetrisGame:addUnpauseTimer()
    ui.addTextArea(enum.textArea.UNPAUSE_TIMER, '', self.playerName, 250, 150, 300, 100, 0, 0, 0, true)
end

function TetrisGame:updateUnpauseTimer()
    ui.updateTextArea(enum.textArea.UNPAUSE_TIMER, string.format('<p align="center"><font size="50" color="#FFFFFF" face="serif"><b>%d</b></font></p>', math.ceil(self.unpauseTimer)), self.playerName)
end

function TetrisGame:printBoard()
    for i = 1, GAME_HEIGHT do
        local rowStr = ''
        for j = 1, GAME_WIDTH do
            if self.board[j + ((i - 1) * GAME_WIDTH)] then
                rowStr = rowStr .. 'X '
            else
                rowStr = rowStr .. '  '
            end
        end
        print(rowStr)
    end
end

function TetrisGame:togglePause()
    self.paused = not self.paused
    if self.paused then
        ui.addTextArea(enum.textArea.FULLSCREEN_BACKGROUND, '', self.playerName, 0, 0, 800, 400, 0x010101, 0x010101, 0.5, true)
        ui.addTextArea(enum.textArea.PAUSE, '<p align="center"><font color="#FFFFFF" size="24">Paused</font></p>', self.playerName, 300, 150, 200, 100, 0x0A0A0A, 0xAAAAAA, 1.0, true)
        ui.addTextArea(enum.textArea.PAUSE_RESUME_BUTTON, '<a href="event:unpause"><p align="center"><font color="#FFFFFF" size="18">Resume</p></a>', self.playerName, 325, 215, 150, 25, 0x00FF00, 0x00AA00, 1.0, true)
    else
        ui.removeTextArea(enum.textArea.FULLSCREEN_BACKGROUND, self.playerName)
        ui.removeTextArea(enum.textArea.PAUSE, self.playerName)
        ui.removeTextArea(enum.textArea.PAUSE_RESUME_BUTTON, self.playerName)
        self.unpauseTimer = 3.0
        self:addUnpauseTimer()
        self:updateUnpauseTimer()
    end
end

function TetrisGame:addScore(score)
    self.score = self.score + score
    self:updateGameInfoTextArea()
end

function TetrisGame:playSound(sound)
    tfm.exec.playSound(sound, nil, nil, nil, self.playerName)
end

function TetrisGame:getCurrentPieceBlocks()
    return self.currentPiece.pieceBlocks[self.currentPieceRotationPhase]
end

function TetrisGame:getNextPieceBlocks()
    return self.nextPiece.pieceBlocks[1]
end

function TetrisGame:getCurrentPieceHeight()
    if self.currentPieceRotationPhase % 2 == 1 then
        return self.currentPiece.pieceHeight
    else
        return self.currentPiece.pieceWidth
    end
end

function TetrisGame:updatePrediction()
    for _, id in ipairs(self.predictionBlockTextAreasIds) do
        ui.removeTextArea(id, self.playerName)
    end
    self.predictionBlockTextAreasIds = {}

    if not playerData[self.playerName].predictionEnabled then
        return
    end

    local originalY = self.currentPieceY
    self.currentPieceY = math.max(originalY, self.lowestBlockY - self:getCurrentPieceHeight() + 1)
    while not self:currentPieceTouchesAnything() do
        self.currentPieceY = self.currentPieceY + 1
    end
    self.currentPieceY = self.currentPieceY - 1

    local startX = self.bgxPosition + ((self.currentPieceX - 1) * ACTUAL_BLOCK_SIZE)
    local startY = self.bgyPosition + ((self.currentPieceY - 2) * ACTUAL_BLOCK_SIZE)
    local blocks = self:getCurrentPieceBlocks()

    for i, row in ipairs(blocks) do
        for j, block in ipairs(row) do
            local id = enum.textArea.PREDICTION_BLOCK_START + #self.predictionBlockTextAreasIds
            self.predictionBlockTextAreasIds[#self.predictionBlockTextAreasIds + 1] = id
            ui.addTextArea(id, '', self.playerName, startX + ((block - 1) * ACTUAL_BLOCK_SIZE), startY + (i * ACTUAL_BLOCK_SIZE), BLOCK_SIZE, BLOCK_SIZE, 0x808080, 0xA0A0A0, 0.1, true)
        end
    end

    self.currentPieceY = originalY
end