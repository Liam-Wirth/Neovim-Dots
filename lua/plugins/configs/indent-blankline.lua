local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        local gbox = {
            red = vim.api.nvim_get_hl(0, { name = "GruvboxRed" }),
            yellow = vim.api.nvim_get_hl(0, { name = "GruvboxYellow" }),
            blue = vim.api.nvim_get_hl(0, { name = "GruvboxBlue" }),
            orange = vim.api.nvim_get_hl(0, { name = "GruvboxOrange" }),
            green = vim.api.nvim_get_hl(0, { name = "GruvboxGreen" }),
            violet = vim.api.nvim_get_hl(0, { name = "GruvboxPurple" }),
            cyan = vim.api.nvim_get_hl(0, { name = "GruvboxAqua" }),
        }

        require("ibl.hooks").register("HIGHLIGHT_SETUP", function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = gbox.red.fg })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = gbox.yellow.fg })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = gbox.blue.fg })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = gbox.orange.fg })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = gbox.green.fg })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = gbox.violet.fg })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = gbox.cyan.fg })
        end)

        -- Set up IBL after colors and hooks are applied
        require("ibl").setup({
            indent = { highlight = highlight },
        })
    end
})

