local str_arm = {}

-- Get the cursor line
-- local pos = vim.api.nvim_win_get_cursor(0)
-- Grab the line text
-- vim.api.nvim_buf_get_lines(0, pos, pos + 1, true)

function str_arm.greet()
    local row, _ = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)
    return "Hello " .. line
end

return str_arm


