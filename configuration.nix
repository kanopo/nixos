# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      grub = {
        enable = true;
	device = "nodev";
	efiSupport = true;
	useOSProber = false;
      };
      efi = {
        canTouchEfiVariables = true;
	efiSysMountPoint = "/boot";
      };
    };
  };

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-47f89504-990e-4bd6-8e5e-d9aa23a9c259".device = "/dev/disk/by-uuid/47f89504-990e-4bd6-8e5e-d9aa23a9c259";
  boot.initrd.luks.devices."luks-47f89504-990e-4bd6-8e5e-d9aa23a9c259".keyFile = "/crypto_keyfile.bin";

  # Define your hostname.
  networking.hostName = "laptop";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  services = {
    xserver = {
      enable = true;
      layout = "it";
      displayManager = {
        gdm.enable = true;
      };
      videoDrivers = [
        "intel"
      ];
      libinput = {
        enable = true;
	touchpad.tapping = true;
      };
    };
    blueman.enable = true;
    printing.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    undervolt = {
      enable = false;
      gpuOffset = 0;
      coreOffset = 0;
      analogioOffset = 0;
    };
    gnome.gnome-keyring.enable = true;
    tlp = {
      enable = true;
    };
  };

  hardware.bluetooth.enable = true;

  # Configure console keymap
  console.keyMap = "it";

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  users.users.me = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Dmitri Ollari Ischimji";
    extraGroups = [ "networkmanager" "wheel" "video" "docker" ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    sway
    wayland
    intel-gpu-tools
    intel-media-driver
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    
  };


  programs = {
    zsh.enable = true;
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
        export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
      '';
    };
    gnupg.agent = {
      enable = true;
    };
  };

  qt = {
    platformTheme = "gtk2";
    style = "gtk2";
    enable = true;
  };

  security = {
    pam = {
      services.gdm.enableGnomeKeyring = true;
    };
    sudo = {
      wheelNeedsPassword = false;
    };
    polkit = {
      enable = true;
    };
  };

  xdg = {
    portal = {
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.stateVersion = "23.05"; # Did you read the comment?

}
