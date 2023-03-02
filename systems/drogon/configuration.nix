# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot = {
    kernel = {
      sysctl."kernel,sysrq" = 1;
    };

    loader = {
      timeout = 1;

      systemd-boot = {
        enable = true;
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };

    plymouth = {
      enable = true;
    };
  };

  amd-controller = {
    enable = true;

    processor = "5900HX";

    powerManagement = {
      enable = true;
    };
  };

  # Set your time zone.
  time = {
    timeZone = "Europe/Madrid";
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "es_ES.UTF-8";
      LC_IDENTIFICATION = "es_ES.UTF-8";
      LC_MEASUREMENT = "es_ES.UTF-8";
      LC_MONETARY = "es_ES.UTF-8";
      LC_NAME = "es_ES.UTF-8";
      LC_NUMERIC = "es_ES.UTF-8";
      LC_PAPER = "es_ES.UTF-8";
      LC_TELEPHONE = "es_ES.UTF-8";
      LC_TIME = "es_ES.UTF-8";
    };
  };

  networking = {
    hostName = "drogon";

    # Enable networking
    networkmanager = {
      enable = true;
    };
  };

  # Other posible configurations
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  security = {
    polkit = {
      enable = true;
    };

    # Enable the RealtimeKit system service, 
    # which hands out realtime scheduling priority to user processes on demand
    rtkit = {
      enable = true;
    };
  };


  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      autorun = true;

      displayManager = {
        gdm = {
          enable = false;
        };

        lightdm = {
          greeters = {
            enso = {
              enable = true;
            };
          };
        };

        defaultSession = "none+bspwm";
      };

      windowManager = {
        bspwm = {
          enable = true;
        };
      };

      # Configure keymap in X11
      layout = "us";
      xkbVariant = "altgr-intl";
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Bluetooth manager
    blueman = {
      enable = true;
    };

    udev = {
      packages = with pkgs; [
        pkgs.yubikey-personalization # Needed for yubikey apps
        pkgs.bazecor
      ];
    };

    cron = {
      enable = false;
    };

    # DBus service that provides location information for accessing
    geoclue2 = {
      enable = true;
    };

    # Printing support through the CUPS daemon
    printing = {
      enable = true;

      drivers = [ pkgs.hplip ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Enable PCSC-Lite daemon, needed to work with yubikey cards
    # Midelware to access a smart card using SCard API (PC/SC)
    pcscd = {
      enable = true;
    }; # Yubikey smart card mode (CCID) and OTP mode (udev)

    # Enable daemon to to take care of the user's security credentials, such as user names and passwords
    gnome = {
      gnome-keyring = {
        enable = true;
      };
    };

    # DBus service that allows applications to query and manipulate storage devices
    udisks2 = {
      enable = true;
    };

    avahi = {
      enable = true;

      openFirewall = true; # Needed for detect net printers
    };
  };

  programs = {
    # Enable system dconf and fix some servicers erros from home-manager
    dconf = {
      enable = true;
    };
  };

  # Enable sound with pipewire.
  sound = {
    enable = true;
  };

  hardware = {
    logitech = {
      wireless = {
        enable = true;

        # for solaar to be included
        enableGraphical = true;
      };
    };

    pulseaudio = {
      enable = false;

      package = pkgs.pulseaudioFull;
    };

    bluetooth = {
      enable = true;

      settings = {
        General = {
          ControllerMode = "bredr";
        };
      };
    };

    # Enable openGL drivers for x11
    opengl = {
      enable = true;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
    };

    virtualbox = {
      host = {
        enable = true;

        enableExtensionPack = true;
      };
    };
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users.ajmasia = {
      isNormalUser = true;
      description = "ajmasia";
      extraGroups = [ "networkmanager" "wheel" "docker" "input" "audio" ];
    };

    extraGroups = {
      vboxusers = {
        members = [ "ajmasia" ];
      };
    };
  };

  # Make ready for nix flakes
  nix = {
    # Flakes settings
    package = pkgs.nixVersions.stable;
    registry.nixpkgs.flake = inputs.nixpkgs;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # Nixpkgs config
  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [
      (f: p: { bazecor = inputs.bazecor-nix.packages.x86_64-linux.default; })
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # The most popular clone of the VI editor
    wget # Tool for retrieving files using HTTP, HTTPS, and FTP
    logitech-udev-rules # Linux devices manager for the Logitech Unifying Receiver
    bazecor
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
