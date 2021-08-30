" Installation: You can overrode your own configs by
"     :source https://raw.githubusercontent.com/shahverd/vimrc/main/init.vim | UpdateConfigs
"
"   And then each time to update the configs run
"     :UpdateConfigs

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set number
set nowrap
set hlsearch incsearch " Highlight the searched string, while typing.
set nobackup noswapfile
set tabstop=4 shiftwidth=4 softtabstop=4 expandtab
set noarabicshape "leave arabic shapes to terminal to IDE
"set scrolloff=300 " To make cursor stays in the middle of the screen
set clipboard=unnamedplus " p to paste globally
set mouse=a
set hidden " to be able to change buffers without saving them
colorscheme blue

"""""""""""""""""""""""""""UPDATEING SECTION"""""""""""""""""""""""""""""""

let b:path = 'https://raw.githubusercontent.com/shahverd/vimrc/main/init.vim'  

function! UpdateConfigs()
    if has('nvim')

        " Path for nvim's config script
        let b:scriptPath = $HOME . '/.config/nvim/'
        call system('mkdir -p '. b:scriptPath)

        let b:cmd = "curl " . b:path . " > " . b:scriptPath . 'init.vim'
        call system(b:cmd)

        "exec "source " . b:scriptPath . 'init.vim'

    else
        " Path for vim's config script
        let b:scriptPath = $HOME . '/.vim/'
        call system('mkdir -p '. b:scriptPath)

        let b:cmd = "curl " . b:path . " > " . b:scriptPath . 'vimrc'
        call system(b:cmd)

        "exec "source " . b:scriptPath . 'vimrc'
    endif
    
    
endfunction

command! UpdateConfigs :call UpdateConfigs()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Tips: 
"
"    Config path:
"       /etc/xdg/nvim/init.vim
"       or locally with:
"       ~/.config/nvim/init.vim 
"    Quick command to link nvim & vim config files:
"       ln -s ~/.vimrc /etc/xdg/nvim/init.vim
