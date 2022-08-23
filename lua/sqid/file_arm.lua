local with = require("plenary.context_manager.with")
local open = require("plenary.context_manager.open")

local file_arm = {}

function file_arm.write_string_to_file(string, filename)
    local _ = with(open(filename, "w"), function (writer)
        writer:write(string)
   end)
end

return file_arm
