" Change cursor shape / color in xterm and other terminals
" I assume that screen/tmux runs in a compatible terminal as well
" gnome terminal doesn't support cursor reset (but I don't use
" gnome terminal for other reasons)

let g:xterm_cursor_normal_shape='blinking-block'
let g:xterm_cursor_insert_shape='blinking-underscore'

let s:cursor_shapes = {
      \ 'blinking-block': 1,
      \ 'solid-block': 2,
      \ 'blinking-underscore': 3,
      \ 'solid-underscore': 4,
      \ 'blinking-bar': 5,
      \ 'solid-bar': 6,
      \ }

fu! s:tmuxify( escape_sequence )
  " tmux will only forward escape sequences to the terminal if surrounded by a
  " DCS sequence http://bit.ly/zImrzb
  if exists('$TMUX')
    return "\ePtmux;\e" . a:escape_sequence . "\e\\"
  else
    return a:escape_sequence
  end
endfu

fu! s:xterm_cursor_shape(shape)
  let shape = a:shape
  if type(a:shape) == type("")
    let shape = s:cursor_shapes[a:shape]
  endif
  return s:tmuxify("\e[" . shape . " q")
endfu

if &term =~ "xterm\\|rxvt\\|screen"
  " cursor color escapes make the terminal blink, so don't
  let &t_SI = s:xterm_cursor_shape(g:xterm_cursor_insert_shape)
  let &t_EI = s:xterm_cursor_shape(g:xterm_cursor_normal_shape)

  " these escape codes make vim wait for more characters before reacting.
  " make it wait shorter without sacrificing usability of long key mappings
  set ttm=100
endif
