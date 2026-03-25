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
            tag = "v0.9.3",
            build = function()
                -- Update parsers
                vim.cmd("TSUpdate")
                -- Patch: remove "except*" node from Python highlights query
                -- (incompatible with Neovim 0.11.x treesitter engine, fixed in 0.12)
                local qpath = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/queries/python/highlights.scm"
                local f = io.open(qpath, "r")
                if f then
                    local content = f:read("*a")
                    f:close()
                    local patched = content:gsub('%s*"except%*"\n', "\n")
                    if patched ~= content then
                        f = io.open(qpath, "w")
                        if f then
                            f:write(patched)
                            f:close()
                        end
                    end
                end
            end,
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = {
                        "bash",
                        "json",
                        "lua",
                        "markdown",
                        "python",
                        "yaml",
                    },
                    auto_install = true,
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end,
        },
    },
    checker = { enabled = false },
})
