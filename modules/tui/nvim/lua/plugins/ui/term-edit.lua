-- term-edit.nvim - Edit terminal buffers like regular buffers

return {
  "term-edit.nvim",
  
  -- Only load if ui category is enabled
  enabled = function()
    return nixCats.cats.ui
  end,
  
  -- Load when entering a terminal buffer
  event = "TermOpen",
  
  after = function()
    require("term-edit").setup({
      -- Lua pattern that matches the end of your prompt
      -- For bash/zsh users: '%$ '
      -- For fish users: '> '
      -- For powershell users: '> '
      prompt_end = '%$ ',
      
      -- Default register for yank/put operations
      -- default_reg = '"',
      
      -- Delay for feedkeys in milliseconds
      -- Increase if you experience issues
      -- feedkeys_delay = 10,
    })
  end,
}