OUTPUT_FILE = 'output.lua'
FILE_PREFIX = 'src/'

--[[ Files will be pasted in the order below ]]
files = {
    'constants.lua',
    'globals.lua',
    'utils.lua',

    'Piece.lua',
    'pieces.lua',

    'TetrisGame.lua',
    'PlayerData.lua',

    'events/eventChatCommand.lua',
    'events/eventKeyboard.lua',
    'events/eventNewPlayer.lua',
    'events/eventPlayerLeft.lua',
    'events/eventPlayerDied.lua',
    'events/eventTextAreaCallback.lua',
    'events/eventLoop.lua',

    'main.lua'
}

local fileOutput, errorMessage = io.open(OUTPUT_FILE, 'w')

if not fileOutput then
    print("Couldn't open output file " .. errorMessage)
    os.exit()
else
    print("Writing to " .. OUTPUT_FILE .. '...')
end

filesWritten = 0

fileOutput:write('--[[ Built: ' .. os.date('%X %d %b, %Y') .. ' ]]\n\n')

for i, file in ipairs(files) do
    local f, errorMessage = io.open(FILE_PREFIX .. file, 'r')

    if f then
        local fileContent = f:read('*a')
        fileOutput:write('--[[ Start: ' .. file .. ' ]]\n')
        fileOutput:write(fileContent)
        fileOutput:write('\n--[[ End: ' .. file .. ' ]]')
        if i ~= #files then
            fileOutput:write('\n\n')
        end
        print('[SUCCESS] ' .. FILE_PREFIX .. file)
        filesWritten = filesWritten + 1
    else
        print('[ERROR] ' .. errorMessage)
    end
end

if filesWritten == 0 then
    print("Complete: no files were merged.")
else
    print("Complete: successfully merged " .. filesWritten .. (filesWritten == 1 and " file" or " files") .. " together.")
end