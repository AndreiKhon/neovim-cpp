
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



