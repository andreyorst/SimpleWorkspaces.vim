# SimpleWorkspaces.vim

SimpleWorkspaces.vim is a plugin, which provides a Visual Studio Code like
workspace feature to Vim and Neovim.

You can read more about workspaces at Visual Studio Code
[docs](https://code.visualstudio.com/docs/editor/multi-root-workspaces).

## The problem

For example, you have a really huge project, that is build on huge amount of
different technologies. And you're working with only part of that technologies,
and do not require rest of files in the project. Most Vim users will open Vim at
project's root folder, or at the folder where needed files are located. But what
if you need to work with files which are located in different folders, that are
on the same level of depth? And there are too many unneded files on the same
level.

Or you need to work on current project, but you need some particular files from
another project. Or just from another location outside of your project.

## The solution

You can add these folders/files to isolated workspace. These files will be
available via symbolic links. Plugins like [NERDTree](), [CtrlP](), [Denite]()
can work with these links to search and open files. Furthermore, you can run
tools like `:grep` inside workspace, because your VIm is now running in that
folder.

## About

This plugin is created and being maintained by [@andreyorst](https://GitHub.com/andreyorst).
It is being tested against Vim 8.0, Vim 7.4.1689 and neovim 0.3.\*. Other versions
are not officially supported, but might work. If you found an issue, or want to
propose a change, you're welcome to do so at SimpleWorkspaces.vim GitHub
repository: https://github.com/andreyorst/SimpleWorkspaces.vim
