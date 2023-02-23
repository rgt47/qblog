vim.cmd([[
set completeopt=longest,menuone
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
let R_set_omnifunc = ["r",  "rmd", "quarto", "rnoweb", "rhelp", "rrst"]
let R_auto_omni = ["r", "rmd", "rhelp"]
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'
let R_auto_start = 2
let R_hl_term = 0
let R_clear_line = 1
let R_pdfviewer = "zathura" 
let R_assign = 2
let R_latexcmd = ['xelatex']
augroup rmarkdown
autocmd!
autocmd FileType rmd,r nnoremap <buffer> <CR>  :call SendLineToR("down")<CR>
autocmd FileType rmd,r nnoremap <buffer> <space>l :call SendChunkToR("silent","down")<cr>
autocmd FileType rmd,r nnoremap <buffer> <space>' :call RMakeRmd("default")<cr>
autocmd FileType rmd,r noremap <space>s :call RAction("str")<cr>
autocmd FileType rmd,r noremap <space>i :call RAction("dim")<cr>
autocmd FileType rmd,r noremap <space>h :call RAction("head")<cr>
autocmd FileType rmd,r noremap <space>p :call RAction("print")<cr>
autocmd FileType rmd,r noremap <space>q :call RAction("length")<cr>
autocmd FileType rmd,r noremap <space>n :call RAction("nvim.names")<cr>
autocmd FileType rmd,r noremap <space>c :call RAction("cnt")<cr>
autocmd FileType rmd,r noremap <space>k :call PreviousRChunk()<cr>
autocmd FileType rmd,r noremap <space>j :call NextRChunk()<cr>
augroup END
]])

