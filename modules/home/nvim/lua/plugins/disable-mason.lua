-- Comment this line out to disable Mason and related auto-installers, and manage your LSP servers via Nix.
if true then return {} end

return {
  -- Nix-managed toolchain: disable Mason and related auto-installers.
  { "williamboman/mason.nvim", enabled = false },
  { "williamboman/mason-lspconfig.nvim", enabled = false },
  { "WhoIsSethDaniel/mason-tool-installer.nvim", enabled = false },
}
