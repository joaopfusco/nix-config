{
  flake.modules.homeManager.zedEditor = {
    programs.zed-editor = {
      enable = true;

      mutableUserSettings = false;
      mutableUserKeymaps = false;

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
        "terraform"
        "ansible"
        "proto"
      ];

      userSettings = {
        cli_default_open_behavior = "new_window";
        file_finder.include_ignored = "all";
        search.include_ignored = false;
        soft_wrap = "editor_width";
        autosave.after_delay.milliseconds = 1000;
        languages = {
          Nix.language_servers = [
            "nixd"
            "!nil"
          ];
          JSON.format_on_save = "off";
          JSONC.format_on_save = "off";
        };
        terminal.shell.program = "zsh";
        file_types."Shell Script" = [
          "envrc"
          ".envrc"
          "*.envrc"
        ];
        ui_font_family = "JetBrainsMono Nerd Font";
        ui_font_size = 16;
        buffer_font_family = "JetBrainsMono Nerd Font";
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
            "ctrl-b" = "workspace::ToggleRightDock";
            "ctrl-alt-b" = "workspace::ToggleLeftDock";
          };
        }
      ];
    };
  };
}
