local M = {}

M.config = function()
  -- auto wrap
  -- =========================================
  vim.cmd [[
    set wrap
  ]]

  vim.o.termguicolors = true
  -- which_key
  -- =========================================
  require("user.which-key").config()

  require("user.keybindings").config()
  -- Telescope
  -- =========================================
  require("user.telescope").config()

  -- Bufferline
  -- =========================================
  lvim.builtin.bufferline.options.numbers = "ordinal"

  -- LuaLine
  -- =========================================
  lvim.builtin.lualine.options = require("user.utils").lualine.options
  lvim.builtin.lualine.sections = require("user.utils").lualine.sections
  lvim.builtin.lualine.inactive_sections = require("user.utils").lualine.inactive_sections
  lvim.builtin.lualine.tabline = {}
  lvim.builtin.lualine.extensions = {}

  -- DAP
  -- =========================================
  require("user.dap").config()
end

return M
