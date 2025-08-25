{ pkgs, ... }: {

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.beta = {
    isNormalUser = true;
    description = "beta";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };
}
