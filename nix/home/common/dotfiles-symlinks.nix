{ linkDotfile, ... }:
{
  xdg.configFile = {
    "git/commit-template".source = linkDotfile ".config/git/commit-template";
    "bat".source = linkDotfile ".config/bat";
    "mise".source = linkDotfile ".config/mise";
    "nvim".source = linkDotfile ".config/nvim";
    "sheldon".source = linkDotfile ".config/sheldon";
    "tmux".source = linkDotfile ".config/tmux";
    "typos".source = linkDotfile ".config/typos";
  };

  home.file = {
    ".zshenv".source = linkDotfile ".zshenv";
    ".zsh".source = linkDotfile ".zsh";
  };
}
