
# ===================
# packages
# ===================
  environment.systemPackages = with pkgs; [
    # Editors
    vim
    mousepad
    neovim
    xpad

    # Terminal & System Tools
    kitty
    foot
    fastfetch
    btop
    htop
    lm_sensors
    git
    jq
    wget
    rsync
    libnotify
    bc
    socat
    cmatrix
    tty-clock

    # Hyprland & Wayland
    hyprland
    waybar
    hyprpicker
    hypridle
    hyprlock
    hyprpolkitagent
    #hyprlandPlugins
    hyprlandPlugins.hyprexpo
    swww
    rofi
    wlogout
    uwsm
    grim
    grimblast
    slurp
    swappy
    cliphist
    pywal
    wl-clipboard
    xdg-user-dirs
    nwg-displays
    networkmanagerapplet
    playerctl
    pamixer
    (stdenv.mkDerivation {
      pname = "momoisay";
      version = "main";

      src = fetchFromGitHub {
        owner = "Mon4sm";
        repo = "Momoisay";
        rev = "main";
        sha256 = "sha256-9exrPLoroOiSa6SD6LRjlYo7+uuDTFCbxQcXmLaX2JI=";
      };

      # Tambahkan ini biar compiler nemu library ncurses
      nativeBuildInputs = [ gnumake gcc ];
      buildInputs = [ ncurses ];

      installPhase = ''
        mkdir -p $out/bin
        cp momoisay $out/bin/
      '';
    })

    # network
    vnstat

    # Notifications
    swaynotificationcenter

    # File Manager
    thunar
    thunar-archive-plugin
    thunar-volman
    webp-pixbuf-loader # Opsional: Agar file .webp muncul
    libheif            # Opsional: Agar file .heic muncul
    xfce4-exo

    # Browsers & Media
    mpv
    yt-dlp
    haruna
    vokoscreen-ng
    ffmpeg

    # Audio & Bluetooth
    pavucontrol
    blueman
    cava


    # Theming
    adw-gtk3
    nwg-look
    matugen
    zenity
    tela-icon-theme
    bibata-cursors

    # Fonts
    jetbrains-mono
    font-awesome

  ];


# ===================
# System Configuration
# ===================

  security.polkit.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
  thunar-archive-plugin
  thunar-volman
  tumbler
];
    services.tumbler.enable = true;
  services.vnstat.enable = true;


  programs = {
    hyprland = {
      enable = true;

      xwayland.enable = true;
      withUWSM = true;
    };
    nm-applet.enable = true;
  };


# ===================
# Font Configuration
# ===================

  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    noto-fonts
    #noto-fonts-emoji
    # Nerd Fonts (Penting untuk simbol di Waybar/Terminal)
    nerd-fonts.jetbrains-mono
  ];

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ 
    #pkgs.xdg-desktop-portal-gtk 
    pkgs.xdg-desktop-portal-hyprland
    ];
    config.common.default = "*";
  };

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "adw-gtk3-dark"; 
	  cursor-theme = "Bibata-Modern-Ice"; 
	  cursor-size = lib.gvariant.mkInt32 24;                    
        };
      };
    }
  ];

environment.variables = {
    GTK_THEME = "adw-gtk3:dark";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    ADW_DISABLE_PORTAL = "1"; 
    XCURSOR_THEME = "Bibata-Modern-Ice"; # Ganti sesuai nama kursor Anda
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
  };

