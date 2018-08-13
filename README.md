# SimpleWorkspaces.vim

SimpleWorkspaces.vim is a plugin, which  provides  a  Visual  Studio  Code  like
workspace feature to Vim and Neovim.

For those who never used VS Code, or Atom, *workspace* in general is  a  certain
area, where are all your files are accessible by  editor  features,  like  fuzzy
file finding, search for file contents recursively, etc. You  can  add  specific
folders or files to workspace, so you could search over them. Usually workspaces 
are useful when you need to work on certain part of  a  huge  project,  and  you
don't need other files.  By adding only workflow related files  and  folders  to
workspace, so you'll be able to open those files with different fuzzy  matchers,
like fzf, Denite, CtrlP, and even Vim's wildcards, and  unnecessary  files  will
not stand in your way. Or for example you need to work with two or more projects
alongside, or just add a separate folder to current project.   Workspaces  allow
you to do it.

You   can   read   more    about    workspaces    at    Visual    Studio    Code
[docs](https://code.visualstudio.com/docs/editor/multi-root-workspaces).

## Install

If you're using [vim-plug](https://github.com/junegunn/vim-plug),  add  this  to
your `.vimrc` or `init.vim`:

```vim
Plug 'andreyorst/SimpleWorkspaces.vim'
```

Then:

```vim
:w | so % | PlugInstall
```

## Usage

After installation new commands will be added to Vim:

- `:WorkspaceInit`   - creates new workspace and adds current directory to it;
- `:WorkspaceOpen`   - Opens existing workspace
- `:WorkspaceAdd`    - adds file or directory to current workspace
- `:WorkspaceDelete` - removes file or directory from current workspace
- `:WorkspaceQuit`   - exits workspace
- `:WorkspaceSave`   - save workspace with a meaningful name

More deep explanations are available in [docs](https://github.com/andreyorst/SimpleWorkspaces.vim/blob/master/doc/SimpleWorkspaces.txt).

This plugin will ask you to create a *workspace prefix*, which  is  a  directory
where workspaces are stored.  By default it is `~/.cache/vim_workspaces`, if you
don't want your workspaces to stay  after  reboot,  or  want  to  use  different
directory, consider using `g:workspace_prefix`variable.

You can automatically open your last workspace on Vim startup, by setting
variable `g:open_previous_workspace` to `1`.

## How it works

This plugin uses symbolic links, to add files and folders to workspace.  Because
symbolic links are just files in a workspace folder, you can use external  tools
like grep or fzf on them.  Most of the plugins can work through symlincs.   Some
tools like gitgrep may require special flags  to  follow  symbolic  links.   Pay
attention to such things.

Windows support is experimental, because it is not POSIX compatible, and it uses
different way of managing symbolic links.  This needs more testing, but I  don't
use Vim on windows, so feedback is always appreciated.

## About

This plugin is created and being maintained by
[@andreyorst](https://GitHub.com/andreyorst).
It is being tested against Vim 8.0, Vim 7.4.1689 and neovim 0.3.\*. Other versions
are not officially supported, but might work.  If you found an issue, or want to
propose a change,  you're  welcome  to  do  so  at  SimpleWorkspaces.vim  GitHub
repository: https://github.com/andreyorst/SimpleWorkspaces.vim
