local web_arm = require("sqid.web_arm")
local str_arm = require("sqid.str_arm")
local grabber_arm = require("sqid.grabber_arm")
local file_arm = require("sqid.file_arm")
local feeler_arm = require("sqid.feeler_arm")
local inspect    = require("vim.inspect")


--TODO: Pop-up window to select with <C-n> <C-p> from top 3-5
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


function sqid.askwayne()
    if not sqid.is_configured() then
        return
    end

    local search_string = grabber_arm.get_visual_selection()
    local response = web_arm.checkwayne(search_string)
    if response == nil then
        print("Request returned nothing...")
    end
    local body = vim.fn.json_decode(response["body"])
    print(inspect(body))
    --["choices"][0]["text"]
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


function sqid.pop_window()
    if not sqid.is_configured() then
        return
    end
    local search_string = grabber_arm.get_visual_selection()
    local content = web_arm.return_several(search_string)
    feeler_arm.open_window(content)
end

sqid.options = nil
return sqid
