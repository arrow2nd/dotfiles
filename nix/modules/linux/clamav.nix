{ pkgs, ... }:

{
  # 常駐させると定義データベースだけで 1GB 前後のメモリを使うため、
  # 定義の自動更新だけ行い、検査は必要なときに ClamTk から手動で実行する
  services.clamav.updater.enable = true;

  environment.systemPackages = [ pkgs.clamtk ];
}
