{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    # 未使用イメージ/コンテナを定期的に掃除
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # VOICEVOX ENGINE を OCI コンテナとして常駐
  virtualisation.oci-containers = {
    backend = "docker";
    containers.voicevox-engine = {
      image = "voicevox/voicevox_engine:cpu-latest";
      autoStart = true;
      # ローカルからのみアクセス
      ports = [ "127.0.0.1:50021:50021" ];
    };
  };

  # docker コマンドを sudo なしで使えるように
  users.users.arrow2nd.extraGroups = [ "docker" ];
}
