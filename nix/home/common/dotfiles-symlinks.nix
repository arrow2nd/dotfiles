{ config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  xdg.configFile = {
    "git/commit-template".source = link ".config/git/commit-template";
    "bat".source = link ".config/bat";
    "mise".source = link ".config/mise";
    "nvim".source = link ".config/nvim";
    "sheldon".source = link ".config/sheldon";
    "tmux".source = link ".config/tmux";
    "typos".source = link ".config/typos";
    "vsnip".source = link ".config/vsnip";
  };

  home.file = {
    ".zshenv".source = link ".zshenv";
    ".zsh".source = link ".zsh";
  };
}
