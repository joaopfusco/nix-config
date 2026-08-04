{ ... }:
{
  programs.zed-editor.userKeymaps = [
    {
      context = "Workspace";
      bindings = {
        "ctrl-shift-enter" = "workspace::NewTerminal";
        "ctrl-k f" = "workspace::CloseProject";
      };
    }
  ];
}
