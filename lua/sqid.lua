local str_arm = require("sqid.str_arm")
local web_arm = require("sqid.web_arm")
local grabber_arm = require("sqid.grabber_arm")

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

function sqid.web()
    if not sqid.is_configured() then
        return
    end

    local search_string = "Karen Sparck Jones"
    local subbed = search_string:gsub(" ", "%20")
    print(subbed)

    local web_reply = web_arm.search_wikidata(subbed)
    print(web_reply)
end

function sqid.grabber_arm()
    if not sqid.is_configured() then
        return
    end

    local grabbed = grabber_arm.get_visual_selection()
    print(grabbed)
end

sqid.options = nil
return sqid
