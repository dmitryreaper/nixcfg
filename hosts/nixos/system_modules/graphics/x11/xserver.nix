{
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
    windowManager.xmonad.config = builtins.readFile ./xmonad.hs;
  };
  services.displayManager.ly.enable = true;
}
