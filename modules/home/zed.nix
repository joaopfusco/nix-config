{ pkgs, ... }:
let
  zedPackage = pkgs.zed-editor;
  # zedPackage = pkgs.zed-editor-fhs;
  customZed = if pkgs.stdenv.isDarwin then pkgs.emptyDirectory else zedPackage;
in
{
  programs.zed-editor = {
    enable = true;
    package = customZed;

    extensions = [
      "html"
      "toml"
      "sql"
      "make"
      "csharp"
      "nix"
    ];

    userSettings = {
      languages = {
        CSharp = {
          format_on_save = "off";
          language_servers = [
            "roslyn"
            "!omnisharp"
            "..."
          ];
        };
      };

      terminal = {
        shell = {
          program = "zsh";
        };
      };

      file_types = {
        "Shell Script" = [
          "envrc"
          ".envrc"
          "*.envrc"
        ];
      };

      ui_font_size = 16;
      buffer_font_size = 15;

      theme = "One Dark";
    };

    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          "ctrl-shift-enter" = "workspace::NewTerminal";
          "ctrl-k f" = "workspace::CloseProject";
        };
      }
    ];
  };
}
