vim.cmd([[
set number relativenumber
set textwidth=80
set cursorline
set iskeyword-=_ 
set hlsearch   
set splitright
set hidden   
set incsearch    
set noswapfile
set showmatch
set ignorecase
set smartcase
set gdefault
filetype plugin on

"completion 
"        for text: S-Tab launches pop-up words
"	for R and Rmd completion is automatic
"ultisnips, 
"	launch with C-j, move forward with C-j, move backward with C-k
"	open ultisnips file with <leader>u

set dictionary+=/usr/share/dict/words
let g:UltiSnipsSnippetDirectories=["UltiSnips", "my_snippets"]

let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsUsePythonVersion = 3
"nnoremap <leader>u :UltiSnipsEdit<cr>
set completeopt=longest,menuone

inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
let R_set_omnifunc = ["r",  "rmd", "quarto",  "rhelp"]
let R_auto_omni = ["r", "rmd", "rhelp"]
]])
vim.g.mapleader = ","
vim.g.maplocalleader = " "
local map = vim.keymap.set
local opts = {noremap = true}
map('n', ':', ';', opts)
map('n', ';', ':', opts)
map('n', '<Space><leader>','<C-u>', opts)
map('n', '<leader>u',':UltiSnipsEdit<cr>', opts)
map('n', '<Space><Space>','<C-d>', opts)
map('n', '-','$', opts)
map('n', '<leader>f','vipgq', opts)
map('n', '<leader>v','edit ~/.config/nvim/init.lua<cr>', opts)
map('n', '<leader>a','ggVG', opts)
map('n', '<leader>t',':tab split<cr>', opts)
map('n', '<leader>y',':vert sb2<cr>', opts)
map('n', '<leader>0',':ls!<CR>:b<Space>', opts)
map('n', '<leader><leader>','<C-w>w', opts)
map('n', '<leader>1','<C-w>:b1<cr>', opts)
map('n', '<leader>2','<C-w>:b2<cr>', opts)
map('n', '<leader>3','<C-w>:b3<cr>', opts)
map('t',  'ZZ', "q('no')<CR>", opts)
map('t',  'ZQ', "q('no')<CR>", opts)
map('v',  '-', '$', opts)
map('t',  '<leader>0','<C-\\><C-n><C-w>:ls!<cr>:b<Space>', opts)
map('t',  '<Escape>','<C-\\><C-n>', opts)
map('t',  '<leader><leader>','<C-\\><C-n><C-w>w', opts)
map('i',  '<Esc>', '<Esc>`^', opts)
map('i',  '<S-Tab>', '<C-x><C-k>', opts)

vim.cmd([[
"    copy clipboard to register x for safe keeping
nnoremap <leader>x :let @x=@*
"    paste registers into terminal
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
set background=light
colorscheme paramount
]])

