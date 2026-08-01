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
    ".vimrc".source = linkDotfile ".vimrc";

    # 自作スクリプト
    ".local/bin/notification-sound".source = linkDotfile ".local/bin/notification-sound";
    ".local/bin/notify-send-cross".source = linkDotfile ".local/bin/notify-send-cross";
    ".local/bin/nowplaying-lyriflow".source = linkDotfile ".local/bin/nowplaying-lyriflow";
    ".local/bin/say-vv".source = linkDotfile ".local/bin/say-vv";
    ".local/bin/vime".source = linkDotfile ".local/bin/vime";
  };
}
