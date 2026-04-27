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
      agent = {
        default_model = {
          provider = "copilot_chat";
          model = "gpt-5.3-codex";
          enable_thinking = false;
          effort = "high";
        };
        favorite_models = [ ];
        model_parameters = [ ];
      };

      languages = {
        Nix = {
          format_on_save = "off";
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
