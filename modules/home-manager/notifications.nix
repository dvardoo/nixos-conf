{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    libnotify
  ];

  systemd.user = {
    services.ergonomic-reminder = {
      Unit = {
        Description = "Ergonomic break reminder";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.libnotify}/bin/notify-send -t 0 -a 'Ergonomic Reminder' 'Time to move! Change position.'";
        Environment = "DBUS_SESSION_BUS_ADDRESS=unix:path=%t/bus";
      };
    };

    timers.ergonomic-reminder = {
      Unit = {
        Description = "Trigger ergonomic reminder every 30 minutes";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Timer = {
        OnBootSec = "5min";
        OnUnitActiveSec = "30min";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };

    services.real-break-morning = {
      Unit = {
        Description = "Real break reminder at 09:00";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.libnotify}/bin/notify-send -t 0 -a 'Real Break' 'Take a real break! Step away from screen.'";
        Environment = "DBUS_SESSION_BUS_ADDRESS=unix:path=%t/bus";
      };
    };

    services.real-break-afternoon = {
      Unit = {
        Description = "Real break reminder at 14:00";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.libnotify}/bin/notify-send -t 0 -a 'Real Break' 'Take a real break! Step away from screen.'";
        Environment = "DBUS_SESSION_BUS_ADDRESS=unix:path=%t/bus";
      };
    };

    timers.real-break-morning = {
      Unit = {
        Description = "Real break reminder at 09:00";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Timer = {
        OnCalendar = "09:00:00";
        AccuracySec = "1min";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };

    timers.real-break-afternoon = {
      Unit = {
        Description = "Real break reminder at 14:00";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Timer = {
        OnCalendar = "14:00:00";
        AccuracySec = "1min";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
