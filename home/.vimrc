" Start Pathogen
execute pathogen#infect()

" Vim Solarized Colors options
syntax enable " Syntax highlighting
set background=dark
colorscheme solarized

filetype plugin indent on " Filetype detection
set number " Show line numbers
set title " Display title of file being edited

filetype indent off " Disable automatic indentation

" Automatically highlight lines longer than 79 cols for .hs
:au BufWinEnter *.hs let w:m1=matchadd('Search', '<\%80v.\%>76v', -1)
:au BufWinEnter *.hs let w:m1=matchadd('ErrorMsg', '\%>77v.\+', -1)

" Automatically highlight lines longer than 79 cols for .py
:au BufWinEnter *.py let w:m1=matchadd('Search', '<\%80v.\%>76v', -1)
:au BufWinEnter *.py let w:m1=matchadd('ErrorMsg', '\%>77v.\+', -1)

" Automatically highlight lines longer than 75 cols for .java
:au BufWinEnter *.java let w:m1=matchadd('Search', '<\%76v.\%>72v', -1)
:au BufWinEnter *.java let w:m1=matchadd('ErrorMsg', '\%>73v.\+', -1)

" Indentation
set tabstop=2 " tab=2 spaces
set softtabstop=2 " 2 spaces inserted when tab prssed
set shiftwidth=2 " Indents are 2 spaces
set expandtab " Use spaces instead of tabs

