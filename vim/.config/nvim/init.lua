
vim.cmd([[colorscheme codedark]])
vim.g.mapleader = " "


require 'plugins'
require 'utils'


vim.cmd([[

" setup grep for vim to use rg
if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow\ --multiline-dotall
elseif executable('ag')
    set grepprg=ag\ --vimgrep\ --smart-case\ --hidden\ --follow
else
    set grepprg=grep\ --line-number\ --ignore-case\ -H\ --exclude=tags*
endif


" folding in vscode support
if exists('g:vscode')
nnoremap <silent> za <Cmd>call VSCodeNotify('editor.toggleFold')<CR>
nnoremap <silent> zR <Cmd>call VSCodeNotify('editor.unfoldAll')<CR>
nnoremap <silent> zM <Cmd>call VSCodeNotify('editor.foldAll')<CR>
nnoremap <silent> zo <Cmd>call VSCodeNotify('editor.unfold')<CR>
nnoremap <silent> zO <Cmd>call VSCodeNotify('editor.unfoldRecursively')<CR>
nnoremap <silent> zc <Cmd>call VSCodeNotify('editor.fold')<CR>
nnoremap <silent> zC <Cmd>call VSCodeNotify('editor.foldRecursively')<CR>
nmap j gj
nmap k gk
endif

]])


