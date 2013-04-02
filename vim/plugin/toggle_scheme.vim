if !exists('g:light_scheme') | let g:light_scheme='morning' | endif
if !exists('g:dark_scheme') | let g:dark_scheme='slate' | endif

fu! s:SetSchemeAndXtermCursor(scheme,xterm_cursor_color)
  exec "color " . a:scheme
  call xterm_cursor#set_color(a:xterm_cursor_color)
endfu

command! Light call s:SetSchemeAndXtermCursor(g:light_scheme,'rgb:0/90/0')
command! Dark call s:SetSchemeAndXtermCursor(g:dark_scheme,'rgb:a0/ff/a0')

fu! s:ToggleScheme()
  if exists("g:colors_name") && g:colors_name == g:dark_scheme
    Light
  else
    Dark
  endif
endfu
command! ToggleScheme call s:ToggleScheme()

