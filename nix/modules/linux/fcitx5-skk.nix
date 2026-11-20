{ pkgs, inputs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-skk
      inputs.rinze.packages.${pkgs.stdenv.hostPlatform.system}.fcitx5-rinze
      qt6Packages.fcitx5-configtool
    ];
    fcitx5.waylandFrontend = true;
  };

  # fcitx5-skk を Qt UI + 辞書パス指定でビルドし直し
  nixpkgs.overlays = [
    (final: prev: {
      fcitx5-skk = prev.fcitx5-skk.overrideAttrs (old: {
        cmakeFlags = [
          "-DENABLE_QT=TRUE"
          "-DSKK_PATH=${prev.skkDictionaries.l}/share/skk"
        ];
        buildInputs = (old.buildInputs or []) ++ [
          prev.qt6.qtbase
          prev.qt6Packages.fcitx5-qt
        ];
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
          prev.qt6.wrapQtAppsHook
        ];
      });
    })
  ];
}
