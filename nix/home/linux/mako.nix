{ ... }:
{
  services.mako = {
    enable = true;

    settings = {
      font = "x12y12pxMaruMinyaM 10";

      sort = "-time";
      max-history = 6;
      default-timeout = 10000;

      layer = "overlay";
      width = 400;
      height = 200;
      margin = 8;
      padding = "8,12";

      border-size = 4;
      border-radius = 0;
      background-color = "#232934";
      text-color = "#e8e2d6";
      border-color = "#384153";
      progress-color = "over #384153";
    };

    extraConfig = ''
      [urgency=low]
      border-color=#d4af8d

      [urgency=critical]
      border-color=#c66471

      [mode=silent]
      invisible=1
    '';
  };
}
