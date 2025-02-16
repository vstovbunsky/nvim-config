vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
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
vim.o.guifont = "JetBrainsMono Nerd Font:h14"
vim.g.neovide_transparency = 0.97
vim.g.neovide_window_blurred = true
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

-- :EditConfig - opens this file, init.lua
local userprofile = os.getenv("USERPROFILE") or os.getenv("HOMEDRIVE")..os.getenv("HOMEPATH")
vim.cmd("command! EditConfig e " .. userprofile .. "/.config/nvim/init.lua")

-- Function to find the .exe file in the build/Debug directory
function Run_built_exe()
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

function SwitchHeaderSource()
    local current_file = vim.fn.expand("%:t") -- Get current file name with extension
    local current_extension = vim.fn.expand("%:e") -- Get current file extension
    local current_dir = vim.fn.expand("%:p:h") -- Get the current file's directory path

    if current_extension == "cpp" then
        -- Replace 'Private' with 'Public' in the directory path
        local header_dir = current_dir:gsub("\\Private$", "\\Public")
        local header_file = header_dir .. "\\" .. current_file:gsub("%.cpp$", ".h")
        if vim.fn.filereadable(header_file) == 1 then
            vim.cmd("bd! | edit " .. header_file)  -- Close current buffer and open the new file
        else
            print("Header file " .. header_file .. " not found")
        end
    elseif current_extension == "h" then
        -- Replace 'Public' with 'Private' in the directory path
        local source_dir = current_dir:gsub("\\Public$", "\\Private")
        local source_file = source_dir .. "\\" .. current_file:gsub("%.h$", ".cpp")
        if vim.fn.filereadable(source_file) == 1 then
            vim.cmd("bd! | edit " .. source_file)  -- Close current buffer and open the new file
        else
            print("Source file " .. source_file .. " not found")
        end
    else
        print("Not a .cpp or .h file")
    end
end

function Find_project_root()
    local current_dir = vim.fn.getcwd()

    -- Convert Windows backslashes to forward slashes
    current_dir = current_dir:gsub("\\", "/")

    -- Split the current directory into components
    local parts = vim.split(current_dir, "/")
    
    while #parts > 0 do
        local potential_root = table.concat(parts, "/")
        local uproject_file = vim.fn.glob(potential_root .. "/*.uproject")

        if uproject_file ~= "" then
            return potential_root
        end

        -- Remove the last directory and move up
        table.remove(parts)
    end

    print("Could not find .uproject file in the current directory or any parent directory.")
    return nil
end

function Run_bat_file(bat_file)
    local project_root = Find_project_root()
    if project_root then
        vim.cmd('!cd "' .. project_root .. '" && ' .. bat_file .. '"')
    else
        print("Failed to find project root.")
    end
end

function Build_and_launch()
    Run_bat_file('build.bat & editor.bat')
end

function Build_only()
    Run_bat_file('build.bat')
end

function Generate_lsp_bindings()
    Run_bat_file('generate.bat')
end


-- always copy-paste using the system clipboard
vim.opt.clipboard = "unnamedplus"
-- makes it so you don't lose your clipboard when pasting over selected text
vim.keymap.set("x", "<leader>p", "\"_dP", { noremap = true, silent = true })
-- prevent deleting from overwriting clipboard
vim.keymap.set("n", "d", "\"_d", { noremap = true })
vim.keymap.set("x", "d", "\"_d", { noremap = true })
vim.keymap.set("n", "c", "\"_c", { noremap = true })
vim.keymap.set("x", "c", "\"_c", { noremap = true })
vim.keymap.set("n", "x", "\"_x", { noremap = true })
vim.keymap.set("x", "x", "\"_x", { noremap = true })

-- TODO: figure this part out
-- yank to system clipboard
-- vim.keymap.set("n", "<leader>y", "\"+y")
-- vim.keymap.set("v", "<leader>y", "\"+y")
-- vim.keymap.set("n", "<leader>Y", "\"+Y")
--
-- vim.keymap.set("n", "<leader>p", "\"+p")
-- vim.keymap.set("v", "<leader>p", "\"+p")
-- vim.keymap.set("n", "<leader>P", "\"+P")
--
-- -- delete to void register
-- vim.keymap.set("n", "<leader>d", "\"_d")
-- vim.keymap.set("v", "<leader>d", "\"_d")

-- Bind Alt+O to switch between .cpp and .h files
vim.api.nvim_set_keymap('n', '<M-o>', ':lua SwitchHeaderSource()<CR>', { noremap = true, silent = true })

-- For CMAKE projects
-- F5 - Build and launch the project
--vim.api.nvim_set_keymap('n', '<F5>', ':lua Run_built_exe()<CR>', { noremap = true, silent = true })
-- F6 - Build the project
--vim.api.nvim_set_keymap('n', '<F6>', ':!cmake --build ./build<CR>', { noremap = true, silent = true })

-- For UNREAL ENGINE projects
-- F5 - Build and launch the project
vim.api.nvim_set_keymap('n', '<F5>', ':lua Build_and_launch()<CR>', { noremap = true, silent = true })
-- F6 - Build the project
vim.api.nvim_set_keymap('n', '<F6>', ':lua Build_only()<CR>', { noremap = true, silent = true })
-- F7 - Generate LSP bindings
vim.api.nvim_set_keymap('n', '<F7>', ':lua Generate_lsp_bindings()<CR>', { noremap = true, silent = true })

