{ ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "x12y12pxMaruMinyaM:size=10";
        prompt = "\"> \"";
        icons-enabled = true;
        icon-theme = "pixelitos-dark";
        terminal = "ghostty -e";
        layer = "overlay";
        width = 50;
        lines = 12;
        horizontal-pad = 12;
        vertical-pad = 8;
        inner-pad = 8;
      };
      colors = {
        background = "232934ff";
        text = "e8e2d6ff";
        prompt = "d4af8dff";
        input = "e8e2d6ff";
        match = "d4af8dff";
        selection = "384153ff";
        selection-text = "e8e2d6ff";
        selection-match = "d4af8dff";
        border = "384153ff";
      };
      border = {
        width = 4;
        radius = 0;
      };
    };
  };
}
