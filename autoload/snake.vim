func! snake#StartSnake()
	" Save the current buffer and open a new one
	if filereadable(bufname('%'))
		exec "w"
	endif
	exec "enew"

	syn match snake "\*"
	syn match food "o"
	syn match wall "[|-]"
	hi link snake Identifier
	hi link food Error
	hi link wall Comment

	" Turn off the cursorline
	setlocal nocursorline

	" Load the rows, cols, and update time
	if !exists("g:snake_rows")
		" Default is 20 rows
		let g:snake_rows = 20
	endif

	if !exists("g:snake_cols")
		" Default is 50 cols
		let g:snake_cols = 50
	endif

	if !exists("g:snake_update")
		" Default is update time of 125 ms
		let g:snake_update = 125
	endif

	" Starting direction
	let s:dir = "right"

	" Used to repaint and draw the borders of the screen
	let s:spaces = ""
	let s:dashes = ""

	" Score
	let s:score = 0

	" Snake body and food coordinates
	let s:snake_body = [[1, 1], [1, 2], [1, 3], [1, 4]]
	let s:food = [2, 2]

	augroup SnakeUpdate
		au!
		" Call Update every updatetime milliseconds
		autocmd CursorHold * call Update()
	augroup END


	" Set the buftype to nofile
	setlocal buftype=nofile
	" Set updatetime
	let &l:updatetime = g:snake_update
	" Turn off any bells
	setlocal noeb
	setlocal vb
	setlocal t_vb=

	" Remap the movement keys
	map <buffer> j :call Down()<CR>
	map <buffer> h :call Left()<CR>
	map <buffer> k :call Up()<CR>
	map <buffer> l :call Right()<CR>

	" Start the game
	call Init()
endfunc

func! Init()
	let l:i = 1

	" Fill the spaces and dashes variables with real spaces and dashes
	while l:i <= g:snake_cols
		if l:i == g:snake_cols
			let s:spaces = s:spaces . '|'
			let s:dashes = s:dashes . '-'
		else
			let s:spaces = s:spaces . ' '
			let s:dashes = s:dashes . '-'
		endif

		let l:i = l:i + 1
	endwhile

	let l:i = 1

	while l:i <= g:snake_rows
		" Add rows
		call append(line('$'), s:spaces)
		let l:i = l:i + 1
	endwhile

	call SpawnFood()
endfunc

func! RespawnSnake()
	" Reset score, snake_body, and direction
	let s:score = 0
	let s:snake_body = [[1, 1], [1, 2], [1, 3], [1, 4]]
	let s:dir = "right"
endfunc

func! SpawnFood()
	" Pick new random coordinates
	let s:food[0] = Random(g:snake_cols - 3) + 1
	let s:food[1] = Random(g:snake_rows - 1) + 1
endfunc

" Change the direction
" These functions are called by the mappings to hjkl
func! Up()
	if s:dir !=? "down"
		let s:dir = "up"
	endif
endfunc

func! Down()
	if s:dir !=? "up"
		let s:dir = "down"
	endif
endfunc

func! Left()
	if s:dir !=? "right"
		let s:dir = "left"
	endif
endfunc

func! Right()
	if s:dir !=? "left"
		let s:dir = "right"
	endif
endfunc

" Update the game
func! Update()
	" Call feedkeys to trigger cursorhold again
	call feedkeys('f<esc>')

	" Repaint the screen
	call Repaint()

	" Get the x, y of the head of the snake
	let l:x = s:snake_body[0][0]
	let l:y = s:snake_body[0][1]

	" Make the movement on the head based on the direction
	if s:dir ==? "up"
		let l:y = l:y - 1
	elseif s:dir ==? "down"
		let l:y = l:y + 1
	elseif s:dir ==? "left"
		let l:x = l:x - 1
	elseif s:dir ==? "right"
		let l:x = l:x + 1
	endif

	" Check if the snake hit the wall
	if l:x >= g:snake_cols || l:x < 1 || l:y > g:snake_rows || l:y < 1
		call RespawnSnake()
		return
	endif

	" Check if the head of the snake is on the food
	if l:x == s:food[0] && l:y == s:food[1]
		" Add to score and respawn the food
		let s:score = s:score + 1
		call SpawnFood()
	else
		" Remove the tail from the snake
		call remove(s:snake_body, len(s:snake_body) - 1)
	endif

	" Respawn if the snake hits itself
	if index(s:snake_body, [x, y]) >= 0
		call RespawnSnake()
		return
	endif

	" Add a new piece of snake at the new head position
	call insert(s:snake_body, [x, y])

	" Draw everything
	call DrawFood()
	call DrawSnake()

	" Display the score
	echom 'Score: ' . s:score
endfunc

func! Repaint()
	" Loop through every row and draw either spaces or dashes on it
	let l:i = 0
	while l:i <= line('$')
		call setline(l:i, s:spaces)
		if l:i == line('$')
			call setline(l:i, s:dashes)
		endif
		let l:i = l:i + 1
	endwhile
endfunc

func! DrawSnake()
	let l:i = len(s:snake_body) - 1
	while l:i >= 0
		" Move the cursor to the next position
		call cursor(s:snake_body[l:i][1], s:snake_body[l:i][0])
		" Insert a '*' at that position
		norm! r*
		let l:i = l:i - 1
	endwhile
endfunc

func! DrawFood()
	" Move the cursor to the food position
	call cursor(s:food[1], s:food[0])
	" Insert an 'o' at that position
	norm! ro
endfunc

" Get a random number between 0 and n
func! Random(n)
	let l:rnd = localtime() % 0x10000
	let l:rnd = (l:rnd * 31421 + 6927) % 0x10000
	return l:rnd * a:n / 0x10000
endfunc
