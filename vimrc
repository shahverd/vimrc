" My vim/neovim configuration

set number
set nowrap
set hlsearch incsearch " Highlight the searched string, while typing.
set nobackup noswapfile
set tabstop=4 shiftwidth=4 softtabstop=4 expandtab
set noarabicshape "leave arabic shapes to terminal to IDE
set scrolloff=300 " To make cursor stays in the middle of the screen
set clipboard=unnamedplus " p to paste globally
set mouse=a
colorscheme delek


" Tip: 
"   To replace text in a visually selected area,
"   while text is selected press ":"
"   then s/gree/red/g
"   it will be like '<,>'s/green/red/g
"
" Config path:
"       ~/.config/nvim/init.vim 
" Quick command to link nvim & vim config files:
"       ln -s ~/.vimrc ~/.config/nvim/init.vim
