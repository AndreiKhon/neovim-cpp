
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

----------------8<-------------[ cut here ]------------------

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

----------------8<-------------[ cut here ]------------------

local add = require('mini.deps').add
local now = require('mini.deps').now
local later = require('mini.deps').later

now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()
end)
now(function() require('mini.icons').setup() end)
now(function() require('mini.sessions').setup() end)
now(function() require('mini.statusline').setup() end)
now(function() require('mini.starter').setup() end)
now(function() require('mini.tabline').setup() end)


later(function() require('mini.ai').setup() end)
later(function()
  require('mini.clue').setup({
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },
      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      -- Window commands
      { mode = 'n', keys = '<C-w>' },
      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },
    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      require('mini.clue').gen_clues.builtin_completion(),
      require('mini.clue').gen_clues.g(),
      require('mini.clue').gen_clues.marks(),
      require('mini.clue').gen_clues.registers(),
      require('mini.clue').gen_clues.windows(),
      require('mini.clue').gen_clues.z(),
      { mode = 'n', keys = '<Leader>m', desc = 'Mini map' },
      { mode = 'n', keys = '<Leader>l', desc = 'Lsp' },
      { mode = 'n', keys = '<Leader>d', desc = 'Debug adapter protocol' },
    },
  })
end)
later(function() require('mini.basics').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.completion').setup() end)
later(function() require('mini.cursorword').setup() end)
later(function() require('mini.files').setup() end)
later(function() require('mini.indentscope').setup() end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.trailspace').setup() end)
later(function() require('mini.jump2d').setup() end)
later(function()
  require('mini.map').setup({
    integrations = {
      require('mini.map').gen_integration.builtin_search(),
      -- require('mini.map').gen_integration.diff(),
      require('mini.map').gen_integration.diagnostic(),
    }
  })
end)



----------------8<-------------[ cut here ]------------------

now(function()
  add({
    source = 'neovim/nvim-lspconfig',
    depends = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' },
  })
  require('mason').setup()
  require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls', 'clangd' }
  })
  require('lspconfig').lua_ls.setup({
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        }
      }
    }
  })
  require('lspconfig').clangd.setup({
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
      fallbackFlags = { '--std=c++20' }
    }
  })
end)
now(function()
  add({
    source = 'rcarriga/nvim-dap-ui',
    depends = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' }
  })
  local dap = require('dap')
  dap.adapters.gdb = {
    type = 'executable',
    command = 'gdb',
    args = { '--interpreter=dap', '--eval-command', 'set print pretty on' }
  }
  dap.configurations.cpp = {
    {
      name = 'Launch',
      type = 'gdb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopAtBeginningOfMainSubprogram = false,
    },
    {
      name = 'Select and attach to process',
      type = 'gdb',
      request = 'attach',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      pid = function()
        local name = vim.fn.input('Executable name (filter): ')
        return require('dap.utils').pick_process({ filter = name })
      end,
      cwd = '${workspaceFolder}'
    },
    {
      name = 'Attach to gdbserver :1234',
      type = 'gdb',
      request = 'attach',
      target = 'localhost:1234',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}'
    },
  }
  dap.configurations.c = dap.configurations.cpp
  local dapui = require('dapui')
  dapui.setup()
  dap.listeners.before.attach.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
  end
  dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
  end
end)
later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'master',
    monitor = 'main',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'cpp' },
    highlight = { enable = true },
  })
end)
later(function()
  add({
    source = 'HiPhish/rainbow-delimiters.nvim',
  })
end)

----------------8<-------------[ cut here ]------------------

-- Vim settings
vim.cmd.colorscheme 'minischeme'
vim.g.mapleader = ' '
vim.cmd.set 'relativenumber'
vim.cmd.set 'number'
vim.cmd.set 'tabstop=2'
vim.cmd.set 'shiftwidth=2'
vim.cmd.set 'expandtab'

----------------8<-------------[ cut here ]------------------

-- Mappings
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
-- Lsp
map('n', '<Leader>lf', vim.lsp.buf.format, { desc = 'Format file' })
map('n', '<leader>ld', vim.diagnostic.setloclist, { desc = 'Diagnostic loclist' })
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
