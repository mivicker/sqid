local str_arm = {}

function str_arm.grab_line_under_cursor()
    local pos = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_buf_get_lines(0, pos[1] - 1, pos[1], true)
    return line[1]
end

return str_arm


