TetrisGame = {
    playerName = nil,
    board = {},
    currentPiece = nil,
    nextPiece = nil,
    currentPieceX = 1,
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
    o.currentPiece = piece_prototypes[math.random(#piece_prototypes)]:copy()
    o.nextPiece = piece_prototypes[math.random(#piece_prototypes)]:copy()
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
end

function TetrisGame:drawCurrentPiece()
    local startX = self.bgxPosition + ((self.currentPieceX - 1) * ACTUAL_BLOCK_SIZE)
    local startY = self.bgyPosition + ((self.currentPieceY - 1) * ACTUAL_BLOCK_SIZE)

    local blocks = self.currentPiece:getBlocks()

    local pieceWidth, pieceHeight = 0, 0

    for i, row in ipairs(blocks) do
        pieceWidth = math.max(pieceWidth, #row)
        if #row ~= 0 then 
            pieceHeight = pieceHeight + 1 
        end
    end

    for i, row in ipairs(blocks) do
        for j, block in ipairs(row) do
            local id = enum.textArea.CURRENT_PIECE_BLOCK_START + (i * pieceWidth) + block - 1
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
        pieceWidth = math.max(pieceWidth, #row)
        if #row ~= 0 then 
            pieceHeight = pieceHeight + 1 
        end
    end

    local startX = self.npxPosition + (self.npTextAreaWidth / 2) - (pieceWidth * ACTUAL_BLOCK_SIZE / 2)
    local startY = self.npyPosition + 50

    for i, row in ipairs(blocks) do
        for j, block in ipairs(row) do
            local id = enum.textArea.NEXT_PIECE_BLOCK_START + (i * pieceWidth) + block - 1
            self.nextPieceBlockTextAreasIds[#self.nextPieceBlockTextAreasIds + 1] = id
            ui.addTextArea(id, '', self.playerName, startX + ((block - 1) * ACTUAL_BLOCK_SIZE), startY + (i * ACTUAL_BLOCK_SIZE), BLOCK_SIZE, BLOCK_SIZE, self.nextPiece.color, 0x010101, 1.0, true)
        end
    end
end

function TetrisGame:endGame()
    addStartGameButton(self.playerName)
end

function TetrisGame:checkCurrentPiece()
    local blocks = self.currentPiece:getBlocks()
    for i, row in ipairs(blocks) do
        for j, block in ipairs(row) do
            local blockX = self.currentPieceX + block - 2
            local blockY = self.currentPieceY + i - 1
            if blockY > GAME_HEIGHT or self:block(blockX, blockY) then
                self.currentPieceY = self.currentPieceY - 1
                self:installCurrentPiece()
                return
            end
        end
    end
end

function TetrisGame:installCurrentPiece()
    local blocks = self.currentPiece:getBlocks()
    for i, row in ipairs(blocks) do
        for j, block in ipairs(row) do
            local blockX = self.currentPieceX + block - 1
            local blockY = self.currentPieceY + i - 1
            self:placeBlock(blockX, blockY, self.currentPiece.color)
        end
    end
    self.currentPieceY = 1
    self.currentPiece = self.nextPiece
    self.nextPiece = piece_prototypes[math.random(#piece_prototypes)]:copy()
    self:updateNextPiecePreview()
end

function TetrisGame:placeBlock(x, y, color)
    local boardIndex = self:boardIndex(x, y)
    self.board[boardIndex] = self.currentPiece.color
    local textAreaX, textAreaY = self:position(x, y)
    ui.addTextArea(enum.textArea.GAME_BLOCK_START + boardIndex - 1, '', self.playerName, textAreaX, textAreaY, BLOCK_SIZE, BLOCK_SIZE, color, 0x010101, 1.0, true)
end

function TetrisGame:onEventLoop()
    self:undrawCurrentPiece()
    self.currentPieceY = self.currentPieceY + 1
    self:checkCurrentPiece()
    self:drawCurrentPiece()
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
        
    elseif keyCode == enum.key.UP then 
    
    end
end