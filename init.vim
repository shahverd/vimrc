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
colorscheme darkblue

"For some systems these are disabled by default:
syntax on
filetype on

"""""""""""""""""""""""""""UPDATEING SECTION"""""""""""""""""""""""""""""""

let g:path = 'https://raw.githubusercontent.com/shahverd/vimrc/main/init.vim'  

function! UpdateConfigs()
    let b:scriptPath = ''
    let b:fileName = ''

    if has('win32')

        if has('nvim')
            b:scriptPath = '%userprofile%\AppData\Local\nvim\'   
            b:fileName = 'init.vim'
        else
            b:scriptPath = $HOME . '/vimfiles/'
            b:fileName = 'vimrc'
        endif

    else
        if has('nvim')
            b:scriptPath = $HOME . '/.config/nvim/'    
            b:fileName = 'init.vim'
        else
            b:scriptPath = $HOME . '/.vim/'
            b:fileName = 'vimrc'
        endif
    endif

    call system('mkdir -p '. b:scriptPath)
    let b:cmd = "curl " . g:path . " > " . b:scriptPath . 'init.vim'
    call system(b:cmd)
    
    echo "Done updating. Restart the editor for changes to take effect."
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
