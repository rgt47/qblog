local cmp = require'cmp'
local cmp_ultisnips_mappings = require'cmp_nvim_ultisnips.mappings'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) 
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
    end
    end, { 'i', 's' }),
    ['<S-tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      cmp_ultisnips_mappings.jump_backwards(fallback)
    end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
{ name = 'cmp_nvim_r' },
    { name = 'ultisnips' },
    { name = 'path' },
{ name = "dictionary", keyword_length = 2, },
  }, {
    { name = 'buffer', keyword_length = 5},
  }),
})

require("cmp_dictionary").setup({
	dic = {
		["*"] = { "/usr/share/dict/words" },
	},
})
