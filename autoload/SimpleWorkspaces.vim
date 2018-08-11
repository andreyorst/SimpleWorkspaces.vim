if exists('b:did_autoload_simpleworkspaces')
	finish
endif

let b:did_autoload_simpleworkspaces = 1

let s:current_workspace_path = ''
let s:pre_workspace_path = ''

function! SimpleWorkspaces#init(...)
	if a:0 == 0 || a:1 == ''
		let l:current_dir = fnameescape(getcwd())
	elseif a:0 == 1
		let l:current_dir = a:1
	else
		echo "[ERROR] Too many arguments"
		return -1
	endif
	let l:workspace_name = 'workspace_'.getpid()
	let s:current_workspace_path = expand(g:workspace_prefix.'/'.l:workspace_name)
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
			return s:CreateWorkspace(l:current_dir, g:workspace_prefix, l:workspace_name)
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
		return s:CreateWorkspace(l:current_dir, g:workspace_prefix, l:workspace_name)
	endif
endfunction

function! SimpleWorkspaces#add(...)
	if a:0 == 0
		let l:path = input("Path to directory or file: ", "file")
	elseif a:0 == 1
		let l:path = a:1
	else
		echo "[ERROR] Too many arguments"
		return -1
	endif
	if SimpleWorkspaces#isInside() != -1
		return s:MakeLink(l:path, s:current_workspace_path)
	else
		let l:path = fnameescape(getcwd()).'/'.l:path
		let l:answer = input("No active workspace found. Create new workspace? [Y/n]: ")
		if l:answer ==? 'y' || l:answer == ''
			if SimpleWorkspaces#init() == 0
				if SimpleWorkspaces#isInside() != -1
					return s:MakeLink(l:path, s:current_workspace_path)
				endif
			endif
		else
			return 0
		endif
	endif
endfunction

function! SimpleWorkspaces#rm(...)
	if a:0 == 0
		let l:path = expand(input("Directory or file to delete: ", "file"))
	elseif a:0 == 1 && a:1 != '.workspace'
		let l:path = a:1
	else
		echo "[ERROR] Too many arguments"
		return -1
	endif
	if SimpleWorkspaces#isInside() != -1
		let l:path = substitute(l:path, '\v(.*)/.*', '\1', &gd ? 'gg' : 'g')
		return s:Delete(l:path, "[ERROR] cannot delete ".l:path)
	else
		echo "[ERROR] Not inside workspace"
		return -1
	endif
endfunction

function! s:Delete(path, prompt)
	if !isdirectory(expand(a:path)) && !filereadable(expand(a:path))
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

function! s:CreateWorkspace(dir, workspace_prefix, workspace_name)
	let l:workspace_path = expand(a:workspace_prefix.'/'.a:workspace_name)
	let l:current_path = getcwd()
	try
		call mkdir(l:workspace_path, 'p')
	catch
		echo "[ERROR] Cannot create workspace at ".l:workspace_path
		return -1
	endtry
	try
		exec "cd ".l:workspace_path
		let l:metadata = [
					\ 'workspace name: '.a:workspace_name,
					\ 'date created: '. strftime('%b %d %Y %X'),
					\ ]
		call writefile(l:metadata, './.workspace', '')
		call s:SaveWorkspace()
	catch
		echo "[ERROR] Cannot change working directory to ".g:workspace_prefix
		return -1
	endtry
	if s:pre_workspace_path == ''
		let s:pre_workspace_path = l:current_path
	endif
	if a:dir != l:workspace_path
		return s:MakeLink(a:dir, l:workspace_path)
	endif
endfunction

function! SimpleWorkspaces#open(...)
	if a:0 == 0 || a:1 == ''
		let l:workspace_path = expand(input("Workspaace name,or path: ", "", "file"))
		if l:workspace_path == ''
			return 0
		endif
	elseif a:0 == 1
		let l:workspace_path = a:1
	else
		echo "[ERROR] Too many arguments"
		return -1
	endif
	let l:match = match(expand(g:workspace_prefix.'/'.l:workspace_path), expand(l:workspace_path))
	if l:match > 0 && isdirectory(expand(g:workspace_prefix.'/'.l:workspace_path))
		let l:workspace_path = expand(g:workspace_prefix.'/'.l:workspace_path)
	else
		let l:workspace_path = l:workspace_path
	endif
	try
		if filereadable(l:workspace_path.'/.workspace')
			exec "cd ".l:workspace_path
			call s:SaveWorkspace()
			return 0
		else
			echo "[ERROR] Directory ".l:workspace_path." is not a workspace"
		endif
	catch
		echo "[ERROR] Cannot change working directory to ".l:workspace_path
		return -1
	endtry
endfunction

function! s:MakeLink(path, workspace)
	redraw
	if has('win64') || has('win32') || has('win16')
		try
			if isdirectory(a:path)
				silent exec '!mklink /D '.a:path.' '.a:workspace
			elseif filereadable(a:path)
				silent exec '!mklink '.a:path.' '.a:workspace
			endif
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

function! SimpleWorkspaces#isInside()
	let l:metadata = s:GetMetadata()
	if !empty(l:metadata)
		let l:workspace_name = substitute(l:metadata[0], '\v.*:\s+(.*)', '\1', &gd ? 'gg' : 'g')
		return l:workspace_name
	endif
	return -1
endfunction

function! s:GetMetadata()
	let l:metadata = []
	if filereadable('./.workspace')
		let l:metadata = readfile('./.workspace')
		if match(l:metadata[0], 'workspace name') != 0
			echo "[ERROR] Corrupted workspace metadata"
			let l:metadata = []
		endif
	endif
	return l:metadata
endfunction

function! SimpleWorkspaces#quit()
	if s:pre_workspace_path != ''
		exec "cd ".s:pre_workspace_path
	else
		cd $HOME
	endif
endfunction

function! s:SaveWorkspace()
	if exists('g:open_previous_workspace')
		if g:open_previous_workspace > 0
			let l:workspace_name = SimpleWorkspaces#isInside()
			if l:workspace_name != -1
				call writefile([l:workspace_name], g:last_workspace_path, '')
			endif
		endif
	endif
endfunction

