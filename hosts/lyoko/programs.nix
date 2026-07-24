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
          nix-ld = {
            enable = true;
          };
        };
      };
    };
  };
}
