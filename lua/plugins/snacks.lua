return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    cond = function()
      -- Optional: Add a condition for loading
      return not vim.g.started_by_firenvim
    end,
    keys = {
      {
        "<leader><leader>",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fw",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      -- find
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.git_files()
        end,
        desc = "Find Git Files",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent",
      },
      -- git
      {
        "<leader>gc",
        function()
          Snacks.picker.git_log()
        end,
        desc = "Git Log",
      },
      {
        "<leader>gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git Status",
      },
      -- Grep
      {
        "<leader>sw",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Visual selection or word",
        mode = { "n", "x" },
      },
      -- search
      {
        "<leader>fd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>fk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>fq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        "<leader>ft",
        function()
          Snacks.picker.colorschemes({ layout = "ivy" })
        end,
        desc = "Colorschemes",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
      -- LSP
      {
        "gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "Goto Definition",
      },
      {
        "gr",
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = "References",
      },
      {
        "gI",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "Goto Implementation",
      },
      {
        "gy",
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = "Goto Type Definition",
      },
      {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP Symbols",
      },
      -- Other
      {
        "<leader>gg",
        function()
          if vim.fn.executable("lazygit") == 1 then
            Snacks.lazygit()
          else
            Snacks.notify.warn("lazygit not found on PATH")
          end
        end,
        desc = "Lazygit",
      },

      -- Notifications history
      {
        "<leader>nn",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notifier history",
      },

      -- Open current line / selection in the browser (GitHub/GitLab)
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse (open in browser)", mode = { "n", "x" } },

      -- Floating terminal toggle
      { "<c-/>",      function() Snacks.terminal() end,  desc = "Toggle Terminal" },
      { "<leader>tt", function() Snacks.terminal() end,  desc = "Toggle Terminal" },

      -- Smart buffer delete (keeps window layout)
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },

      -- Diagnostics / lists (<leader>x group) — replaces trouble.nvim.
      { "<leader>xw", function() Snacks.picker.diagnostics() end, desc = "Workspace diagnostics" },
      { "<leader>xd", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer diagnostics" },
      { "<leader>xq", function() Snacks.picker.qflist() end, desc = "Quickfix list" },
      { "<leader>xl", function() Snacks.picker.loclist() end, desc = "Location list" },
    },
    opts = {
      -- Auto-enabled modules (event-driven). Listed here so snacks sets
      -- `enabled = true` for them (snacks only enables keys present in opts).
      bigfile = { enabled = true }, -- disable heavy features on huge files
      scope = { enabled = true },   -- highlight the current treesitter/LSP scope
      words = { enabled = true },   -- LSP reference highlight of word under cursor
      input = { enabled = true },   -- nicer vim.ui.input
      select = { enabled = true },  -- nicer vim.ui.select
      -- Manually-invoked modules (loaded on access, listed for clarity):
      gitbrowse = { enabled = true },
      terminal = { enabled = true },
      bufdelete = { enabled = true },
      zen = { enabled = true },
      picker = {
        enabled = true,
        layout = {
          -- presets options : "default" , "ivy" , "ivy-split" , "telescope" , "vscode", "select" , "sidebar"
          cycle = false,
        },
        files = {
          -- `exclude` is read directly by snacks.picker (not nested under `find_args`).
          exclude = { ".git", "node_modules", "__pycache__" },
        },
      },
      notifier = {
        enabled = true,
        style = "compact", -- "compact" uses less space
        top_down = true,   -- Notifications appear from top to bottom
      },
      dashboard = {
        enabled = true,
        width = 60,
        row = nil,                                                                   -- dashboard position. nil for center
        col = nil,                                                                   -- dashboard position. nil for center
        pane_gap = 4,                                                                -- empty columns between vertical panes
        autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
        -- These settings are used by some built-in sections
        preset = {
          -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
          ---@type fun(cmd:string, opts:table)|nil
          pick = nil,
          -- Used by the `keys` section to show keymaps.
          -- Set your custom keymaps here.
          -- When using a function, the `items` argument are the default keymaps.
          keys = {
            {
              icon = " ",
              key = "f",
              desc = "Find File",
              action = ":lua Snacks.picker.files()",
            },
            -- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            {
              icon = " ",
              key = "g",
              desc = "Find Text",
              action = ":lua Snacks.dashboard.pick('live_grep')",
            },
            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = ":lua Snacks.dashboard.pick('oldfiles')",
            },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            {
              icon = "󰒲 ",
              key = "l",
              desc = "Lazy",
              action = ":Lazy",
              enabled = package.loaded.lazy ~= nil,
            },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          -- Used by the `header` section
          header = [[
██╗   ██╗██╗  ██╗██╗   ██╗███████╗██████╗ ███╗   ███╗ █████╗
██║   ██║██║ ██╔╝██║   ██║██╔════╝██╔══██╗████╗ ████║██╔══██╗
██║   ██║█████╔╝ ██║   ██║█████╗  ██████╔╝██╔████╔██║███████║
╚██╗ ██╔╝██╔═██╗ ╚██╗ ██╔╝██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══██║
 ╚████╔╝ ██║  ██╗ ╚████╔╝ ███████╗██║  ██║██║ ╚═╝ ██║██║  ██║
  ╚═══╝  ╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝
                      ]],
        },
        -- item field formatters
        formats = {
          icon = function(item)
            if item.file and (item.icon == "file" or item.icon == "directory") then
              local ok, icon = pcall(Snacks.util.icon, item.file, item.icon)
              if ok and icon then
                return { icon, width = 2, hl = "icon" }
              end
            end
            return { item.icon, width = 2, hl = "icon" }
          end,
          footer = { "%s", align = "center" },
          header = { "%s", align = "center" },
          file = function(item, ctx)
            -- Normalize to forward slashes so the dir/file split works on Windows too.
            local fname = vim.fn.fnamemodify(item.file, ":~"):gsub("\\", "/")
            fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
            if #fname > ctx.width then
              local dir = vim.fn.fnamemodify(fname, ":h")
              local file = vim.fn.fnamemodify(fname, ":t")
              if dir and file then
                file = file:sub(-(ctx.width - #dir - 2))
                fname = dir .. "/…" .. file
              end
            end
            local dir, file = fname:match("^(.*)/(.+)$")
            return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } }
                or { { fname, hl = "file" } }
          end,
        },
        sections = {
          { section = "header" },
          { section = "keys",   gap = 1, padding = 1 },
          { section = "startup" },
          { section = "session" }, -- Add this if you have session functionality
        },
      },
      indent = {
        enabled = true,
        char = "▏",
        animate = {
          enabled = false,
        },
      },
      scroll = { enabled = true },
      lazygit = {
        enabled = vim.fn.executable("lazygit") == 1,
      },
      toggle = {
        enabled = true,
        map = vim.keymap.set,
        which_key = true, -- integrate with which-key to show enabled/disabled icons and colors
        notify = true,
      },
    },
  },
}
