local str_arm = {}


function str_arm.stringsplit (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end


local function trim(inputstr, max_width)
    local result = {}
    local line = {}
    local line_length = 0
    for _, word in ipairs(str_arm.stringsplit(inputstr)) do
        line_length = line_length + #word
        if line_length > (max_width - 1) then
            table.insert(result, table.concat(line, " "))
            line = {}
            line_length = 0
        else
            table.insert(line, word)
        end
    end
    return result
end


local function flatten(inputtable)
    local result = {}
    for _, v in ipairs(inputtable) do
        if type(v) == "table" then
            for _, i in ipairs(v) do
                table.insert(result, i)
            end
        else
            table.insert(result, v)
        end
    end
    return result
end


function str_arm.wrap(lines, max_width)
    local stacked = {}
    for _, line in ipairs(lines) do
        table.insert(stacked, trim(line, max_width))
    end
    return flatten(stacked)
end


function str_arm.from_lines(lines)
    return table.concat(lines, "\n")
end

return str_arm


