{ ... }:

{
  # Enable virtualization guest tools and services
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
