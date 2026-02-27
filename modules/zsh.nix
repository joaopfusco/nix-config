{ config, pkgs, ... }:

{
  # Bluefin: chsh -s $(which zsh) # nao executar no host, apenas na distobox

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      cls = "clear";
      home-update = "home-manager switch --flake .#joaop";
      vm-status = "systemctl status libvirtd";
      vm-start = "sudo systemctl start libvirtd";
      vm-stop = "sudo systemctl stop 'libvirtd*'";
    };

    initContent = ''
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" ];
      theme = "robbyrussell";
    };
  };
}
