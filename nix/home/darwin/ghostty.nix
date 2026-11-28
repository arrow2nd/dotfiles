{ pkgs, inputs, ... }:
{
  # nixpkgs 26.05 の 1.3.1 は macOS 27 で macos-titlebar-style = "tabs" のタブバーが右端に潰れる
  # 修正が入った 1.4.0 が 26.05 に降りてくるまで unstable から取る
  # https://ghostty.org/docs/install/release-notes/1-4-0
  programs.ghostty.package =
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.ghostty-bin;

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
