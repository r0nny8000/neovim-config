-- Sample Lua file for treesitter testing

local M = {}

function M.greet(name)
    local message = string.format("Hello, %s!", name)
    print(message)
    return message
end

local items = { "one", "two", "three" }
for i, item in ipairs(items) do
    if i > 1 then
        M.greet(item)
    end
end

return M
