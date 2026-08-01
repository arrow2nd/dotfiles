{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      # 日本語
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      biz-ud-gothic

      # コーディング用
      plemoljp-nf
    ];

    fontconfig = {
      defaultFonts = {
        sansSerif = [ "x12y12pxMaruMinyaM" "BIZ UDPGothic" "Noto Sans CJK JP" ];
        serif = [ "Noto Serif CJK JP" ];
        monospace = [ "PlemolJP Console NF" "Noto Sans Mono CJK JP" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
