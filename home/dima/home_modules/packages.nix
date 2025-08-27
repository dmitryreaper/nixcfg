{ pkgs, ... }:

{
  home.packages = [
    #applications
    #pkgs.chromium
    #pkgs.alacritty
    #pkgs.telegram-desktop
    #pkgs.obs-studio
    #pkgs.spotify
    #pkgs.obsidian

    #develop
    #pkgs.qtcreator
    #pkgs.qt6.full
    #pkgs.libsForQt5.full
    pkgs.gnumake
    pkgs.cmake
	#pkgs.git
    pkgs.unzip
    #pkgs.gcc
    pkgs.clang
    pkgs.gdb
    pkgs.ripgrep
    pkgs.clang-tools
    #pkgs.ollama
  ];

  programs.neovim = {
    enable = true;
  };
}
