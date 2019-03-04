"##### Plugins Setting #####
syntax enable
filetype plugin indent on
set background=dark
colorscheme solarized

"# Setting for vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=0

"# Setting for NERDTree
map <C-n> :NERDTreeToggle<CR>

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
set fenc=utf-8
set nobackup
set noswapfile
set autoread
set showcmd

"##### Dispray Setting #####
set number
set cursorline
"set cursorcolumn
set title
set showmatch
set tabstop=4
set smartindent
set visualbell t_vb=
set expandtab
set nrformats=
let &colorcolumn=join(range(80,100),",")


"##### Search Setting #####
set ignorecase
set smartcase
set wrapscan
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>
