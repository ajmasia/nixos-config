{ pkgs, ... }: {

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.beta = {
    isNormalUser = true;
    description = "beta";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPongEmm1bHSAJeEmPaRkMZBSdnBKAtVXM9k8TMxJDw/"
    ];
  };
}
