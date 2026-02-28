{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "joaopfusco";
        email = "joaopedrofusco@gmail.com";
      };
    };
    credential = {
      helper = "store";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "github.com gitlab.com" = {
        identityFile = "~/.ssh/id_ed25519";
        user = "git";
        addKeysToAgent = "yes";
        forwardAgent = false;
      };
    };
  };

  services.ssh-agent.enable = true;
}