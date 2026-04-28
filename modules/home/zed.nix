{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    # package = pkgs.zed-editor-fhs;

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
        Nix = {
          format_on_save = "off";
        };
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
        "Shell Script" = [ "envrc" ".envrc" "*.envrc" ];
      };

      ui_font_size = 16;
      buffer_font_size = 15;

      theme = {
        mode = "system";
        light = "One Light";
        dark = "One Dark";
      };
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
