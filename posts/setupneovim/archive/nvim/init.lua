-- bootstrap process
-- install paq
--git clone --depth=1 https://github.com/savq/paq-nvim.git \
--    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
--    :PaqInstall
--
require "paq" {
"savq/paq-nvim";                  -- Let Paq manage itself
{ "junegunn/fzf", run = "./install --all" }; 
"NLKNguyen/papercolor-theme";
"honza/vim-snippets";
"ggandor/leap.nvim";
"jalvesaq/Nvim-R";
"lervag/vimtex";
}
require('basics')
require('nvim-R-config')

