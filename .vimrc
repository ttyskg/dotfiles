"##### Plugins Setting #####
syntax enable
filetype plugin indent on
set background=dark
colorscheme solarized

"# Setting for indentLine
let g:indentLine_char = '|'
let g:indentLine_faster = 1
let g:indentLine_color_term = 10

"# Setting for NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>

"# Setting for lightline.vim
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'solarized'
      \ }

"# Setting for UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="tabdo"

"##### File Setting #####
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,euc-jp,cp932
set nobackup
set noswapfile
set autoread
set showcmd

"##### Display Setting #####
set number
"set cursorline
"set cursorcolumn
set title
set showmatch
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set visualbell t_vb=
set expandtab
"let &colorcolumn=join(range(80,80),",")
"Background transparency settings
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight Folded ctermbg=NONE guibg=NONE
highlight SpecialKey ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

"##### Search Setting #####
set ignorecase
set smartcase
set wrapscan
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>
