
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})


require('telescope').setup{
  pickers = {
	  find_files = { hidden = true },
        live_grep = {
            additional_args = function(opts)
                return {"--hidden"}
            end
        },
}}
--require('telescope').load_extension('fzf')
--require('telescope').load_extension('luasnip')
