local M = {}

M.starts_with = function(str, start)
  return str:sub(1, #start) == start
end

M.ends_with = function(str, ending)
  return ending == "" or str:sub(- #ending) == ending
end

-- file exist?
M.exists = function(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end


M.SaveAndExit = function()
  -- wirte all buffer first
  vim.api.nvim_command(":wa")
  -- quit all buffer
  vim.api.nvim_command(":qa")
end


-- gtags
M.GtagsRefernce = function()
  local word = vim.api.nvim_call_function("expand", { "<cword>" })
  vim.api.nvim_command(":cs find c " .. word)
  vim.api.nvim_command(":copen")
end

M.GtagsText = function()
  local word = vim.api.nvim_call_function("expand", { "<cword>" })
  vim.api.nvim_command(":cs find t " .. word)
  vim.api.nvim_command(":copen")
end

M.telescope_center = {
  theme = "center",
  defaults = {
    layout_config = {
      prompt_position = "bottom",
      horizontal = {
        width_padding = 0.1,
        height_padding = 0.1,
        preview_width = 0.6,
      },
      vertical = {
        width_padding = 0.05,
        height_padding = 1,
        preview_height = 0.5,
      },
    }
  }

}

-- LuaLine
-- ====================================

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = false,
  update_in_insert = false,
  always_visible = true,
}

local diff = {
  "diff",
  colored = true,
  symbols = { added = "  ", modified = " ", removed = " " },
  diff_color = {
    added = { fg = "#98be65" },
    modified = { fg = "#ecbe7b" },
    removed = { fg = "#ec5f67" },
  },
  cond = hide_in_width
}

local mode = {
  "mode",
  fmt = function(str)
    return "-- " .. str .. " --"
  end,
}


local file_name = {
  'filename',
  file_status = true, -- Displays file status (readonly status, modified status)
  path = 1,           -- 0: Just the filename
  -- 1: Relative path
  -- 2: Absolute path

  shorting_target = 40, -- Shortens path to leave 40 spaces in the window
  -- for other components. (terrible name, any suggestions?)
  symbols = {
    modified = '[+]',      -- Text to show when the file is modified.
    readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
    unnamed = '[No Name]', -- Text to show for unnamed buffers.
  },
}

local filetype = {
  "filetype",
  icons_enabled = false,
  icon = nil,
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
}

local location = {
  "location",
  padding = 0,
}

-- cool function for progress
local progress = function()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")
  -- local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  local chars = { "██", "▇▇", "▆▆", "▅▅", "▄▄", "▃▃", "▂▂", "▁▁", " ", }
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local spaces = function()
  return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

M.lualine = {
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    -- component_separators = { left = "", right = "" },
    -- section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { branch, diagnostics },
    lualine_b = { mode },
    lualine_c = { file_name },
    lualine_x = { diff, spaces, "encoding", filetype, "fileformat" },
    lualine_y = { location },
    lualine_z = { progress },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { file_name },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}
return M
