-- nvim-ufo - Better folding for Neovim

return {
  "nvim-ufo",
  
  -- Only load if ui category is enabled
  enabled = function()
    return nixCats.cats.ui
  end,
  
  event = { "BufReadPost", "BufNewFile" },
  
  -- Dependencies
  dep_of = { "promise-async" },
  
  after = function()
    -- Set up folding options
    vim.o.foldcolumn = '1' -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    
    -- Set up nvim-ufo
    require('ufo').setup({
      provider_selector = function(bufnr, filetype, buftype)
        -- Use treesitter as the main provider
        -- Only use indent for specific filetypes or when treesitter is not available
        return {'treesitter', 'indent'}
      end,
      
      -- Preview configuration
      preview = {
        win_config = {
          border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'},
          winhighlight = 'Normal:Folded',
          winblend = 0
        },
        mappings = {
          scrollU = '<C-u>',
          scrollD = '<C-d>',
          jumpTop = '[',
          jumpBot = ']'
        }
      },
      
      -- Fold options
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        
        table.insert(newVirtText, {suffix, 'MoreMsg'})
        return newVirtText
      end,
    })
    
    -- Key mappings for folding
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = "Open all folds" })
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = "Close all folds" })
    vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = "Open folds except kinds" })
    vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = "Close folds with" })
    vim.keymap.set('n', 'K', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        -- If no fold under cursor, use default K behavior (LSP hover)
        vim.lsp.buf.hover()
      end
    end, { desc = "Peek fold or show hover" })
  end,
}