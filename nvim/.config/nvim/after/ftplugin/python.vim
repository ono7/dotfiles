" indent file is in ~/.dotfiles/nvim/indent/python.vim
setlocal expandtab nolisp smartindent
setlocal indentkeys=!^F,o,O,<:>,0),0],0},=elif,=except

" setlocal makeprg=pylint\ -sn\ -f\ text\ %

setlocal suffixesadd+=.py
setlocal makeprg=ruff\ check\ --output-format=concise\ %
setlocal errorformat=%f:%l:%c:\ %m
