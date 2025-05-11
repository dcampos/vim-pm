local function complete(_, cmdline, cursorpos)
    return require('pm').complete_command(cmdline, cursorpos)
end

local function run(opts)
    require('pm').run_command(opts)
end

vim.api.nvim_create_user_command('Project', run, { nargs = '+', bang = true, complete = complete })
