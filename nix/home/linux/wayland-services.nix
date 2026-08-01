{ pkgs, ... }:
{
  systemd.user.services = {
    polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    wob = {
      Unit = {
        Description = "Wayland Overlay Bar";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        StandardInput = "socket";
        ExecStart = "${pkgs.wob}/bin/wob";
      };
    };
  };

  systemd.user.sockets.wob = {
    Unit = {
      Description = "Wayland Overlay Bar socket";
    };
    Socket = {
      ListenFIFO = "%t/wob.sock";
      SocketMode = "0600";
      Service = "wob.service";
    };
    Install = {
      WantedBy = [ "sockets.target" ];
    };
  };
}
