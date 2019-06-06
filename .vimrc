"##### Plugins Setting #####
syntax enable
filetype plugin indent on
set background=dark
colorscheme solarized

"# Setting for indentLine
let g:indentLine_char = '|'
let g:indentLine_faster = 1

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
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=usc-boms,utf-8,euc-jp,cp932
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
let &colorcolumn=join(range(80,80),",")
"Background transparency settings
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight Folded ctermbg=NONE guibg=NONE
highlight SpeciaKey ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

"##### Search Setting #####
set ignorecase
set smartcase
set wrapscan
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>
