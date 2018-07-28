if exists('g:loaded_simpleworkspaces')
	finish
endif

let g:loaded_simpleworkspaces = 1

if !exists('g:workspace_prefix')
	let g:workspace_prefix = $HOME.'/.cache/vim_workspaces'
endif

command! -nargs=? -complete=file WorkspaceInit call SimpleWorkspaces#init('<args>')
command! -nargs=? -complete=file WorkspaceAdd call SimpleWorkspaces#add('<args>')
command! -nargs=? -complete=file WorkspaceDelete call SimpleWorkspaces#rm('<args>')
command! -nargs=? -complete=file WorkspaceOpen call SimpleWorkspaces#open('<args>')
