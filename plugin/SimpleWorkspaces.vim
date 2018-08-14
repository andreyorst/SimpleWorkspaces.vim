if exists('did_load_simpleworkspaces')
	finish
endif

let did_load_simpleworkspaces = 1

if !exists('g:SimpleWorkspaces#prefix')
	let g:SimpleWorkspaces#prefix = $HOME.'/.cache/vim_workspaces'
endif

if !exists('g:SimpleWorkspaces#last_workspace')
	let g:SimpleWorkspaces#last_workspace = $HOME.'/.config/vim_last_workspace'
endif

if !exists('g:SimpleWorkspaces#manual_save_path')
	let g:SimpleWorkspaces#manual_save_path = $HOME.'/.vim/saved_workspaces'
endif

function! s:RestoreWorkspace()
	if g:SimpleWorkspaces#open_previous > 0 && filereadable(g:SimpleWorkspaces#last_workspace)
		let l:workspace_path = readfile(g:SimpleWorkspaces#last_workspace)
		call SimpleWorkspaces#open(l:workspace_path[0])
	endif
endfunction

command! -nargs=? -complete=file WorkspaceInit call SimpleWorkspaces#init('<args>')
command! -nargs=? -complete=file WorkspaceAdd call SimpleWorkspaces#add('<args>')
command! -nargs=? -complete=file WorkspaceDelete call SimpleWorkspaces#rm('<args>')
command! -nargs=? -complete=custom,s:AvailableWorkspaces WorkspaceOpen call SimpleWorkspaces#open('<args>')
command! -nargs=? -complete=file WorkspaceSave call SimpleWorkspaces#save('<args>')
command! -nargs=0 WorkspaceQuit call SimpleWorkspaces#quit()

function! s:AvailableWorkspaces(a,b,c)
	if isdirectory(g:SimpleWorkspaces#prefix)
		let l:workspace_names = []
		if isdirectory(g:SimpleWorkspaces#manual_save_path)
			for workspace in split(globpath(g:SimpleWorkspaces#manual_save_path, '*/.workspace'), '\n')
				call add(l:workspace_names, substitute(workspace, '\v.*/(.*)/.workspace$', '\1', &gd ? 'gg' : 'g'))
			endfor
		endif
		for workspace in split(globpath(g:SimpleWorkspaces#prefix, '*/.workspace'), '\n')
			call add(l:workspace_names, substitute(workspace, '\v.*/(.*)/.workspace$', '\1', &gd ? 'gg' : 'g'))
		endfor
		return join(l:workspace_names, "\n")
	endif
	return ''
endfunction

if exists('g:SimpleWorkspaces#open_previous')
	call s:RestoreWorkspace()
endif

