Piece = {
    color = 0xFF0000,
    rotationPhase = 1,
    pieceBlocks = {}
}

function Piece:new(color, pieceBlocks)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.color = color
    o.pieceBlocks = pieceBlocks
    return o
end

function Piece:rotate()
    self.rotationPhase = self.rotationPhase + 1
    if self.rotationPhase >= 5 then
        self.rotationPhase = 1
    end
end

function Piece:rotateBackwards()
    self.rotationPhase = self.rotationPhase - 1
    if self.rotationPhase <= 0 then
        self.rotationPhase = 4
    end
end

function Piece:copy()
    return Piece:new(self.color, table.copy(self.pieceBlocks, true))
end

function Piece:getBlocks()
    return self.pieceBlocks[self.rotationPhase]
end