

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

later(function()
  add({
    source = 'Shatur/neovim-tasks',
    depends = { 'nvim-lua/plenary.nvim' }
  })
  local Path = require('plenary.path')
  require('tasks').setup({
    default_params = {                                                       -- Default module parameters with which `neovim.json` will be created.
      cmake = {
        cmd = 'cmake',                                                       -- CMake executable to use, can be changed using `:Task set_module_param cmake cmd`.
        build_dir = tostring(Path:new('{cwd}', 'build', '{os}-{build_type}')), -- Build directory. The expressions `{cwd}`, `{os}` and `{build_type}` will be expanded with the corresponding text values. Could be a function that return the path to the build directory.
        build_type = 'Debug',                                                -- Build type, can be changed using `:Task set_module_param cmake build_type`.
        dap_name = 'gdb',                                                   -- DAP configuration name from `require('dap').configurations`. If there is no such configuration, a new one with this name as `type` will be created.
        args = {                                                             -- Task default arguments.
          configure = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1', '-G', 'Ninja' },
        },
      },
    },
    save_before_run = true,                                           -- If true, all files will be saved before executing a task.
    params_file = 'neovim.json',                                      -- JSON file to store module and task parameters.
    quickfix = {
      pos = 'botright',                                               -- Default quickfix position.
      height = 12,                                                    -- Default height.
    },
    dap_open_command = function() return require('dap').continue() end -- Command to run after starting DAP session. You can set it to `false` if you don't want to open anything or `require('dapui').open` if you are using https://github.com/rcarriga/nvim-dap-ui
  })
end)
