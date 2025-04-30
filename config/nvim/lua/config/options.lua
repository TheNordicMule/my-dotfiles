local opt = vim.opt

-- tab
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- compatible mode
-- opt.compatible = false

-- term gui color
opt.termguicolors = true

-- Do not do Wrap
opt.wrap = false

-- Syntax highlighting
-- opt.syntax = 'on'

-- Disable the default Vim startup message.
-- opt.shortmess:append({ I = true })

-- Show line numbers.
opt.number = true

-- This enables relative line numbering mode. With both number and
-- relativenumber enabled, the current line shows the true line number, while
-- all other lines (above and below) are numbered relative to the current line.
-- This is useful because you can tell, at a glance, what count is needed to
-- jump up or down to a particular line, by {count}k to go up or {count}j to go
-- down.
opt.relativenumber = true

-- Always show the status line at the bottom, even if you only have one window open.
opt.laststatus = 3

-- The backspace key has slightly unintuitive behavior by default. For example,
-- by default, you can't backspace before the insertion point opt.with 'i'.
-- This configuration makes backspace behave more reasonably, in that you can
-- backspace over anything.
-- opt.backspace:append({indent,eol,start})

-- By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
-- shown in any window) that has unsaved changes. This is to prevent you from "
-- forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
-- hidden buffers helpful enough to disable this protection. See `:help hidden`
-- for more information on this.
-- opt.hidden = true

-- This setting makes search case-insensitive when all characters in the string
-- being searched are lowercase. However, the search becomes case-sensitive if
-- it contains any capital letters. This makes searching more convenient.
opt.ignorecase = true
opt.smartcase = true

-- Enable searching as you type, rather than waiting till you press enter.
-- opt.incsearch = true

-- Disable audible bell because it's annoying.
-- opt.errorbells=false
-- opt.visualbell=false
-- opt.t_vb=false

-- Enable mouse support. You should avoid relying on this too much, but it can
-- sometimes be convenient.
-- opt.mouse.append({a = true}
opt.mouse:append("a")

-- custom
opt.swapfile = false
opt.undofile = true

-- setpath to be all
opt.path:append("**")
opt.wildignore:append("**/node_modules/**", ".git**")

-- enlarge history
-- opt.history = 100
-- change update time
opt.updatetime = 300

-- change fold method
opt.foldmethod = "indent"
opt.foldlevelstart = 999

-- inccomand preview
opt.inccommand = "split"

-- show the line you are on
opt.cursorline = true
