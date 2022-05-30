# vim-pm

A simple and minimal project manager for Vim/Neovim.

## Overview

Enter a project, open some files, etc. Then use `ProjectSave!` to save the
layout to `.vim/session.vim`.

Reopen the project with `ProjectOpen <Tab>`. Use `ProjectSave` (without a `!`)
to save the current project before quitting.

The list of projects is saved to `$HOME/.vimprojects` (Vim) or `stdpath('data') . '/projects.txt'` (Neovim).

## Mappings

Adding some mappings is recommend for a better experience:

```vim
nnoremap <Leader>po :ProjectOpen<Space>
nnoremap <silent><Leader>ps :ProjectSave<CR>
nnoremap <silent><Leader>pS :ProjectSave!<CR>
nnoremap <silent><Leader>pq :ProjectQuit<CR>
nnoremap <silent><Leader>pl :ProjectList<CR>
nnoremap <silent><Leader>pl :ProjectList<CR>
nnoremap <silent><Leader>pp :ProjectPrevious<CR>
```

Lua (Neovim):

```lua
vim.keymap.set('n', '<Leader>po', ':ProjectOpen<Space>', { silent = false })
vim.keymap.set('n', '<Leader>ps', ':ProjectSave<CR>')
vim.keymap.set('n', '<Leader>pS', ':ProjectSave!<CR>')
vim.keymap.set('n', '<Leader>pq', ':ProjectQuit<CR>')
vim.keymap.set('n', '<Leader>pl', ':ProjectList<CR>')
vim.keymap.set('n', '<Leader>pl', ':ProjectList<CR>')
vim.keymap.set('n', '<Leader>pp', ':ProjectPrevious<CR>')
```

## TODO

* Save list of projects in JSON?

## Licence

MIT license.
