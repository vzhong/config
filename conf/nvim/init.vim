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
set smartindent
set smarttab
" Set softtabs with 2 spaces
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab

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
nnoremap <leader>n = gt
nnoremap <leader>p = gT


"""""""""""""""""""""""""""""""
" autocomplete
"""""""""""""""""""""""""""""""
Plug 'roxma/nvim-completion-manager'
" pip install neovim jedi mistune psutil setproctitle
" don't give |ins-completion-menu| messages.  For example,
" '-- XXX completion (YYY)', 'match 1 of 2', 'The only match',
set shortmess+=c
" fix enter
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
" tab select
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


""""""""""""""""""""""""""""""
" Jedi
""""""""""""""""""""""""""""""
Plug 'davidhalter/jedi-vim'
let g:jedi#completions_enabled = 0
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"


""""""""""""""""""""""""""""""
" NerdTree
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
" Airline
"""""""""""""""""""""""""""""""
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" display open buffers
let g:airline#extensions#tabline#enabled = 1


"""""""""""""""""""""""""""""""
" Git 
"""""""""""""""""""""""""""""""
Plug 'airblade/vim-gitgutter'
" Don't set up keys
let g:gitgutter_map_keys = 0


call plug#end()
