{
  ...
}:
{
  config = {
    _ = {
      nixos = {
        feature = {
          experimental = {
            common = {
              enable = true;
            };
          };
        };
        sops = {
          enable = true;
          tpm2 = true;
        };
      };
    };
  };
}
