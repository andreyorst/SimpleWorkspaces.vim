if exists('g:loaded_simpleworkspaces')
	finish
endif

let g:loaded_simpleworkspaces = 1
let g:open_previous_workspace = 1

augroup PreviousWorkspaceHandling
	autocmd!
	autocmd BufEnter * call s:RestoreWorkspace()
	autocmd VimLeave * call s:SaveWorkspace(g:last_workspace)
augroup end

if !exists('g:workspace_prefix')
	let g:workspace_prefix = $HOME.'/.cache/vim_workspaces'
endif

if !exists('g:last_workspace')
	let g:last_workspace = $HOME.'/.vim_last_workspace'
endif

function! s:RestoreWorkspace()
	if exists('g:open_previous_workspace')
		if g:open_previous_workspace > 0 && filereadable(g:last_workspace)
			let l:workspace_path = readfile(g:last_workspace)
			call SimpleWorkspaces#open(l:workspace_path)
		endif
	endif
endfunction

function! s:SaveWorkspace()
	if exists('g:open_previous_workspace')
		if g:open_previous_workspace > 0
			let l:workspace_path = SimpleWorkspaces#getCurrentWorkspaceAsList()
			call writefile(l:workspace_path, g:last_workspace, '')
		endif
	endif
endfunction

command! -nargs=? -complete=file WorkspaceInit call SimpleWorkspaces#init('<args>')
command! -nargs=? -complete=file WorkspaceAdd call SimpleWorkspaces#add('<args>')
command! -nargs=? -complete=file WorkspaceDelete call SimpleWorkspaces#rm('<args>')
command! -nargs=? -complete=file WorkspaceOpen call SimpleWorkspaces#open('<args>')
