if exists('did_load_simpleworkspaces')
	finish
endif

let did_load_simpleworkspaces = 1

augroup PreviousWorkspaceHandling
	autocmd!
	autocmd BufEnter * call s:RestoreWorkspace()
	autocmd VimLeave * call s:SaveWorkspace(g:last_workspace_path)
augroup end

if !exists('g:workspace_prefix')
	let g:workspace_prefix = $HOME.'/.cache/vim_workspaces'
endif

if !exists('g:last_workspace_path')
	let g:last_workspace_path = $HOME.'/.vim_last_workspace'
endif

function! s:RestoreWorkspace()
	if exists('g:open_previous_workspace')
		if g:open_previous_workspace > 0 && filereadable(g:last_workspace_path)
			let l:workspace_path = readfile(g:last_workspace_path)
			call SimpleWorkspaces#open(l:workspace_path[0])
		endif
	endif
endfunction

function! s:SaveWorkspace()
	if exists('g:open_previous_workspace')
		if g:open_previous_workspace > 0
			let l:workspace_name = SimpleWorkspaces#isInside()
			if l:workspace_name != -1
				call writefile(l:workspace_name, g:last_workspace_path, '')
			endif
		endif
	endif
endfunction

command! -nargs=? -complete=file WorkspaceInit call SimpleWorkspaces#init('<args>')
command! -nargs=? -complete=file WorkspaceAdd call SimpleWorkspaces#add('<args>')
command! -nargs=? -complete=file WorkspaceDelete call SimpleWorkspaces#rm('<args>')
command! -nargs=? -complete=custom,s:AvailableWorkspaces WorkspaceOpen call SimpleWorkspaces#open('<args>')
command! -nargs=0 WorkspaceQuit call SimpleWorkspaces#quit()

function! s:AvailableWorkspaces(a,b,c)
	if isdirectory(g:workspace_prefix)
		let l:workspace_names = []
		for workspace in split(globpath(g:workspace_prefix, '*'), '\n')
			call add(l:workspace_names, substitute(workspace, '\v.*/(.*)$', '\1', &gd ? 'gg' : 'g'))
		endfor
		return join(l:workspace_names, "\n")
	endif
	return ''
endfunction

