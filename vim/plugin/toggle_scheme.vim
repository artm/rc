if !exists('g:light_scheme') | let g:light_scheme='morning' | endif
if !exists('g:dark_scheme') | let g:dark_scheme='slate' | endif

fu! SetSchemeAndBg(scheme,bg)
  exec "color " . a:scheme
  exec "set bg=" . a:bg
  let g:colors_name = a:scheme
endfu

command! Light call SetSchemeAndBg(g:light_scheme,'light')
command! Dark call SetSchemeAndBg(g:dark_scheme,'dark')

fu! ToggleScheme()
  if exists("g:colors_name") && g:colors_name == g:dark_scheme
    Light
  else
    Dark
  endif
endfu
command! ToggleScheme call ToggleScheme()

if exists('g:default_bg') && g:default_bg == light
  Light
else
  Dark
endif
