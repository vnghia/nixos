{
  ...
}:
{
  config = {
    _ = {
      programs = {
        data = {
          gvfs = {
            enable = true;
          };
        };
        nixos = {
          appimage = {
            enable = true;
            binfmt = true;
          };
          nix-ld = {
            enable = true;
          };
        };
      };
    };
  };
}
