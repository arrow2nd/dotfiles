{ ... }:
{
  homebrew = {
    taps = [
      "arthur-ficial/tap"
      "mongodb/brew"
    ];

    brews = [
      # brew services で起動するため brew 管理のまま
      "mysql"
      "mongodb/brew/mongodb-database-tools"

      # nixpkgs に無い
      "arthur-ficial/tap/apfel"
    ];

    casks = [
      "brave-browser"
      "claude"
      "docker-desktop"
      "floorp"
      "keycastr"
      "microsoft-edge"
      "mongodb-compass"
      "obs"
      "sequel-ace"
      "spotify"
      "vivaldi"
      "zed"
    ];
  };
}
