vim.cmd([[
set completeopt=menu,menuone,noselect,noinsert
set number relativenumber
set textwidth=80
set cursorline
set clipboard=unnamed
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
set encoding=utf-8
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes
set colorcolumn=80
"highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

set dictionary+=/usr/share/dict/words
set thesaurus+=/Users/zenn/mthesaur.txt

let g:UltiSnipsSnippetDirectories=["UltiSnips", "my_snippets"]


let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsUsePythonVersion = 3
"nnoremap <leader>u :UltiSnipsEdit<cr>

"let R_set_omnifunc = ["r",  "rmd", "quarto",  "rhelp"]
"let R_auto_omni = ["r", "rmd", "rhelp"]
]])
vim.g.mapleader = ","
vim.g.maplocalleader = " "
local map = vim.keymap.set
local opts = {noremap = true}

vim.cmd([[
autocmd FileType julia,python nnoremap <buffer> <s-CR>  :call VimCmdLineStartApp()<CR>
autocmd FileType julia,python nnoremap <buffer> <CR>  :call VimCmdLineSendLine()<CR>
]])

map('n', ':', ';', opts)
map('n', ';', ':', opts)
map('n', '<Space><leader>','<C-u>', opts)
map('n', '<leader>u',':UltiSnipsEdit<cr>', opts)
map('n', '<Space><Space>','<C-d>', opts)
map('n', '-','$', opts)
map('n', '<leader>w','vipgq', opts)
map('n', '<leader>v',':edit ~/.config/nvim/init.lua<cr>', opts)
map('n', '<leader>n',':edit ~/.config/nvim/lua/basics.lua<cr>', opts)
map('n', '<leader>a','ggVG', opts)
map('n', '<leader>t',':tab split<cr>', opts)
map('n', '<leader>y',':vert sb2<cr>', opts)
map('n', '<leader>0',':ls!<CR>:b<Space>', opts)
map('n', '<leader><leader>','<C-w>w', opts)
map('n', '<leader>1','<C-w>:b1<cr>', opts)
map('n', '<leader>2','<C-w>:b2<cr>', opts)
map('n', '<leader>3','<C-w>:b3<cr>', opts)
map('t',  'ZZ', "q('yes')<CR>", opts)
map('t',  'ZQ', "q('no')<CR>", opts)
map('v',  '-', '$', opts)
map('t',  '<leader>0','<C-\\><C-n><C-w>:ls!<cr>:b<Space>', opts)
map('t',  '<Escape>','<C-\\><C-n>', opts)
map('t',  '<leader><leader>','<C-\\><C-n><C-w>w', opts)
map('i',  '<Esc>', '<Esc>`^', opts)

vim.cmd([[
"    copy clipboard to register x for safe keeping
nnoremap <leader>x :let @x=@*
"    paste registers into terminal
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
"set background=dark
set background=light
"colorscheme onebuddy 
colorscheme paramount
"highlight Search ctermfg=cyan guifg=cyan
"highlight Search ctermbg=black guibg=blue
"highlight IncSearch ctermbg=red guibg=red guifg=black ctermfg=black
"highlight CursorLine ctermbg=lightcyan guibg=lightcyan
]])

vim.api.nvim_create_autocmd(
    { "BufRead", "BufNewFile" },
    { pattern = { "*.txt", "*.md", "*.tex" }, command = "setlocal spell" }
)
