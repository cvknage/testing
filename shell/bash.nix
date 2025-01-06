{pkgs, ...}:

{
  programs.bash = {
    enable = true;
    initExtra = ''
      PS1="\u@\h \W \$ "
    '';
    profileExtra = ''
      # load custom .(z)profile
      CUSTOM_DOTFILE="$HOME/.dotfiles/shell/profile"
      if [ -f "$CUSTOM_DOTFILE" ]; then
        . "$CUSTOM_DOTFILE"
      fi

      # load custom variables
      CUSTOM_VARIABLES="$HOME/.custom-variables"
      if [ -f "$CUSTOM_VARIABLES" ]; then
        . "$CUSTOM_VARIABLES"
      fi
    '';
    shellAliases = {
      vim = "nvim";
    };
  };
}

