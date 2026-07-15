-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Mirrors the VS Code terminal binding (workbench.action.terminal.sendSequence,
-- which sends an ESC followed by CR): send a literal newline instead of
-- submitting, e.g. for multi-line input in the Claude Code CLI or REPLs
-- where <CR> alone submits.
vim.keymap.set("t", "<S-CR>", function()
  local chan = vim.b.terminal_job_id
  if chan then
    vim.fn.chansend(chan, "\27\r")
  end
end, { desc = "Send literal newline to terminal" })

-- Shift+Arrows: extend selection like VS Code.
-- Note: unlike VS Code, entering the selection drops you into Visual mode;
-- from Insert mode this exits Insert first (Vim has no mode-less selection).
vim.keymap.set("n", "<S-Up>", "v<Up>", { desc = "Select up" })
vim.keymap.set("n", "<S-Down>", "v<Down>", { desc = "Select down" })
vim.keymap.set("n", "<S-Left>", "v<Left>", { desc = "Select left" })
vim.keymap.set("n", "<S-Right>", "v<Right>", { desc = "Select right" })
vim.keymap.set("v", "<S-Up>", "<Up>", { desc = "Extend selection up" })
vim.keymap.set("v", "<S-Down>", "<Down>", { desc = "Extend selection down" })
vim.keymap.set("v", "<S-Left>", "<Left>", { desc = "Extend selection left" })
vim.keymap.set("v", "<S-Right>", "<Right>", { desc = "Extend selection right" })
vim.keymap.set("i", "<S-Up>", "<Esc>v<Up>", { desc = "Select up" })
vim.keymap.set("i", "<S-Down>", "<Esc>v<Down>", { desc = "Select down" })
vim.keymap.set("i", "<S-Left>", "<Esc>v<Left>", { desc = "Select left" })
vim.keymap.set("i", "<S-Right>", "<Esc>v<Right>", { desc = "Select right" })

-- Opt+Left/Right: move cursor by word, like VS Code.
-- Requires the terminal to forward Option as Meta/Esc+ (e.g. iTerm2:
-- Profiles > Keys > Left/Right Option Key = "Esc+"); Terminal.app and most
-- modern terminals (kitty, WezTerm, Ghostty) do this by default.
vim.keymap.set({ "n", "v" }, "<M-Right>", "w", { desc = "Move word right" })
vim.keymap.set({ "n", "v" }, "<M-Left>", "b", { desc = "Move word left" })
vim.keymap.set("i", "<M-Right>", "<C-o>w", { desc = "Move word right" })
vim.keymap.set("i", "<M-Left>", "<C-o>b", { desc = "Move word left" })

-- Opt+Up/Down: move line/selection, like VS Code.
-- Implemented via the mini.move plugin (see lua/plugins/mini-move.lua).

-- Toggle the eslint LSP client on/off for the session (e.g. when its
-- diagnostics/fallback config are getting in the way), alongside LazyVim's
-- other <leader>u* toggles.
Snacks.toggle({
  name = "Eslint",
  get = function()
    return vim.lsp.is_enabled("eslint")
  end,
  set = function(state)
    vim.lsp.enable("eslint", state)
  end,
}):map("<leader>ue")
