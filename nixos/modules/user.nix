{
  username,
  pkgs,
  ...
}:

{
  # zsh needs to be enabled at the system level to be a valid login shell
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.${username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Joao Pedro Fusco";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "libvirtd"
      "kvm"
      "dialout"
    ];
  };
}
