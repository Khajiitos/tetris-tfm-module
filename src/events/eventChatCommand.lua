function eventChatCommand(playerName, message)
    local args = {}
    for arg in message:gmatch("%S+") do
        args[#args + 1] = arg
    end
    local command = table.remove(args, 1)
end