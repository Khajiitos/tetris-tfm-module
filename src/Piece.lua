Piece = {
    color = 0xFF0000,
    pieceBlocks = {},
    pieceWidth = 0,
    pieceHeight = 0
}

function Piece:new(color, pieceBlocks)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.color = color
    o.pieceBlocks = pieceBlocks

    for i, row in ipairs(o:getBlocks(1)) do
        for j, block in ipairs(row) do
            o.pieceWidth = math.max(o.pieceWidth, block)
        end
        if #row ~= 0 then
            o.pieceHeight = o.pieceHeight + 1
        end 
    end
    return o
end

function Piece:getBlocks(rotationPhase)
    return self.pieceBlocks[rotationPhase]
end