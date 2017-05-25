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


""""""""""""""""""""""""""""""
" Syntax highlighting
""""""""""""""""""""""""""""""
Plug 'digitaltoad/vim-pug'


""""""""""""""""""""""""""""""
" Webdev
""""""""""""""""""""""""""""""
Plug 'alvan/vim-closetag'
let g:closetag_filenames = "*.html,*.xhtml,*.phtml"
" JS syntax, supports ES6
Plug 'othree/yajs.vim', {'for': ['javascript']}
" Better indentation
Plug 'gavocanov/vim-js-indent', {'for': ['javascript']}
" JS syntax for common libraries
Plug 'othree/javascript-libraries-syntax.vim', {'for': ['javascript']}
" Tern auto-completion engine for JS (requires node/npm)
if executable('node')
  Plug 'marijnh/tern_for_vim', {'do': 'npm install', 'for': ['javascript', 'coffee']}
endif


""""""""""""""""""""""""""""""
" Wiki
""""""""""""""""""""""""""""""
Plug 'vimwiki/vimwiki'
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]


call plug#end()


""""""""""""""""""""""""""""""
" Apply theme
""""""""""""""""""""""""""""""
"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
"if (empty($TMUX))
"  if (has("nvim"))
"  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
"  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"  endif
"  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
"  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
"  if (has("termguicolors"))
"    set termguicolors
"  endif
"endif

" tmux color
set t_8b=^[[48;2;%lu;%lu;%lum
set t_8f=^[[38;2;%lu;%lu;%lum
