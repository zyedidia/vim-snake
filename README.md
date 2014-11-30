#vim-snake
This is a snake game written in pure vim

##Installation
Install as you would a normal plugin

```
cd ~/.vim/bundle
git clone https://github.com/zyedidia/vim-snake.git
```

Start the game of snake by running `:Snake`

##Options
You can choose different options for the width/height of the play area:
```
let g:snake_rows = 20
let g:snake_cols = 50
```

You can also choose the update time (millisecond delay between frame updates):
```
let g:snake_update = 125
```
