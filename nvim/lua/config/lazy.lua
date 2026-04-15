-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { "projekt0n/github-nvim-theme" },
        { "navarasu/onedark.nvim" },
        {
            "folke/tokyonight.nvim",
            priority = 1000,
            config = function()
                vim.cmd.colorscheme("tokyonight-night")
            end,
        },
        { "ellisonleao/gruvbox.nvim" },
        {
            "nvim-treesitter/nvim-treesitter",
            lazy = false,
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter").install({
                    "bash", "html", "javascript", "json", "lua", "markdown", "markdown_inline", "python", "yaml",
                })
                vim.api.nvim_create_autocmd("FileType", {
                    callback = function()
                        pcall(vim.treesitter.start)
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end,
                })
            end,
        },
    },
    checker = { enabled = false },
})
