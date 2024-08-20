

local add = require('mini.deps').add
local now = require('mini.deps').now
local later = require('mini.deps').later

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


