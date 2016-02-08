func! Snake()
    call snake#StartSnake()
endfunc

command! -nargs=0 Snake :call Snake()
