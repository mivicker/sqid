local web_arm = require("sqid.web_arm")
local str_arm = require("sqid.str_arm")
local grabber_arm = require("sqid.grabber_arm")
local file_arm = require("sqid.file_arm")

--TODO: Window like coq or other completion & select with tab from top 3
--TODO: Print out to new file if it doesn't exist
--TODO: Create proper vim commands
--TODO: Search and add filename
--TODO: Add brackets command

local sqid = {}

local function with_defaults(options)
    return {
        name = options.name or "Harvey"
    }
end

function sqid.setup(options)
    sqid.options = with_defaults(options)
end

function sqid.is_configured()
    return sqid.options ~= nil
end

function sqid.web()
    if not sqid.is_configured() then
        return
    end

    local web_reply = web_arm.search_wikidata(grabber_arm.get_visual_selection())

    vim.api.nvim_put(web_reply, "l", false, true)
end

function sqid.web_to_file()
    if not sqid.is_configured() then
        return
    end

    local search_string = grabber_arm.get_visual_selection()
    local web_reply = web_arm.search_wikidata(search_string)
    local long_string = str_arm.from_lines(web_reply)

    file_arm.write_string_to_file(long_string, search_string .. ".md")
end

sqid.options = nil
return sqid
