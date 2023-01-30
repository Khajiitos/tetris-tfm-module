TetrisGame = {
    playerName = nil,
    board = {},
    currentPiece = nil,
    nextPiece = nil,
    currentPieceX = 4,
    currentPieceY = 1,

    npTextAreaWidth = 0,
    npTextAreaHeight = 0,
    bgTextAreaWidth = 0,
    bgTextAreaHeight = 0,
    npxPosition = 0,
    npyPosition = 0,
    bgxPosition = 0,
    bgyPosition = 0,

    currentPieceBlockTextAreasIds = {},
    nextPieceBlockTextAreasIds = {}
}

function TetrisGame:new(playerName)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.playerName = playerName
    o.currentPieceBlockTextAreasIds = {}
    o.nextPieceBlockTextAreasIds = {}
    o.currentPiece = piece_prototypes[math.random(#piece_prototypes)]:copy()
    o.nextPiece = piece_prototypes[math.random(#piece_prototypes)]:copy()
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
    self:updateNextPiecePreview()
    self:drawCurrentPiece()

    tfm.exec.freezePlayer(self.playerName, true, false)
end

function TetrisGame:drawCurrentPiece()
    local startX = self.bgxPosition + ((self.currentPieceX - 1) * ACTUAL_BLOCK_SIZE)
    local startY = self.bgyPosition + ((self.currentPieceY - 1) * ACTUAL_BLOCK_SIZE)

    local blocks = self.currentPiece:getBlocks()

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
    local blocks = self.nextPiece:getBlocks()
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

    for _, id in ipairs(self.currentPieceBlockTextAreasIds) do
        ui.removeTextArea(id, self.playerName)
    end

    for _, id in ipairs(self.nextPieceBlockTextAreasIds) do
        ui.removeTextArea(id, self.playerName)
    end

    for i = enum.textArea.GAME_BLOCK_START, enum.textArea.GAME_BLOCK_START + GAME_HEIGHT * GAME_WIDTH do
        ui.removeTextArea(i, self.playerName)
    end

    playerData[self.playerName].game = nil
    tfm.exec.freezePlayer(self.playerName, false)
    self.playerName = ''
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
    local blocks = self.currentPiece:getBlocks()
    for i, row in ipairs(blocks) do
        for j, block in ipairs(row) do
            local blockX = self.currentPieceX + block - 1
            local blockY = self.currentPieceY + i - 1
            if blockY > GAME_HEIGHT or self:block(blockX, blockY) or blockX < 1 or blockX > GAME_WIDTH then
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
    local blocks = self.currentPiece:getBlocks()
    for i, row in ipairs(blocks) do
        for j, block in ipairs(row) do
            local blockX = self.currentPieceX + block - 1
            local blockY = self.currentPieceY + i - 1
            self:placeBlock(blockX, blockY, self.currentPiece.color)
            self:checkRow(blockY)
        end
    end
    self.currentPieceY = 1
    self.currentPieceX = 4
    self.currentPiece = self.nextPiece
    self.nextPiece = piece_prototypes[math.random(#piece_prototypes)]:copy()
    self:updateNextPiecePreview()
    self:drawCurrentPiece()

    if self:currentPieceTouchesAnything() then
        self:endGame()
    end
end

function TetrisGame:placeBlock(x, y, color)
    local boardIndex = self:boardIndex(x, y)
    self.board[boardIndex] = color
    if color then
        local textAreaX, textAreaY = self:position(x, y)
        ui.addTextArea(enum.textArea.GAME_BLOCK_START + boardIndex - 1, '', self.playerName, textAreaX, textAreaY, BLOCK_SIZE, BLOCK_SIZE, color, 0x010101, 1.0, true)
    else
        ui.removeTextArea(enum.textArea.GAME_BLOCK_START + boardIndex - 1, self.playerName)
    end
end

function TetrisGame:onEventLoop()
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

function TetrisGame:onKeyPress(keyCode)
    if keyCode == enum.key.LEFT then
        self.currentPieceX = self.currentPieceX - 1
        if self:currentPieceTouchesAnything() then
            self.currentPieceX = self.currentPieceX + 1
            return
        end
    elseif keyCode == enum.key.UP then 
        self.currentPiece:rotate()
        if self:currentPieceTouchesAnything() then
            self.currentPiece:rotateBackwards()
            return
        end
        self:printBoard()
    elseif keyCode == enum.key.RIGHT then
        self.currentPieceX = self.currentPieceX + 1
        if self:currentPieceTouchesAnything() then
            self.currentPieceX = self.currentPieceX - 1
            return
        end
    elseif keyCode == enum.key.DOWN then
        self.currentPieceY = self.currentPieceY + 1
    end

    self:undrawCurrentPiece()
    self:checkCurrentPiece()
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