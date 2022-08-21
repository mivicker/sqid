local str_arm = require("sqid.str_arm")

local sqid = {}

local function with_defaults(options)
    return {
        name = options.name or "Harvey"
    }
end

function sqid.setup(options)
    sqid.options = with_defaults(options)

    vim.api.nvim_create_user_command("SqidTest", sqid.test, {})
end

function sqid.is_configured()
    return sqid.options ~= nil
end

function sqid.test()
    if not sqid.is_configured() then
        return
    end

    local greeting = str_arm.grab_line_under_cursor()
    print(greeting)
end

sqid.options = nil
return sqid
