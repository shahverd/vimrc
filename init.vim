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

set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar
set guifont=Monaco:h14

colorscheme darkblue

"For some systems these are disabled by default:
syntax on
filetype on

"""""""""""""""""""""""""""UPDATEING SECTION"""""""""""""""""""""""""""""""

let g:path = 'https://raw.githubusercontent.com/shahverd/vimrc/main/init.vim'  

function! UpdateConfigs()

    if has('win32')

        if has('nvim')
            let b:scriptPath =  $HOME . '\AppData\Local\nvim\'   
            let b:fileName = 'init.vim'
        else
            let b:scriptPath = $HOME . '\vimfiles\'
            let b:fileName = 'vimrc'
        endif

    else
        if has('nvim')
            let b:scriptPath = $HOME . '/.config/nvim/'    
            let b:fileName = 'init.vim'
        else
            let b:scriptPath = $HOME . '/.vim/'
            let b:fileName = 'vimrc'
        endif
    endif
    echo 'mkdir -p '. b:scriptPath
    call system('mkdir -p '. b:scriptPath)
    let b:cmd = "curl " . g:path . " > " . b:scriptPath . b:fileName
    call system(b:cmd)
    
    echo "Done updating. Restart the editor for changes to take effect."
endfunction

command! UpdateConfigs :call UpdateConfigs()
