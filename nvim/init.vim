" Plugins
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot' 
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'arcticicestudio/nord-vim'
Plug 'sainnhe/edge'
Plug 'OmniSharp/omnisharp-vim'
call plug#end()

" Plugin settings
nnoremap <C-n> :NERDTree<CR>
syntax on
colorscheme edge
let g:airline_powerline_fonts = 1
let g:airline_theme='edge'

" Transparent background
highlight Normal ctermbg=none guibg=none
highlight NonText ctermbg=none guibg=none
highlight EndOfBuffer ctermbg=none guibg=none

" Standard configuration
set shiftwidth=4
set expandtab
set termguicolors
set number
set relativenumber
set mouse=nvi
set ignorecase
set smartcase
