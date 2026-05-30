{
  environment.persistence."/persistent" = {
    enable = true;
    hideMounts = true;

    directories = [
      # System state
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/timers"
      "/var/lib/systemd/rfkill"
      "/var/lib/systemd/backlight"

      # Networking
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager"
      "/var/lib/tailscale"

      # Auth and SSH
      "/etc/ssh"

      # Hardware state
      "/var/lib/bluetooth"
      "/var/lib/upower"
      "/var/lib/alsa"

      # Desktop session data
      "/var/lib/AccountsService"
      "/var/cache/cups"
    ];

    files = [
      "/etc/machine-id"
      "/var/lib/dbus/machine-id"
    ];
  };
}
