execute pathogen#infect()
execute pathogen#helptags()
syntax on
filetype plugin indent on

set backspace=2
set expandtab
set hlsearch
set nu
set shiftwidth=2
set tabstop=2

au BufNewFile,BufRead *.localbashrc setlocal ft=sh
au BufNewFile,BufRead *.localzshrc setlocal ft=zsh
au BufNewFile,BufRead *Jenkinsfile* setlocal ft=groovy

let vimfiles_dir = $HOME . "/.vim/"

if has('win32') || has('win64')
  let vimfiles_dir = $HOME . '\vimfiles\'
endif

let &undodir = vimfiles_dir . '.undo'
let &backupdir = vimfiles_dir . '.backup'
let &directory = vimfiles_dir . '.swap'
let &dir = &directory

if has('gui_running')
  set guifont=Monaco:h16
  colorscheme base16-monokai

  set guicursor=n-v-c-i:block-Cursor
  set guicursor+=n-v-c-i:blinkon0
else
  colorscheme default
endif

" change <Leader>
let mapleader = ","

" disable highlight for searches
nmap <Leader>h :noh<CR>

" grep
nmap <Leader>g :lv
nmap <Leader>n :lne<CR>
nmap <Leader>p :lp<CR>

" quit window
nmap <Leader>q :quit<CR>
nmap <Leader>x :quit!<CR>
nmap <Leader>w :write<CR>

" movement between panes, C-J|K|H|L
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l

" insert actual tab char when needed
inoremap <S-Tab> <C-V><Tab>

" NERDTree
map <C-N> :NERDTreeToggle<CR>
map <Leader><C-F> :NERDTreeFind<CR>
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.DS_Store$[[file]]']

" Mouse
set mouse=a
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end

" vim-flake8
let g:flake8_show_in_gutter=1
let g:flake8_show_in_file=1
" disabled - can be annoying if you're just browsing Python files
" autocmd BufWritePost *.py call flake8#Flake8()

" vim-slime
let g:slime_target = "tmux"
let g:slime_paste_file = tempname()
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}

" run a command, put output in new buffer
function! CommandIntoBuffer()
  call inputsave()
  let cmd = input('enter command: ')
  call inputrestore()

  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap

  execute "0read ! " . cmd

  setlocal nomodifiable
  1
endfunction
map <Leader>c :call CommandIntoBuffer()<CR>

" spell check for the current buffer
function! SpellCheck()
  setlocal spell spelllang=en_us
endfunction

" select specific lines
command! -range Vis normal! <line1>GV<line2>G

" vim-go
nmap <Leader>b :GoBuild<CR>
let g:go_highlight_extra_types = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1

" vim-fzf
set rtp+=~/.fzf

map <Leader>f :Files <CR>

" for reading particularly nasty JSON files
set maxmempattern=2000000
