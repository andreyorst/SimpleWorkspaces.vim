
" ╭─────────────╥──────────────────────╮
" │ Author:     ║ File:                │
" │ Andrey Orst ║ SimpleWorkspaces.vim │
" ╞═════════════╩══════════════════════╡
" │ Last change: 07.27.2018            │
" │ version: 0.0.1                     │
" ╰────────────────────────────────────╯

let s:current_workspace_path = ''

if exists('g:load_previous_workspace')
	if g:load_previous_workspace > 0
		"call WorkspaceOpen(g:previous_workspace)
	endif
endif

function! WorkspaceInit(...)
	if a:0 == 0
		let l:current_dir = fnameescape(getcwd())
	elseif a:0 == 1
		let l:current_dir = a:1
	else
		echo "[ERROR] Too many arguments"
		return -1
	endif
	let l:workspace_name = 'workspace_'.getpid()
	let s:current_workspace_path = fnameescape(g:workspace_prefix.'/'.l:workspace_name)
	if !isdirectory(g:workspace_prefix)
		let l:answer = input("Cannot reach workspace prefix. Create ".g:workspace_prefix."? [Y/n] ")
		if l:answer ==? 'y' || l:answer == ''
			call mkdir(g:workspace_prefix, 'p')
		elseif l:answer ==? 'n' || l:answer == ''
			return 0
		endif
	endif
	if isdirectory(s:current_workspace_path)
		let l:answer = input("Workspace ".l:workspace_name. " already exists. Owerwrite it? [y/N]: ")
		if l:answer ==? 'y'
			try
				call s:Delete(s:current_workspace_path, "[ERROR] Cannot delete workspace ".s:current_workspace_path)
			catch
				return -1
			endtry
			return s:CreateWorkspace(l:current_dir, s:current_workspace_path)
		elseif l:answer ==? 'n' || l:answer == ''
			let l:answer = input("Open workspace ".l:workspace_name. "? [Y/n]: ")
			if  l:answer ==? 'y' || l:answer == ''
				exec "cd ".s:current_workspace_path
				return 0
			else
				return 0
			endif
		else
			return -1
		endif
	else
		return s:CreateWorkspace(l:current_dir, s:current_workspace_path)
	endif
endfunction

function! WorkspaceAdd(...)
	if a:0 == 0
		let l:path = input("Path to directory or file: ")
	elseif a:0 == 1
		let l:path = a:1
	else
		echo "[ERROR] Too many arguments"
		return -1
	endif
	if fnameescape(getcwd()) == s:current_workspace_path
		return s:MakeLink(l:path, s:current_workspace_path)
	else
		let l:answer = input("No active workspace found. Create new workspace? [Y/n]: ")
		if l:answer ==? 'y' || l:answer == ''
			try
				call WorkspaceInit()
			catch
				echo "[ERROR] Cannot add ".l:path." to workspace"
				return -1
			endtry
			return s:MakeLink(l:path, s:current_workspace_path)
		else
			return 0
		endif
	endif
endfunction

function! WorkspaceRm(...)
	if a:0 == 0
		let l:path = expand(input("Directory or file to delete: "))
	elseif a:0 == 1
		let l:path = a:1
	else
		echo "[ERROR] Too many arguments"
		return -1
	endif
	if fnameescape(expand(getcwd())) == s:current_workspace_path
		return s:Delete(l:path, "[ERROR] cannot delete ".l:path)
	else
		echo "[ERROR] Not inside workspace"
		return -1
	endif
endfunction

function! s:CreateWorkspace(dir, workspace_path)
	try
		call mkdir(fnameescape(a:workspace_path), 'p')
	catch
		echo "[ERROR] Cannot create workspace at ".a:workspace_path
		return -1
	endtry
	try
		exec "cd ".a:workspace_path
	catch
		echo "[ERROR] Cannot change working directory to ".g:workspace_prefix
		return -1
	endtry
	if a:dir != a:workspace_path
		return s:MakeLink(a:dir, a:workspace_path)
	endif
endfunction

function! WorkspaceOpen(workspace_path)
	let l:match = match(g:workspace_prefix.'/'.a:workspace_path, expand(a:workspace_path))
	if l:match > 0
		if isdirectory(fnameescape(expand(g:workspace_prefix.'/'.a:workspace_path)))
			exec "cd ".g:workspace_prefix.'/'.a:workspace_path
			return 0
		endif
	elseif l:match == 0
		exec "cd ".a:workspace_path
		return 0
	endif
	try
		exec "cd ".a:workspace_path
	catch
		echo "[ERROR] Cannot change working directory to ".a:workspace_path
		return -1
	endtry
endfunction

function! s:MakeLink(path, workspace)
	redraw
	if has('win64') || has('win32') || has('win16')
		try
			silent exec '!mklink /D '.a:path.' '.a:workspace
		catch
			echo "[ERROR] Cannot add directory to workspace"
			return -1
		endtry
	elseif executable('ln')
		try
			silent exec '!ln -sf '.a:path.' '.a:workspace
		catch
			echo "[ERROR] Cannot add directory to workspace"
			return -1
		endtry
	else
		echo "[ERROR] Cannot determinate OS"
		return -1
	endif
	return 0
endfunction

function! s:Delete(path, prompt)
	if !isdirectory(fnameescape(expand(a:path))) && !filereadable(fnameescape(expand(a:path)))
		redraw
		echo a:prompt
		return -1
	else
		try
			call delete(a:path, 'rf')
		catch
			redraw
			echo a:prompt
			return -1
		endtry
	endif
endfunction

