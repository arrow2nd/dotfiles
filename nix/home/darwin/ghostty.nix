{ ... }:
{
  # macOS ではネイティブウィンドウに寄せる
  programs.ghostty.settings = {
    font-size = 12;
    window-decoration = "auto";
    window-theme = "auto";
    macos-titlebar-style = "hidden";
    macos-titlebar-proxy-icon = "hidden";
    macos-window-buttons = "hidden";
  };
}
