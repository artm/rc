" Vim color file
" Maintainer:  Artem Baguinski <femistofel@gmail.com>
"
" The ancestry goes like {{{
"   - summerfruit by Armin Ronacher
"   - desert256 by Henry So (color functions)
"   - summerfruit256 by Martin Baeuml
"   - artm_light
" }}}

" vim script houskeeping {{{
set background=light
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="artm_light"
" }}}

let s:main_foreground = "404040"
let s:main_background = "fcfcfc"
let s:cursor_cross_backround = "d2dee6"
let s:active_window_frame_foreground = "fcfcfc"
let s:active_window_frame_background = "51b069"
let s:passive_window_frame_foreground = "51b069"
let s:passive_window_frame_background = "9bd4a9"
let s:gutter_background = "cbf4c9"

let s:highlight_foreground = "af70af"
let s:highlight_background = "efef70"

if has("gui_running") || &t_Co == 88 || &t_Co == 256
    " functions {{{
    " returns an approximate grey index for the given grey level
    fun <SID>grey_number(x)
        if &t_Co == 88
            if a:x < 23
                return 0
            elseif a:x < 69
                return 1
            elseif a:x < 103
                return 2
            elseif a:x < 127
                return 3
            elseif a:x < 150
                return 4
            elseif a:x < 173
                return 5
            elseif a:x < 196
                return 6
            elseif a:x < 219
                return 7
            elseif a:x < 243
                return 8
            else
                return 9
            endif
        else
            if a:x < 14
                return 0
            else
                let l:n = (a:x - 8) / 10
                let l:m = (a:x - 8) % 10
                if l:m < 5
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual grey level represented by the grey index
    fun <SID>grey_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 46
            elseif a:n == 2
                return 92
            elseif a:n == 3
                return 115
            elseif a:n == 4
                return 139
            elseif a:n == 5
                return 162
            elseif a:n == 6
                return 185
            elseif a:n == 7
                return 208
            elseif a:n == 8
                return 231
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 8 + (a:n * 10)
            endif
        endif
    endfun

    " returns the palette index for the given grey index
    fun <SID>grey_color(n)
        if &t_Co == 88
            if a:n == 0
                return 16
            elseif a:n == 9
                return 79
            else
                return 79 + a:n
            endif
        else
            if a:n == 0
                return 16
            elseif a:n == 25
                return 231
            else
                return 231 + a:n
            endif
        endif
    endfun

    " returns an approximate color index for the given color level
    fun <SID>rgb_number(x)
        if &t_Co == 88
            if a:x < 69
                return 0
            elseif a:x < 172
                return 1
            elseif a:x < 230
                return 2
            else
                return 3
            endif
        else
            if a:x < 75
                return 0
            else
                let l:n = (a:x - 55) / 40
                let l:m = (a:x - 55) % 40
                if l:m < 20
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual color level for the given color index
    fun <SID>rgb_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 139
            elseif a:n == 2
                return 205
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 55 + (a:n * 40)
            endif
        endif
    endfun

    " returns the palette index for the given R/G/B color indices
    fun <SID>rgb_color(x, y, z)
        if &t_Co == 88
            return 16 + (a:x * 16) + (a:y * 4) + a:z
        else
            return 16 + (a:x * 36) + (a:y * 6) + a:z
        endif
    endfun

    " returns the palette index to approximate the given R/G/B color levels
    fun <SID>color(r, g, b)
        " get the closest grey
        let l:gx = <SID>grey_number(a:r)
        let l:gy = <SID>grey_number(a:g)
        let l:gz = <SID>grey_number(a:b)

        " get the closest color
        let l:x = <SID>rgb_number(a:r)
        let l:y = <SID>rgb_number(a:g)
        let l:z = <SID>rgb_number(a:b)

        if l:gx == l:gy && l:gy == l:gz
            " there are two possibilities
            let l:dgr = <SID>grey_level(l:gx) - a:r
            let l:dgg = <SID>grey_level(l:gy) - a:g
            let l:dgb = <SID>grey_level(l:gz) - a:b
            let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
            let l:dr = <SID>rgb_level(l:gx) - a:r
            let l:dg = <SID>rgb_level(l:gy) - a:g
            let l:db = <SID>rgb_level(l:gz) - a:b
            let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
            if l:dgrey < l:drgb
                " use the grey
                return <SID>grey_color(l:gx)
            else
                " use the color
                return <SID>rgb_color(l:x, l:y, l:z)
            endif
        else
            " only one possibility
            return <SID>rgb_color(l:x, l:y, l:z)
        endif
    endfun

    " returns the palette index to approximate the 'rrggbb' hex string
    fun <SID>rgb(rgb)
        let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
        let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
        let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

        return <SID>color(l:r, l:g, l:b)
    endfun

    " sets the highlighting for the given group
    fun <SID>X(group, fg, bg, attr)
        if a:fg != ""
            exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
        endif
        if a:bg != ""
            exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
        endif
        if a:attr != ""
            exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
        endif
    endfun
    " }}}

    " Global {{{
    call <SID>X("Normal", s:main_foreground, s:main_background, "none")
    call <SID>X("NonText", "e0e0e0", s:main_background, "none")
    call <SID>X("SpecialKey", "ff0000", "e0e0e0", "none")
    " }}}

    " Search {{{
    call <SID>X("Search", s:highlight_foreground, s:highlight_background, "")
    call <SID>X("IncSearch", s:highlight_foreground, s:highlight_background, "inverse")
    " }}}

    " Interface Elements {{{
    call <SID>X("StatusLine", s:active_window_frame_foreground, s:active_window_frame_background, "bold")
    call <SID>X("StatusLineNC", s:passive_window_frame_foreground, s:passive_window_frame_background, "none")
    call <SID>X("VertSplit", s:passive_window_frame_foreground, s:passive_window_frame_background, "none")
    call <SID>X("Folded", "a0a0a0", "f3dafa", "")
    call <SID>X("Pmenu", "808080", "f0f0f0", "none")
    call <SID>X("PmenuSel", "808080", s:gutter_background, "bold")
    call <SID>X("SignColumn", "", "", "")
    call <SID>X("CursorLine", "", s:cursor_cross_backround, "none")
    call <SID>X("CursorColumn", "", s:cursor_cross_backround, "")
    call <SID>X("LineNr", "a0a0a0", s:gutter_background, "none")
    call <SID>X("CursorLineNr", "808080", s:cursor_cross_backround, "bold")
    call <SID>X("MatchParen", "", s:main_background, "underline")
    call <SID>X("Visual", "", s:highlight_background, "none")
    " }}}

    " diff {{{
    call <SID>X("DiffText", "", "ffb0b0", "none")
    " }}}
    " tabs {{{
    call <SID>X("TabLine", s:passive_window_frame_foreground, s:passive_window_frame_background, "none")
    call <SID>X("TabLineSel", s:active_window_frame_foreground, s:active_window_frame_background, "bold")
    call <SID>X("TabLineFill", "", s:gutter_background, "none")
    " }}}

    " Specials {{{
    " TODO FIXME
    call <SID>X("Todo", s:highlight_foreground, s:highlight_background, "bold")
    call <SID>X("Title", "000000", "", "")
    call <SID>X("Special", "fd8900", "", "")
    " }}}

    " Syntax Elements {{{
    call <SID>X("String", "0086d2", "", "")
    call <SID>X("Constant", "0086d2", "", "")
    call <SID>X("Number", "0086f7", "", "")
    call <SID>X("Statement", "fb660a", "", "")
    call <SID>X("Function", "ff0086", "", "")
    call <SID>X("PreProc", "ff0007", "", "")
    call <SID>X("Comment", "909090", "", "")
    call <SID>X("Type", "70796b", "", "")
    call <SID>X("Error", "ffffff", "d40000", "")
    call <SID>X("Identifier", "ff0086", "", "")
    call <SID>X("Label", "ff0086", "", "")
    " }}}

    " HTML Highlighting {{{
    call <SID>X("htmlTag", "00bdec", "", "")
    call <SID>X("htmlEndTag", "00bdec", "", "")
    call <SID>X("htmlSpecialTagName", "4aa04a", "", "")
    call <SID>X("htmlTagName", "4aa04a", "", "")
    call <SID>X("htmlTagN", "4aa04a", "", "")
    " }}}

    " delete functions {{{
    delf <SID>X
    delf <SID>rgb
    delf <SID>color
    delf <SID>rgb_color
    delf <SID>rgb_level
    delf <SID>rgb_number
    delf <SID>grey_color
    delf <SID>grey_level
    delf <SID>grey_number
    " }}}
endif

" vim: set fdl=0 fdm=marker:

