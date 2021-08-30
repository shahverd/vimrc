" My vim/neovim configuration

set number
set nowrap
set hlsearch incsearch " Highlight the searched string, while typing.
set nobackup noswapfile
set tabstop=4 shiftwidth=4 softtabstop=4 expandtab
set noarabicshape "leave arabic shapes to terminal to IDE
"set scrolloff=300 " To make cursor stays in the middle of the screen
set clipboard=unnamedplus " p to paste globally
set mouse=a
colorscheme desert


" Tip: 
"   To replace text in a visually selected area,
"   while text is selected press ":"
"   then s/gree/red/g
"   it will be like '<,>'s/green/red/g
"
" Config path:
"       /etc/xdg/nvim/init.vim
"       or locally with:
"       ~/.config/nvim/init.vim 
" Quick command to link nvim & vim config files:
"       ln -s ~/.vimrc /etc/xdg/nvim/init.vim

" UPDATEING ....
let b:path = 'https://raw.githubusercontent.com/shahverd/vimrc/main/init.vim'

function! UpdateConfig()
    let b:cmd = "curl " . b:path . " > " . $HOME . '/.config/init.vim'
    call system(b:cmd)
endfunction

command UC :call UpdateConfig()

