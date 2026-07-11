{
  ...
}:
{
  config = {
    _ = {
      security = {
        tpm2 = {
          enable = true;
          abrmd = true;
        };
        yubikey = {
          enable = true;
        };
      };
    };
  };
}
