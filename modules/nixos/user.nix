{ config, username, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Joao Pedro Fusco";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "kvm" "dialout" ];
  };
}
