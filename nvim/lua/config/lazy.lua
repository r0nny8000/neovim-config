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
        {
            "stevearc/conform.nvim",
            event = { "BufWritePre" },
            cmd = { "ConformInfo" },
            keys = {
                {
                    "<leader>f",
                    function()
                        require("conform").format({ async = true })
                    end,
                    mode = "",
                    desc = "Format buffer",
                },
            },
            opts = {
                formatters_by_ft = {
                    bash = { "shfmt" },
                    html = { "prettier" },
                    javascript = { "prettier" },
                    json = { "prettier" },
                    lua = { "stylua" },
                    markdown = { "prettier" },
                    python = { "black" },
                    sh = { "shfmt" },
                    yaml = { "prettier" },
                },
                default_format_opts = {
                    lsp_format = "fallback",
                },
                format_on_save = { timeout_ms = 1000 },
            },
        },
    },
    checker = { enabled = false },
})
