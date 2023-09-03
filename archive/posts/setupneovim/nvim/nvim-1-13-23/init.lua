-- need to grap the directory control for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- bootstrap process
-- install paq
--git clone --dept:=1 https://github.com/savq/paq-nvim.git \
--    ~/.local/sha:e}"/nvim/site/pack/paqs/start/paq-nvim
--    :PaqInstall
--
require "paq" {
-- need a plugin manager
"savq/paq-nvim";
-- need plugins to manage R, Python and Julia code
"jalvesaq/Nvim-R";
"lervag/vimtex";
"jalvesaq/vimcmdline"; 
"jalvesaq/cmp-nvim-r";
-- essential workflow facility plugins
--"junegunn/fzf";
'junegunn/vim-peekaboo';
'junegunn/goyo.vim';
'junegunn/limelight.vim';
'junegunn/vim-easy-align';
'machakann/vim-highlightedyank'; 
"kylechui/nvim-surround";
'voldikss/vim-floaterm';
'preservim/nerdcommenter';
"SirVer/ultisnips"; 
"honza/vim-snippets";
'rhysd/clever-f.vim';
"ggandor/leap.nvim";
'davidhalter/jedi-vim';
'mhinz/vim-startify';
"owickstrom/vim-colors-paramount";
--
-- new neovim features
'nvim-lua/plenary.nvim';
'nvim-lualine/lualine.nvim';
'nvim-treesitter/nvim-treesitter';
'nvim-telescope/telescope.nvim';
'nvim-tree/nvim-tree.lua';
'hrsh7th/nvim-cmp';
'neovim/nvim-lspconfig';
'hrsh7th/cmp-nvim-lsp';
'hrsh7th/cmp-buffer';
'hrsh7th/cmp-path';
'hrsh7th/cmp-cmdline';
'uga-rosa/cmp-dictionary';
'quangnguyen30192/cmp-nvim-ultisnips';
'tjdevries/colorbuddy.vim';
'Th3Whit3Wolf/onebuddy';
'nvim-tree/nvim-web-devicons'; 
}
require('basics')
require('nvim-cmp-config')
require('nvim-tree-config')
require('nvim-telescope-config')
require('leap').add_default_mappings()

local builtin = require('telescope.builtin')

--require('telescope').setup{
  --pickers = {
	  --find_files = { hidden = true },
        --live_grep = {
            --additional_args = function(opts)
                --return {"--hidden"}
            --end
        --},
--}}
require('nvim-R-config')
require("nvim-surround").setup()
require('lualine').setup()
--require'lspconfig'.r_language_server.setup{}
-- install R treesitter code
-- vim-command-line :TSInstall r
-- install R language server code. 
-- R command line> install.packages("languageserver")
vim.keymap.del({'x', 'o'}, 'x')
vim.keymap.del({'x', 'o'}, 'X')






--from mint 27nov22



