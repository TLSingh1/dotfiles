-- friendly-snippets - Collection of snippets for various languages

return {
  "friendly-snippets",
  
  -- Only load if coding category is enabled
  enabled = function()
    return nixCats.cats.coding
  end,
  
  -- Load before blink.cmp
  dep_of = "blink.cmp",
}