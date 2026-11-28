{ ... }:
{
  # macOS ではネイティブウィンドウに寄せる
  programs.ghostty.settings = {
    font-size = 12;
    window-decoration = "auto";
    window-theme = "auto";
    # hidden はタブが無効になり new_tab が別ウィンドウを開くため、タブバー一体型にする
    macos-titlebar-style = "tabs";
    macos-titlebar-proxy-icon = "hidden";
    macos-window-buttons = "hidden";
    # ABC 配列では既定で option が記号入力になり、alt+* のキーバインドが効かない
    macos-option-as-alt = true;
  };
}
