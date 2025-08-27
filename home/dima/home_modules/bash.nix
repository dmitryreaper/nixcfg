{
  programs.bash = {
    enable = true;
    shellAliases = {
      hr = "home-manager switch";
      hg = "home-manager generations";

      sr = "sudo nixos-rebuild switch";
      sg = "nixos-rebuild list-generations";
      re = "killall -s 9 emacs && emacs --daemon";

      em = "emacs -nw";
    };
    
    bashrcExtra = ''
      xset r rate 300 100
    '';
  };
}

