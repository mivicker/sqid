local curl = require("plenary.curl")
local web_arm = {}

function web_arm.get_ugly_photography()
    return vim.inspect(curl.get("http://ugly.photography"))
end

return web_arm
