# Vim Snake
Play ascii snake without leaving Vim! This game is written in Vimscript and allows
you to play snake from the comfort of your editor.

Control the snake with the hjkl keys (so that you can hone your vim movement
skills). Eat the apples and don't run into the wall or yourself.

![SnakeImage](./VimSnake.png)

## Installation
You can install this plugin with your favorite plugin manager.

Vundle (for example):
```
Plugin 'zyedidia/vim-snake'
```

Start the game by running `:Snake`.

## Options
You can choose different options for the width/height of the play area:
```
let g:snake_rows = 20
let g:snake_cols = 50
```

You can also choose the update time (millisecond delay between frame updates):
```
let g:snake_update = 125
```

## How does it work?

The game loop is run by abusing the `CursorHold` autocommand. If no keys are
pressed for a certain amount of time, the autocommand will be triggered. Notice
that if you hold down a key during the game, the loop stops.

You can read about this trick [here](http://vim.wikia.com/wiki/Timer_to_execute_commands_periodically).
