local map = vim.keymap.set
-- File manager
map('n', '<Leader>e', require('mini.files').open, { desc = 'File manager' })
-- Buffer manipulation
map('n', '<Tab>', '<cmd>bnext<CR>', {})
map('n', '<S-Tab>', '<cmd>bprev<CR>', {})
map('n', '<Leader>q', '<cmd>bdelete<CR>', { desc = 'Close current buffer' })
map('n', '<C-//>', '<cmd>noh<CR>', { desc = 'Clear highlight' })
-- Mini map
map('n', '<Leader>mc', require('mini.map').close, { desc = 'Close' })
map('n', '<Leader>mf', require('mini.map').toggle_focus, { desc = 'Focus' })
map('n', '<Leader>mo', require('mini.map').open, { desc = 'Open' })
map('n', '<Leader>mr', require('mini.map').refresh, { desc = 'Refresh' })
map('n', '<Leader>ms', require('mini.map').toggle_side, { desc = 'Toggle side' })
map('n', '<Leader>mt', require('mini.map').toggle, { desc = 'Toggle' })
-- Mini pick
map('n', '<Leader>ff', require('mini.pick').builtin.files, { desc = 'Files' })
map('n', '<Leader>fb', require('mini.pick').builtin.buffers, { desc = 'Buffers' })
map('n', '<Leader>fg', require('mini.pick').builtin.grep_live, { desc = 'Grep live' })
map('n', '<Leader>fr', require('mini.pick').builtin.resume, { desc = 'Resume' })
map('n', '<Leader>fh', require('mini.pick').builtin.help, { desc = 'Help' })
-- Lsp
map('n', '<Leader>lf', vim.lsp.buf.format, { desc = 'Format file' })
map('n', '<leader>ld', vim.diagnostic.setloclist, { desc = 'Diagnostic loclist' })
map('n', '<leader>lt', vim.lsp.buf.type_definition, { desc = 'Go to Type declaration' })
map('n', '<leader>ls', vim.lsp.buf.signature_help, { desc = 'Show signature help' })
map('n', '<leader>lr', vim.lsp.buf.references, { desc = 'Show references' })
map({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, { desc = 'Code action' })
map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to Declaration' })
map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to Definition' })
map('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to Implementation' })
-- Dap
map('n', '<F5>', require('dap').continue, { desc = 'Continue' })
map('n', '<F8>', require('dap').step_over, { desc = 'Step over' })
map('n', '<F9>', require('dap').step_into, { desc = 'Step into' })
map('n', '<F10>', require('dap').step_out, { desc = 'Step out' })
map('n', '<Leader>db', require('dap').toggle_breakpoint, { desc = 'Toggle breakpoint' })
map('n', '<Leader>dB', require('dap').set_breakpoint, { desc = 'Set breakpoint' })
map('n', '<Leader>dm', function()
  require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end, { desc = 'Set breakpoint with log point message' })
map('n', '<Leader>dr', require('dap').repl.open, { desc = 'Repl open' })
map('n', '<Leader>dl', require('dap').run_last, { desc = 'Run last' })
map({ 'n', 'v' }, '<Leader>dh', require('dap.ui.widgets').hover, { desc = 'Widgets hover' })
map({ 'n', 'v' }, '<Leader>dp', require('dap.ui.widgets').preview, { desc = 'Widgets preview' })
map('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end, { desc = 'Widgets centered float frames' })
map('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end, { desc = 'Widget centered float scopes' })
-- Headerguard
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' },
  {
    pattern = { '*.h', '*.hpp' },
    callback = function(event)
      map('n', '<Leader>h', '<cmd>HeaderguardAdd<CR>',
        { desc = 'Add Header guard', buffer = event.buf })
    end,
  })
