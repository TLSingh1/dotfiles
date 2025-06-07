return {
  "statusline",
  lazy = false,
  priority = 1000,
  before = function()
    -- Statusline component functions
    local function statusline_left()
      return " Left Section "
    end

    local function statusline_middle()
      return "Middle Section"
    end

    local function statusline_right()
      return " Right Section "
    end

    -- Build the complete statusline
    local function build_statusline()
      local left = statusline_left()
      local middle = statusline_middle()
      local right = statusline_right()
      
      -- Calculate padding for center alignment
      local width = vim.api.nvim_win_get_width(0)
      local left_len = vim.fn.strwidth(left)
      local middle_len = vim.fn.strwidth(middle)
      local right_len = vim.fn.strwidth(right)
      
      local padding_left = math.floor((width - middle_len) / 2) - left_len
      local padding_right = width - left_len - padding_left - middle_len - right_len
      
      -- Ensure positive padding
      padding_left = math.max(0, padding_left)
      padding_right = math.max(0, padding_right)
      
      return left .. string.rep(" ", padding_left) .. middle .. string.rep(" ", padding_right) .. right
    end

    -- Set up the statusline
    _G.CustomStatusline = build_statusline
    vim.opt.statusline = "%{%v:lua.CustomStatusline()%}"
    
    -- Always show statusline
    vim.opt.laststatus = 3 -- Global statusline
  end,
}