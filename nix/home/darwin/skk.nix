{ linkDotfile, ... }:
{
  # AquaSKK のディレクトリにはユーザー辞書などの実行時ファイルが置かれるため、
  # ディレクトリごとではなく管理対象のファイルだけリンクする
  home.file."Library/Application Support/AquaSKK/kana-rule.conf".source =
    linkDotfile "Library/Application Support/AquaSKK/kana-rule.conf";

  xdg.configFile."jisyo".source = linkDotfile ".config/jisyo";
}
