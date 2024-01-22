-- bootstrap process
-- install paq
--git clone --depth=1 https://github.com/savq/paq-nvim.git \
--    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
--    :PaqInstall
--
require "paq" {
"savq/paq-nvim";                  -- Let Paq manage itself
"junegunn/fzf";
'voldikss/vim-floaterm';
"kylechui/nvim-surround";
'preservim/nerdcommenter';
"NLKNguyen/papercolor-theme";
"SirVer/ultisnips"; 
"honza/vim-snippets";
"ggandor/leap.nvim";
"jalvesaq/Nvim-R";
'davidhalter/jedi-vim';
"lervag/vimtex";
"owickstrom/vim-colors-paramount"
}
require('basics')
require('nvim-R-config')
require('leap-config')
require('ultisnips-config')
require('vimtex-config')
require('leap').add_default_mappings()
vim.keymap.del({'x', 'o'}, 'x')
vim.keymap.del({'x', 'o'}, 'X')
