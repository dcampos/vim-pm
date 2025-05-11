local M = {
    project_file = vim.fn.stdpath('data') .. '/projects.txt',
    session_file = nil,
    project_path = nil
}

local function read_project_list()
    if vim.fn.filereadable(M.project_file) == 1 then
        local project_list = vim.fn.readfile(M.project_file)
        return vim.iter(project_list):filter(function(val) return vim.fn.isdirectory(val) == 1 end):totable()
    else
        return {}
    end
end

local function write_project_list(new_project)
    local project_list = read_project_list()
    local new_list = vim.tbl_filter(function(project) return project ~= new_project end, project_list)
    table.insert(new_list, new_project)
    vim.fn.writefile(new_list, M.project_file)
end

function M.open_project(path)
    local project_path = vim.fn.fnamemodify(path, ':p')
    local session_file = project_path .. '.vim/session.vim'
    if vim.fn.isdirectory(project_path) == 1 and vim.fn.filereadable(session_file) == 1 then
        vim.cmd('bdelete!')
        vim.cmd('silent cd ' .. project_path)
        vim.cmd('silent source ' .. session_file)
        write_project_list(project_path)
    else
        vim.api.nvim_err_writeln('Project session does not exist: ' .. session_file)
        return
    end
    M.session_file = session_file
    M.project_path = project_path
    vim.cmd('doautocmd User ProjectOpen')
end

function M.save_project(bang)
    local project_path, session_file
    if bang then
        project_path = vim.fn.getcwd()
        pcall(vim.fn.mkdir, project_path)
        session_file = project_path .. '/.vim/session.vim'
    elseif M.project_path and M.session_file then
        session_file = M.session_file
        project_path = M.project_path
    else
        print('Not in a project!')
        return
    end
    vim.cmd('mksession! ' .. session_file)
    write_project_list(project_path)
    M.session_file = session_file
    M.project_path = project_path
    print('Project ' .. project_path .. ' saved to ' .. session_file)
end

function M.list_projects()
    local project_list = vim.fn.reverse(read_project_list())
    vim.ui.select(project_list, { prompt = 'Projects list' }, function (item)
        M.open_project(item)
    end)
end

function M.open_previous()
    local project_list = read_project_list()
    if #project_list > 0 then
        M.open_project(project_list[#project_list])
    else
        print('No project to open')
    end
end

function M.edit_list(mods)
    vim.cmd(mods .. ' split ' .. M.project_file)
end

function M.complete_command(cmdline, cursorpos)
    local subcmds = { 'open', 'save', 'list', 'previous', 'edit-list', 'quit' }
    local project_list = vim.fn.reverse(read_project_list())

    local args = vim.fn.matchstr(cmdline:sub(1, cursorpos), 'P\\%[roject][! ] *\\zs.*')

    local parts = vim.split(args, '%s+')

    local values = {}
    local word = nil

    if #parts == 1 then
        values = subcmds
        word = '^' .. parts[1]
    elseif #parts == 2 then
        values = project_list
        word = parts[2]
    end

    return vim.tbl_filter(function(s) return s:match(word) end, values)
end

function M.run_command(opts)
    local subcommand = opts.fargs[1]
    if subcommand == 'open' then
        M.open_project(opts.fargs[2])
    elseif subcommand == 'save' then
        M.save_project(opts.bang and true or false)
    elseif subcommand == 'quit' then
        M.save_project(opts.bang and true or false)
        vim.cmd('qa!')
    elseif subcommand == 'list' then
        M.list_projects()
    elseif subcommand == 'previous' then
        M.open_previous()
    elseif subcommand == 'edit-list' then
        M.edit_list(opts.mods)
    else
        print("Unknown subcommand: '" .. subcommand .. "'")
    end
end

return M
