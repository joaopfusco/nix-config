{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pyright
    typescript-language-server
    gopls
    rust-analyzer
    # csharp-ls -> dotnet tool install --global csharp-ls
  ];
}
