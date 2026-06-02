{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    # mutableUserSettings = false; # only nix can modify
    # mutableUserKeymaps = false; # only nix can modify
    package = pkgs.emptyDirectory;

    extensions = [
      "html"
      "toml"
      "sql"
      "make"
      "nix"
      "csharp"
      "docker"
      "dockerfile"
      "git-firefly"
      "material-icon-theme"
    ];

    userSettings = {
      file_finder = {
        include_ignored = "all";
      };

      search = {
        include_ignored = true;
      };

      soft_wrap = "editor_width";

      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };

      languages = {
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
        };
        JSON = {
          format_on_save = "off";
        };
        JSONC = {
          format_on_save = "off";
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
      icon_theme = "Material Icon Theme";
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
