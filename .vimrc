"##### Plugins Setting #####
execute pathogen#infect()
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

"##### Dispray Setting #####
set number
set title
set showmatch
set tabstop=4
set smartindent
set visualbell t_vb=

"##### Search Setting #####
set ignorecase
set smartcase
set wrapscan
