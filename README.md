# vim-pm

A simple and minimal project and session manager for Neovim.

## Overview

Enter a project, open some files, etc. Then use `Project! save` to save the
layout to `.vim/session.vim`.

Reopen the project with `Project open <Tab>`. Use `Project! save` (without a `!`)
to save the current project before quitting.

The list of projects is saved to `stdpath('data') . '/projects.txt'`.

## Mappings

Adding some mappings is recommend for a better experience:

```vim
nnoremap <Leader>po :Project open<Space>
nnoremap <silent><Leader>ps :Project save<CR>
nnoremap <silent><Leader>pS :Project save!<CR>
nnoremap <silent><Leader>pq :Project quit<CR>
nnoremap <silent><Leader>pl :Project list<CR>
nnoremap <silent><Leader>pp :Project previous<CR>
nnoremap <silent><Leader>pp :Project edit-list<CR>
```

Lua:

```lua
vim.keymap.set('n', '<Leader>po', ':Project open<Space>', { silent = false })
vim.keymap.set('n', '<Leader>ps', ':Project save<CR>')
vim.keymap.set('n', '<Leader>pS', ':Project save!<CR>')
vim.keymap.set('n', '<Leader>pq', ':Project quit<CR>')
vim.keymap.set('n', '<Leader>pl', ':Project list<CR>')
vim.keymap.set('n', '<Leader>pp', ':Project previous<CR>')
vim.keymap.set('n', '<Leader>pp', ':Project edit-list<CR>')
```

## Licence

MIT license.
