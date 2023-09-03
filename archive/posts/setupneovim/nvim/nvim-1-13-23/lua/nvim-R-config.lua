vim.cmd([[
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
"autocmd FileType rmd,r nnoremap <buffer> <CR>  :call SendLineToR("down")<CR>
"autocmd FileType rmd,r vmap <buffer> <s-CR> :call SendSelectionToR("silent","down")<cr>
autocmd FileType rmd,r nnoremap <buffer> <space>' :call RMakeRmd("default")<cr>
"autocmd FileType rmd,r noremap <space>s :call RAction("str")<cr>
autocmd FileType rmd,r noremap <space>i :call RAction("dim")<cr>
autocmd FileType rmd,r noremap <space>h :call RAction("head")<cr>
autocmd FileType rmd,r noremap <space>p :call RAction("print")<cr>
autocmd FileType rmd,r noremap <space>q :call RAction("length")<cr>
autocmd FileType rmd,r noremap <space>n :call RAction("nvim.names")<cr>
"autocmd FileType rmd,r noremap <space>c :call RAction("cnt")<cr>
"autocmd FileType rmd,r noremap <space>k :call PreviousRChunk()<cr>
autocmd FileType rmd,r vmap <buffer> <CR> <localleader>sd
autocmd FileType rmd,r nmap <buffer> <space>j <localleader>gn
autocmd FileType rmd,r nmap <buffer> <space>k <localleader>gN
autocmd FileType rmd,r nmap <buffer> <space>l <localleader>cd
autocmd FileType rmd,r nmap <buffer> <space>Z A<space>%>%
autocmd FileType rmd,r nmap <buffer> <space>z i<space>%>%
autocmd FileType rmd,r nmap <buffer> <space>x i<space>%in%
augroup END
]])

