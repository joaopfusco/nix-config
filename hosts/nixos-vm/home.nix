{ config, pkgs, lib, ... }:

{
  imports = [
    ../../modules/home/pkgs/cli.nix
    ../../modules/home/pkgs/gui.nix
    ../../modules/home/git.nix
    ../../modules/home/zsh.nix
    ../../modules/home/direnv.nix
    ../../modules/home/kitty.nix
    ../../modules/home/nixvim.nix
    ../../modules/home/dotnet/complete.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    
    # Aqui você escreve a configuração do Hyprland em formato Nix
    settings = {
      # Configuração para a VM (Resolução e Taxa de Atualização)
      monitor = [
        "Virtual-1, 1920x1080@60, 0x0, 1"
      ];

      # Variáveis de ambiente específicas para rodar em VM
      env = [
        "WLR_NO_HARDWARE_CURSORS, 1"
        "WLR_RENDERER_ALLOW_SOFTWARE, 1"
      ];

      # Configurações gerais
      input = {
        kb_layout = "br"; # Teclado ABNT2
        follow_mouse = 1;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        # Desativar blur na VM se ficar lento
        blur = {
          enabled = false;
        };
      };

      # Atalhos de teclado (Exemplos)
      "$mainMod" = "SUPER";
      bind = [
        "$mainMod, Q, exec, kitty"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, dolphin"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, wofi --show drun"
        
        # Mover foco com mainMod + setas
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
      ];
    };
  };

  # Ignoring any other definition and using this one
  # home.stateVersion = lib.mkForce "26.05";
}
