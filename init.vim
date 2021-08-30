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
    if has('nvim')

        let b:scriptPath = $HOME . '/.config/nvim/'
        call system('mkdir -p '. b:scriptPath)

        let b:cmd = "curl " . b:path . " > " . b:scriptPath . 'init.vim'
        call system(b:cmd)
    else
        let b:scriptPath = $HOME . '/.vim/'
        call system('mkdir -p '. b:scriptPath)

        let b:cmd = "curl " . b:path . " > " . b:scriptPath . 'vimrc'
        call system(b:cmd)

    endif
endfunction

command UC :call UpdateConfig()
