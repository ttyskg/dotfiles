" ~/.vimrc -- Vim 9 setup for quick work in a terminal.
"
" Deliberately plugin-free. VS Code does the multi-file editing; Vim only has
" to make reading a file and making a small change comfortable, and to start
" instantly on a machine that was set up two minutes ago.

" Having a vimrc suppresses Vim's own defaults.vim, which is where most of the
" sane modern behaviour lives (incsearch, wildmenu, ttimeout, backspace,
" 'jump to last position', matchit). Pull it back in rather than restating it.
silent! source $VIMRUNTIME/defaults.vim

syntax enable
filetype plugin indent on

set encoding=utf-8
scriptencoding utf-8


"===========================================================================
" Files
"===========================================================================
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,euc-jp,cp932,latin1
set fileformats=unix,dos,mac
set autoread                      " reload when changed outside Vim
set hidden                        " allow switching away from a modified buffer
set confirm                       " ask about unsaved changes instead of failing

set nobackup
set nowritebackup
set noswapfile

" Persistent undo: 'noswapfile' plus no undofile means every close throws the
" history away. ~/.vim is a symlink into the dotfiles repository, so keep the
" undo files outside of it.
if has('persistent_undo')
  let s:undodir = expand('~/.cache/vim/undo')
  if !isdirectory(s:undodir)
    call mkdir(s:undodir, 'p', 0700)
  endif
  let &undodir = s:undodir
  set undofile
endif


"===========================================================================
" Appearance
"===========================================================================
" 'termguicolors' only when the terminal actually advertises 24-bit colour;
" otherwise fall back to 256 colours, which every bundled scheme supports.
" The t_8f/t_8b sequences are what makes it work through tmux and screen.
if has('termguicolors') && ($COLORTERM ==# 'truecolor' || $COLORTERM ==# '24bit')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Keep the terminal's own background instead of the colorscheme's, so terminal
" themes and transparency show through. This has to be an autocmd: plain
" :highlight lines after :colorscheme are wiped by the next :colorscheme.
augroup TransparentBackground
  autocmd!
  autocmd ColorScheme * highlight Normal      ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight NonText     ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight LineNr      ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight SignColumn  ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight Folded      ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight SpecialKey  ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight EndOfBuffer ctermbg=NONE guibg=NONE
augroup END

set background=dark
" Bundled with Vim 9. Alternatives worth trying: retrobox, sorbet, lunaperche,
" quiet, wildcharm. `:colorscheme <Tab>` lists them all.
silent! colorscheme habamax

set number
set title
set showmatch
set belloff=all
set scrolloff=3
set sidescrolloff=8
set splitbelow
set splitright
set wildmode=longest:full,full
set wildignorecase

" Indent guides and whitespace, replacing indentLine -- and without its
" 'conceal' side effect of hiding quotes in JSON and Markdown.
" leadmultispace needs Vim 9.0.824; fall back cleanly on older versions.
try
  let &listchars = 'tab:> ,leadmultispace:|   ,trail:·,nbsp:+,extends:>,precedes:<'
catch /E474/
  let &listchars = 'tab:> ,trail:·,nbsp:+,extends:>,precedes:<'
endtry
set list

" Highlight the cursor line in the window that has focus only.
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

" Status line, replacing lightline.vim.
"   left   path, flags        right   filetype, encoding, format, position
set laststatus=2
set statusline=%<%f\ %h%w%m%r
set statusline+=%=
set statusline+=%{&filetype!=#''?&filetype:'none'}
set statusline+=\ \|\ %{&fileencoding!=#''?&fileencoding:&encoding}
set statusline+=\ \|\ %{&fileformat}
set statusline+=\ \|\ %l:%c\ %P


"===========================================================================
" Editing
"===========================================================================
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set shiftround
set autoindent
" No 'smartindent': the filetype indent plugins loaded above do a better job,
" and smartindent is what shoves Python comments to column 1.

augroup FileTypeTweaks
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd FileType yaml,json,html,css,javascript,typescript,sh,vim
        \ setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType markdown,text setlocal wrap linebreak nolist
  autocmd FileType gitcommit setlocal spell textwidth=72
augroup END


"===========================================================================
" Searching
"===========================================================================
set ignorecase
set smartcase
set wrapscan
set hlsearch
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>


"===========================================================================
" Navigation
"===========================================================================
" netrw, replacing NERDTree. <C-n> keeps the old toggle key.
let g:netrw_banner = 0
let g:netrw_liststyle = 3         " tree view
let g:netrw_winsize = 25
nnoremap <silent> <C-n> :Lexplore<CR>

" :find and friends search the whole tree below the current directory.
set path+=**

" Move by screen line when a long line is wrapped.
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'


"===========================================================================
" Clipboard
"===========================================================================
" This Vim is built without +clipboard on WSL, so yanks cannot reach the
" Windows clipboard. Pipe through clip.exe instead:
"   \y  in visual mode  -> selected lines
"   \y  in normal mode  -> whole buffer
if executable('clip.exe')
  xnoremap <silent> <Leader>y :w !clip.exe<CR><CR>
  nnoremap <silent> <Leader>y :%w !clip.exe<CR><CR>
elseif executable('xclip')
  xnoremap <silent> <Leader>y :w !xclip -selection clipboard<CR><CR>
  nnoremap <silent> <Leader>y :%w !xclip -selection clipboard<CR><CR>
endif

" The mouse stays off on purpose: without +clipboard, dragging to select is
" only useful as *terminal* selection, which Vim's mouse handling would steal.
set mouse=
