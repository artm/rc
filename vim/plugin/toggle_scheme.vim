if !exists('g:light_scheme') | let g:light_scheme='morning' | endif
if !exists('g:dark_scheme') | let g:dark_scheme='slate' | endif

fu! s:SetSchemeAndXtermCursor(scheme)
  exec "color " . a:scheme
endfu

command! Light call s:SetSchemeAndXtermCursor(g:light_scheme)
command! Dark call s:SetSchemeAndXtermCursor(g:dark_scheme)

fu! s:ToggleScheme()
  if exists("g:colors_name") && g:colors_name == g:dark_scheme
    Light
  else
    Dark
  endif
endfu
command! ToggleScheme call s:ToggleScheme()

let s:xterm_scheme_file = expand("~/rc/dynamic-colors/colorscheme")
if filereadable( s:xterm_scheme_file )
  let s:xterm_scheme = readfile( s:xterm_scheme_file, 0, 1 )[0]
  if s:xterm_scheme =~ "light\\c"
    let g:default_bg = "light"
  elseif s:xterm_scheme =~ "dark\\c"
    let g:default_bg = "dark"
  endif
endif

if exists('g:default_bg') && g:default_bg == 'light'
  Light
else
  Dark
endif

