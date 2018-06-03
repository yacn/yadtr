set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'altercation/vim-colors-solarized'
Plugin 'hashivim/vim-terraform'
Plugin 'martinda/Jenkinsfile-vim-syntax'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Vim Solarized Colors options
syntax enable " Syntax highlighting
set background=dark
"set background=light
colorscheme solarized

"filetype plugin indent on " Filetype detection
set number " Show line numbers
set title " Display title of file being edited

filetype indent off " Disable automatic indentation

" Automatically highlight lines longer than 79 cols for .py
:au BufWinEnter *.py let w:m1=matchadd('Search', '<\%80v.\%>76v', -1)
:au BufWinEnter *.py let w:m1=matchadd('ErrorMsg', '\%>77v.\+', -1)

" Indentation
set tabstop=2 " tab=2 spaces
set softtabstop=2 " 2 spaces inserted when tab prssed
set shiftwidth=2 " Indents are 2 spaces
set expandtab " Use spaces instead of tabs
set mouse=a " Mouse wheel scrolling
set ruler " Show column
