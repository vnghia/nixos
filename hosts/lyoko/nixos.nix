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
        substituters = {
          "https://nghe.cachix.org" = "nghe.cachix.org-1:H757ngFI7o6unzi/uiXKN6fhfQjCjrEI80hZDWr0Mrs=";
          "https://fenix.cachix.org" = "fenix.cachix.org-1:ecJhr+RdYEdcVgUkjruiYhjbBloIEGov7bos90cZi0Q=";
        };
      };
    };
  };
}
