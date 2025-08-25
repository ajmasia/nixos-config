{ pkgs, ... }: {

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.syrax = {
    isNormalUser = true;
    description = "syrax";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };
}
