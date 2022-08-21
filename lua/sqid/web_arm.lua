local curl = require("plenary.curl")
local web_arm = {}

local base_url = "https://www.wikidata.org/w/api.php"
local base_query_str = "?action=wbsearchentities&format=json&language=en&type=item&continue=0&limit=3"

function web_arm.search_wikidata(search_string)
    local last_param = "&search=" .. search_string
    local url = base_url .. base_query_str .. last_param
    return vim.inspect(curl.get(url))
end

return web_arm
