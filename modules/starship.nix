{ lib, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$cmd_duration"
        "$line_break"
        "\${env_var.NIXSH_ACTIVE}"
        "$nix_shell"
        "$character"
      ];

      nix_shell = {
        disabled = false;
        symbol = "";
        format = "[$symbol$state( \\($name\\))]($style) ";
      };

      git_branch = {
        symbol = "";
      };

      env_var.NIXSH_ACTIVE = {
        format = "[nix-sh( \\($env_value\\))]($style) ";
        style = "bold blue";
      };
    };
  };
}
