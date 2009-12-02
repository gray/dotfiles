"=============================================================================
" Author:					Frédéric Hardy - http://blog.mageekbox.net
" Date:						Fri Aug  7 09:43:24 CEST 2009
" Licence:					GPL version 2.0 license
"=============================================================================
let s:pattern = ''
let s:keywords = []
let s:currentKeyword = -1
"reset {{{1
function sherlock#reset()
	let s:pattern = ''
	let s:keywords = []
	let s:currentKeyword = -1

	silent! cunmap /
	silent! cunmap ?
	silent! cunmap <Esc>
	silent! cunmap <CR>

	return getcmdline()
endfunction
"find {{{1
function sherlock#find(pattern)
	let keywords = []

	let position = getpos('.')

	normal! gg

	let line = searchpos(a:pattern . '\k*', 'W')

	while line[0] != 0 && line[1] != 0
		let keyword = substitute(strpart(getline(line[0]), line[1] - 1), '^' . a:pattern . '\(\k*\).*$', '\1', '')

		if index(keywords, keyword) < 0
			call add(keywords, keyword)
		endif

		let line = searchpos(a:pattern . '\k*', 'W')
	endwhile

	call setpos('.', position)

	return keywords
endfunction
"complete {{{1
function sherlock#complete(direction)
	let cmdtype = getcmdtype()

	if cmdtype == '/' || cmdtype == '?' || cmdtype == ':'
		let cmdline = getcmdline()
		let cmdpos = getcmdpos() - 1

		let pattern = strpart(cmdline, 0, cmdpos)
		let separator = cmdtype

		if cmdtype == ':' && pattern =~ '\/.\{-}$'
			let pattern = substitute(pattern, '^.*\/\(.\{-}\)$', '\1', '')
			let separator = '/'
		endif

		if pattern == ''
			call sherlock#reset()
		elseif pattern != s:pattern
			call sherlock#reset()

			let keywords = sherlock#find(pattern)

			if len(keywords)
				let s:pattern = pattern
				let s:keywords = keywords

				if cmdtype == '/' || cmdtype == ':'
					cnoremap / <C-\>esherlock#reset()<CR>/
				else
					cnoremap ? <C-\>esherlock#reset()<CR>?
				endif

				cnoremap <Esc> <C-\>esherlock#reset()<CR>
				cnoremap <CR> <C-\>esherlock#reset()<CR><CR>
			endif
		endif

		if len(s:keywords)
			if a:direction > 0
				let s:currentKeyword += a:direction
			else
				let s:currentKeyword = s:currentKeyword >= 0 ? s:currentKeyword - 1 : len(s:keywords) - 1
			endif

			if s:currentKeyword >= 0 && s:currentKeyword < len(s:keywords)
				let keyword = escape(s:keywords[s:currentKeyword], '[]/')
			else
				let s:currentKeyword = -1
				let keyword = ''
			endif

			let separatorIndex = stridx(cmdline, separator, cmdpos)
			let cmdline = strpart(cmdline, 0, cmdpos) . keyword . (separatorIndex < 0 ? '' : strpart(cmdline, separatorIndex))
			call setcmdpos(cmdpos + 1)
		endif
	endif

	return cmdline
endfunction
"sherlock#completeForward {{{1
function sherlock#completeForward()
	return sherlock#complete(1)
endfunction
"sherlock#completeBackward {{{1
function sherlock#completeBackward()
	return sherlock#complete(-1)
endfunction
"makeVimball {{{1
function sherlock#makeVimball()
	split sherlockVimball

	setlocal bufhidden=delete
	setlocal nobuflisted
	setlocal noswapfile

	let files = 0

	for file in split(globpath(&runtimepath, '**/sherlock*'), "\n")
		for runtimepath in split(&runtimepath, ',')
			if file =~ '^' . runtimepath
				if getftype(file) != 'dir'
					let files += 1
					call setline(files, substitute(file, '^' . runtimepath . '/', '', ''))
				else
					for subFile in split(glob(file . '/**'), "\n")
						if getftype(subFile) != 'dir'
							let files += 1
							call setline(files, substitute(subFile, '^' . runtimepath . '/', '', ''))
						endif
					endfor
				endif
			endif
		endfor
	endfor

	try
		execute '%MkVimball! sherlock'

		setlocal nomodified
		bwipeout

		echomsg 'Vimball is in ''' . getcwd() . ''''
	catch /.*/
		echohl ErrorMsg
		echomsg v:exception
		echohl None
	endtry
endfunction
" vim:filetype=vim foldmethod=marker shiftwidth=3 tabstop=3
