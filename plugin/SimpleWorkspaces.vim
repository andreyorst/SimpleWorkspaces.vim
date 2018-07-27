
" ╭─────────────╥──────────────────────╮
" │ Author:     ║ File:                │
" │ Andrey Orst ║ SimpleWorkspaces.vim │
" ╞═════════════╩══════════════════════╡
" │ Last change: 07.27.2018            │
" │ version: 0.0.1                     │
" ╰────────────────────────────────────╯

if !exists('g:workspace_prefix')
	let g:workspace_prefix = $HOME.'/.cache/vim_workspaces'
endif

command! -nargs=? -complete=file WorkspaceInit call WorkspaceInit('<args>')
command! -nargs=? -complete=file WorkspaceAdd call WorkspaceAdd('<args>')
command! -nargs=? -complete=file WorkspaceRm call WorkspaceRm('<args>')
command! -nargs=? -complete=file WorkspaceOpen call WorkspaceOpen('<args>')
