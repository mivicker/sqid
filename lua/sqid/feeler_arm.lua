local api = vim.api
local buf, win
local feeler_arm = {}

local str_arm = require"sqid.str_arm"

function feeler_arm.open_window(content)
    buf = api.nvim_create_buf(false, true)
    local border_buf = api.nvim_create_buf(false, true)

    api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

    -- get dimensions
    local width = api.nvim_get_option('columns')
    local height = api.nvim_get_option('lines')

    -- calc floating window width
    local win_width = math.ceil(width * 0.8)

    -- wrap content to width
    local wrapped = str_arm.wrap(content, win_width - 2)

    -- set window height to match wrapped content
    local win_height = #wrapped + 1

    -- and its starting position
    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)

    -- set some options
    local border_opts = {
        style = 'minimal',
        relative = 'editor',
        width = win_width + 3,
        height = win_height + 2,
        row = row - 1,
        col = col - 2,
    }

    local opts = {
        style = 'minimal',
        relative = 'editor',
        width = win_width,
        height = win_height,
        row = row,
        col = col,
    }

    local border_lines = {"┌─ 🦑𐌔𐌒𐌉𐌃 ─" .. string.rep("─", win_width - 9) .. "┐"}
    local middle_line = "│" .. string.rep(" ", win_width + 2) .. "│"
    for _=1, win_height do
        table.insert(border_lines, middle_line)
    end
    table.insert(border_lines, "└" .. string.rep("─", win_width + 2) .. "┘")

    api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)
    if not content then
        content = ""
    end
    api.nvim_buf_set_lines(buf, 0, -1, false, wrapped)

    local border_win = api.nvim_open_win(border_buf, true, border_opts)
    local win = api.nvim_open_win(buf, true, opts)

    api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "' .. border_buf)
end

return feeler_arm
