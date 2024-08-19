vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Automatically go to the last known cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})  

-- Neovim appearance
if not vim.g.neovide then
  vim.opt.guifont = "JetBrainsMono Nerd Font:h16"
  -- Set the background color to none (transparent)
  vim.cmd [[
    hi Normal guibg=NONE ctermbg=NONE
    hi NonText guibg=NONE ctermbg=NONE
  ]]
end

-- Neovide appearance
vim.o.guifont = "JetBrainsMono Nerd Font:h16"
vim.g.neovide_transparency = 0.97
vim.g.neovide_window_blurred = true
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

-- Function to find the .exe file in the build/Debug directory
function run_built_exe()
  vim.cmd('!cmake --build ./build')

  local exe_file = nil
  local pfile = io.popen('dir /b build\\Debug\\*.exe')  -- List all .exe files in the directory
  if pfile then
    exe_file = pfile:read('*a'):gsub('[\n\r]+', '')  -- Read the file name and remove newlines
    pfile:close()
  end

  if exe_file and exe_file ~= '' then
    vim.cmd('!build\\Debug\\' .. exe_file)
  else
    print('No .exe file found in build\\Debug directory')
  end
end

-- F6 - Build and launch the project
vim.api.nvim_set_keymap('n', '<F5>', ':lua run_built_exe()<CR>', { noremap = true, silent = true })
-- F6 - Build the project
vim.api.nvim_set_keymap('n', '<F6>', ':!cmake --build ./build<CR>', { noremap = true, silent = true })
-- :EditConfig - opens this file, init.lua
local userprofile = os.getenv("USERPROFILE") or os.getenv("HOMEDRIVE")..os.getenv("HOMEPATH")
vim.cmd("command! EditConfig e " .. userprofile .. "/.config/nvim/init.lua")
