local curl = require("plenary.curl")
local inspect = require("vim.inspect")

local web_arm = {}

local base_url = "https://www.wikidata.org/w/api.php"
local base_query_str = "?action=wbsearchentities&format=json&language=en&type=item&continue=0&limit=3"

-- keeping secrets in a json file for now.

local function readAll(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*a")
    f:close()
    return content
end


local secretsfile = readAll("/home/michael/.config/nvim/secrets.json")
local secrets = vim.fn.json_decode(secretsfile)
local apikey = secrets["openai_key"]

local oedid = secrets["oed_id"]
local oedkey = secrets["oed_key"]


function web_arm.checkwayne(content)
    local openai_url = "https://api.openai.com/v1/completions"

    local json = {
        model = "text-davinci-003",
        prompt = content,
        max_tokens = 350,
        n = 1,
        temperature = 0.5,
        stream = false,
    }

    local body = vim.fn.json_encode(json)
    local response = curl.post(openai_url, {
        headers = {
            content_type = "application/json",
            authorization = "Bearer "..apikey,
        },
        body = body,
    })
    return response
end

function web_arm.checkoed(word)
    local oedbase = "https://od-api.oxforddictionaries.com:443/api/v2/"
    local entries = "entries" --also make this configurable
    local language = "en-us" --make this configurable eventually.

    local oedurl = oedbase .. entries .. "/" .. language .. "/" .. word:lower()

    local response = curl.get(oedurl, {
        headers = {
           app_id = oedid,
           app_key = oedkey,
        }
    })
    return response
end

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
    if result == nil then
        return {}
    end
    local search = vim.fn.json_decode(result["body"])
    if not search["search"] then
        return format_nothing_found(search_string)
    end
    return search["search"]
end


local function format_result_listing(result_listing)
    if result_listing["description"] == nil then
        result_listing["description"] = ""
    end
    return result_listing["id"].." - " .. result_listing["label"] .. ": " .. result_listing["description"]
end


local function search_lines(lines)
    local result = {}
    for _, line in ipairs(lines) do
        table.insert(result, format_result_listing(line))
    end
    print(result)
    return result
end


function web_arm.return_several(search_string)
    local lines = search_wikidata_all(search_string)
    return search_lines(lines)
end


function web_arm.search_wikidata(search_string)
    local search = search_wikidata_all(search_string)
    return format_wikidata_obj(search[1])
end


return web_arm

