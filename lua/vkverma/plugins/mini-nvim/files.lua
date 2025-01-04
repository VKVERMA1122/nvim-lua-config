return {
    'echasnovski/mini.files',
    version = '*',
    keys = {
        { "<leader>e", ":lua MiniFiles.open()<cr> ", desc = "Open filexplorer" },
    },
    opts = {
        windows = {
            preview = false,    -- Enable file preview
            width_focus = 30,   -- Width of focused window
            width_nofocus = 20, -- Width of non-focused windows
        },
        options = {
            permanent_delete = false,       -- Safer file deletion
            use_as_default_explorer = true, -- Replace netrw
        },
    }
}
