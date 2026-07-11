{
  ...
}:
{
  config = {
    _ = {
      virtualisation = {
        podman = {
          enable = true;
        };
        qemu = {
          enable = true;
          onBoot = "ignore";
          onShutdown = "suspend";
        };
      };
    };
  };
}
