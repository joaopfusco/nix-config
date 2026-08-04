{ ... }:
{
  programs.zed-editor.userSettings = {
    cli_default_open_behavior = "new_window";
    auto_install_extensions = {
      html = true;
      toml = true;
      sql = true;
      make = true;
      nix = true;
      csharp = true;
      docker = true;
      dockerfile = true;
      git-firefly = true;
      material-icon-theme = true;
      terraform = true;
      ansible = true;
      proto = true;
    };
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
}