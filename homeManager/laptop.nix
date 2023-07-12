{ pkgs, ... }:

{
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
      ];
    })
    btop

    # used for sway
    waybar
    swaylock
    swayidle
    wl-clipboard
    brightnessctl
    wofi
    swaybg
    wlsunset
    xss-lock
    wob
    mako
    wlogout
    pavucontrol
    networkmanagerapplet
    clipman
    sway-contrib.grimshot
    pulseaudio


    # latex
    texlive.combined.scheme-full


    # nvim
    neovim

    # apps
    telegram-desktop
    dropbox
    keepassxc
    # spotify
    firefox
    librewolf
    gnome.nautilus
    zathura
    tmux

    # ssh and gpg manager
    gnome.seahorse

    # utils
    git

    # node
    # nodePackages_latest.nodejs
    nodejs_20

    # c complier
    gccgo

    # terminal emulator
    alacritty

    # gpg
    gnupg


    # neovim
    unzip
    wget
    cargo
    php

    python311Packages.pip
    python311
    ripgrep
    fd
    tree-sitter  


  ];



  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
}
