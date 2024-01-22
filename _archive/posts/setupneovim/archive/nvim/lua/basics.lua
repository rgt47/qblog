local map = vim.keymap.set
local opts = {noremap = true}
map('n', ':', ';', opts)
map('n', ';', ':', opts)
map('n', '<S-Space>','<C-u>', opts)
map('n', '<space><space>','<C-d>', opts)
map('n', '-','$', opts)
map('n', '<Space>f','vipgq', opts)
map('n', '<space>v','edit ~/.config/nvim/init.lua<cr>', opts)
map('n', '<space>a','ggVG', opts)
map('n', '<space>t','tab split<cr>', opts)
map('n', '<space>y','vert sb2<cr>', opts)
map('n', '<space>0',':ls!<CR>:b<Space>', opts)
map('n', '<comma><comma>','<C-w>w', opts)
map('n', '<space>1','<C-w>:b1<cr>', opts)
map('n', '<space>2','<C-w>:b2<cr>', opts)
map('n', '<space>3','<C-w>:b3<cr>', opts)
map('t',  'ZZ', "q('no')<CR>", opts)
map('t',  'ZQ', "q('no')<CR>", opts)
map('v',  '-', '$', opts)
map('t',  '<space>0','<C-\\><C-n><C-w>:ls!<cr>:b<Space>', opts)
map('t',  '<Escape>','<C-\\><C-n>', opts)
map('t',  '<comma><comma>','<C-\\><C-n><C-w>w', opts)
map('i',  '<Esc>', '<Esc>`^', opts)

vim.cmd([[
"copy clipboard to register x for safe keeping
nnoremap <space>S :let @x=@*
"paste registers into terminal
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
set clipboard=unnamed
set background=light
colorscheme PaperColor
let R_set_omnifunc = ["r",  "rmd", "quarto", "rnoweb", "rhelp", "rrst"]
let R_auto_omni = ["r", "rnoweb", "rhelp"]
]])

vim.g.mapleader = ","
vim.g.maplocalleader = " "
