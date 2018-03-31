""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't forget you need to pip install yapf neovim pylint
""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable plugged
call plug#begin('~/.local/share/nvim/plugged')

"""""""""""""""""""""""""""""""
" My settings
"""""""""""""""""""""""""""""""
let mapleader = "\<Space>"      "space as leader

set history=1000                    " Store :cmdline history.
set showcmd                         " Show incomplete commands at the bottom
set showmode                        " Show current mode at the bottom
set ruler                           " Always show the current position
set backspace=indent,eol,start      " Allow backspace to delete everything
set autoread                        " Auto reload file when it's changed in the background
set showmatch                       " Show matching brackets and parentheses
syntax enable                       " Syntax highlighting
set encoding=utf-8                  " Force UTF-8 as standard encoding
set ffs=unix,dos,mac                " Unix as the standard file type
set laststatus=2                    " Always show the statusline
set number                          " Show line numbers
set guioptions-=r                   " Remove scrollbar for GUI Vim.
set number                          " Absoulte line number for current line

" No swap files
set noswapfile
set nobackup
set nowb

" Indentation
set autoindent        " Automatically indent
set smarttab
" Set softtabs with 2 spaces
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab
filetype plugin indent on

" Line breaks
" Don't wrap lines physically (auto insertion of newlines)
set nowrap       "Don't wrap lines
set textwidth=0 wrapmargin=0
set nolist  " list disables linebreak
set sidescroll=5
set listchars+=precedes:<,extends:>

" Ignore file completion
set wildmode=list:longest
set wildmenu                      " Enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~       " Stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.so,*.swp,*.zip

" Search
set ignorecase
set smartcase
set incsearch       " Incremental search as you type
set hlsearch        " Highlight search results

" Scrolling
set scrolloff=20         "Start scrolling when we're 20 lines away from margins
set sidescrolloff=15
set sidescroll=1

" Jump to end of pasted text
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Reload changes
set autoread

" Wrap lines
set wrap
" Navigate line wraps
onoremap <silent> j gj
onoremap <silent> k gk

" Ctrl to change panes
nnoremap <leader>wj <C-W><C-J>
nnoremap <leader>wk <C-W><C-K>
nnoremap <leader>wl <C-W><C-L>
nnoremap <leader>wh <C-W><C-H>

" Split right and bottom
set splitbelow
set splitright

" Tab nagivation
nnoremap <leader>tn = gt
nnoremap <leader>tp = gT

" background
set background=dark


"""""""""""""""""""""""""""""""
" Fuzzy search
"""""""""""""""""""""""""""""""
" Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
" nnoremap <leader>/ :Denite file_rec buffer <Enter>
Plug 'ctrlpvim/ctrlp.vim'


"""""""""""""""""""""""""""""""
" Autocomplete
"""""""""""""""""""""""""""""""
Plug 'Valloric/YouCompleteMe'
nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>


""""""""""""""""""""""""""""""
" Linter
""""""""""""""""""""""""""""""
Plug 'w0rp/ale'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_python_flake8_options = '--ignore=E501,E121,E123,E126,E226,E24,E704,D,I,N'

 
""""""""""""""""""""""""""""""
" Indent
""""""""""""""""""""""""""""""
Plug 'Vimjas/vim-python-pep8-indent'


""""""""""""""""""""""""""""""
" Comment
""""""""""""""""""""""""""""""
Plug 'scrooloose/nerdcommenter'
" <leader> c s -> comment
" <leader> c u -> undo comment


""""""""""""""""""""""""""""""
" Undo
""""""""""""""""""""""""""""""
Plug 'sjl/gundo.vim'
nnoremap <leader>u :GundoToggle<CR>


""""""""""""""""""""""""""""""
" File navigation
""""""""""""""""""""""""""""""
Plug 'scrooloose/nerdtree'
map <leader>f :NERDTreeToggle<CR>

" open automatically if vim opens with directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" close vim if only window left is file browser
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


"""""""""""""""""""""""""""""""
" Python format
"""""""""""""""""""""""""""""""
autocmd FileType python nnoremap <leader>y :0,$!yapf<Cr>


"""""""""""""""""""""""""""""""
" Git
"""""""""""""""""""""""""""""""
Plug 'tpope/vim-fugitive'
" use the :Git command

Plug 'airblade/vim-gitgutter'
" Don't set up keys
let g:gitgutter_map_keys = 0


"""""""""""""""""""""""""""""""
" Start screen
"""""""""""""""""""""""""""""""
Plug 'mhinz/vim-startify'
let g:startify_bookmarks = []


"""""""""""""""""""""""""""""""
" Easy motion
"""""""""""""""""""""""""""""""
Plug 'justinmk/vim-sneak'
" s{char}{char} to search forward, S{char}{char} to search backward


""""""""""""""""""""""""""""""
" Executing code
""""""""""""""""""""""""""""""
Plug 'tpope/vim-dispatch'
autocmd FileType java let b:dispatch = 'javac %'
autocmd FileType python let b:dispatch = 'python %'
autocmd FileType sh let b:dispatch = 'bash %'
nnoremap <leader>r :Dispatch<CR>


"""""""""""""""""""""""""""""""
" Airline
"""""""""""""""""""""""""""""""
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" display open buffers
let g:airline#extensions#tabline#enabled = 1

""""""""""""""""""""""""""""""
" Theme
""""""""""""""""""""""""""""""
Plug 'vim-airline/vim-airline-themes'

call plug#end()
" 
" 
" """"""""""""""""""""""""""""""
" " Apply theme
" """"""""""""""""""""""""""""""
" let g:airline_theme='onedark'
" 
" tmux color
set t_8b=^[[48;2;%lu;%lu;%lum
set t_8f=^[[38;2;%lu;%lu;%lum
