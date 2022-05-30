" File: project.vim
" Description: functions, commands and mappings for managing projects.

if has('nvim')
    let s:project_file = stdpath('data') . '/projects.txt'
else
    " TODO: figure out a better/more convenient location
    let s:project_file = $HOME . '/.vimprojects'
endif

function! s:WriteProjectList(new_project) abort
    let project_list = s:ReadProjectList()
    let new_list = []
    for project in project_list
        if project !=# a:new_project
            call add(new_list, project)
        endif
    endfor
    call add(new_list, a:new_project)
    call writefile(new_list, s:project_file)
endfunction

function! s:ReadProjectList() abort
    if filereadable(s:project_file)
        let project_list = readfile(s:project_file)
    else
        let project_list = []
    endif
    return filter(project_list, 'isdirectory(v:val)')
endfunction

function! s:OpenProjec(path) abort
    let project_path = fnamemodify(a:path, ':p')
    let session_file = project_path . '.vim/session.vim'
    if isdirectory(project_path) && filereadable(session_file)
        %bdelete!
        silent execute 'cd' project_path
        silent execute 'source' session_file
        call s:WriteProjectList(project_path)
    else
        echoerr 'Project session does not exist:' session_file
        return
    endif
    let s:project_info = {
                \ 'session_file': session_file,
                \ 'project_path': project_path
                \}
    doautocmd User ProjectOpen
endfunction

function! s:SaveProject(bang) abort
    if a:bang
        let project_path = fnamemodify(getcwd(), ':p')
        silent! call mkdir('.vim', project_path)
        let session_file = project_path . '.vim/session.vim'
    elseif has_key(s:, 'project_info')
        let session_file = s:project_info['session_file']
        let project_path = s:project_info['project_path']
    else
        echoerr 'Not in a project!'
        return
    endif
    execute 'mksession!' session_file
    call s:WriteProjectList(project_path)
    let s:project_info = {
                \ 'session_file': session_file,
                \ 'project_path': project_path
                \}
    echom 'Project' project_path 'saved to' session_file
endfunction

function! s:ListProjects() abort
    let project_list = uniq(sort(s:ReadProjectList()))
    let input_list = map(copy(project_list), {i, item -> i + 1 . '. ' . item })
    call insert(input_list, 'Projects:')
    let result = inputlist(input_list) - 1
    if result >= 0 && result < len(project_list)
        call s:OpenProjec(project_list[result])
    endif
endfunction

function! s:OpenPreviousProject() abort
    let project_list = s:ReadProjectList()
    if len(project_list) > 0
        call s:OpenProjec(project_list[-1])
    else
        echoerr "No project to open"
    endif
endfunction

function! s:CompleteProjects(lead, cmdline, cursorpos) abort
    let project_list = reverse(s:ReadProjectList())
    return filter(project_list, 'v:val =~# a:lead')
endfunction

command! -complete=customlist,<sid>CompleteProjects -nargs=1 ProjectOpen call s:OpenProjec(<q-args>)
command! -bang ProjectSave call s:SaveProject(<bang>0)
command! -bang ProjectQuit call s:SaveProject(<bang>0) | qa!
command! ProjectList call s:ListProjects()
command! ProjectPrevious call s:OpenPreviousProject()

nnoremap <Leader>po :ProjectOpen<Space>
nnoremap <silent><Leader>ps :ProjectSave<CR>
nnoremap <silent><Leader>pS :ProjectSave!<CR>
nnoremap <silent><Leader>pq :ProjectQuit<CR>
nnoremap <silent><Leader>pl :ProjectList<CR>
nnoremap <silent><Leader>pl :ProjectList<CR>
nnoremap <silent><Leader>pp :ProjectPrevious<CR>
