require 'plugins'
require 'utils'

vim.cmd([[colorscheme nord]])
vim.g.mapleader = " "

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

" nerdtree like 
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15
let g:netrw_banner = 0
augroup ProjectDrawer
  autocmd!
  autocmd VimEnter * :Vexplore
augroup END
]])


vim.cmd[[
au VimEnter * hi Normal guibg=none
au VimEnter * hi Normal ctermbg=none
au VimEnter * hi LineNr guibg=none
au VimEnter * hi LineNr ctermbg=none
au VimEnter * hi Folded guibg=none 
au VimEnter * hi Folded ctermbg=none
au VimEnter * hi NonText ctermbg=none
au VimEnter * hi NonText guibg=none 
au VimEnter * hi SpecialKey ctermbg=none
au VimEnter * hi SpecialKey guibg=none
au VimEnter * hi VertSplit ctermbg=none
au VimEnter * hi VertSplit guibg=none
au VimEnter * hi SignColumn ctermbg=none
au VimEnter * hi SignColumn guibg=none
au VimEnter * hi EndOfBuffer ctermbg=none
au VimEnter * hi EndOfBuffer guibg=none
]]

