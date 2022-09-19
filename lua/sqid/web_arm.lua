local curl = require("plenary.curl")
local web_arm = {}

local base_url = "https://www.wikidata.org/w/api.php"
local base_query_str = "?action=wbsearchentities&format=json&language=en&type=item&continue=0&limit=3"


local function format_wikidata_obj(obj)
    local template = {"---",
        string.format("qid: %s", obj["id"]),
        "publish: false",
        "---",
        "",
        string.format("# %s", obj["label"]),
        string.format("%s", obj["description"])}
    return template
end



local function format_nothing_found(search_string)
    local template = {"---",
        "publish: false",
        "---",
        "",
        string.format("# %s", search_string)}
    return template
end


local function search_wikidata_all(search_string)
    local subbed, _ = search_string:gsub(" ", "%%20")
    local last_param = "&search=" .. subbed
    local url = base_url .. base_query_str .. last_param
    local result = curl.get(url)
    local search = vim.fn.json_decode(result["body"])
    if not search["search"] then
        return format_nothing_found(search_string)
    end
    return search["search"]
end


local function format_result_listing(result_listing)
    return result_listing["label"] .. ": " .. result_listing["description"]
end

local function search_lines(lines)
    local result = {}
    for _, line in ipairs(lines) do
        table.insert(result, format_result_listing(line))
    end
    return result
end


function web_arm.return_several(search_string)
    local search = search_wikidata_all(search_string)
    return search_lines(search)
end

function web_arm.search_wikidata(search_string)
    local search = search_wikidata_all(search_string)
    return format_wikidata_obj(search[1])
end


return web_arm

