{
  lib,
  ...
}:
{
  imports = [
    ./fcitx5
  ];

  options = with lib; {
    _ = {
      desktop.i18n.input = {
        type = mkOption {
          type = types.nullOr (
            types.enum [
              "fcitx5"
            ]
          );
          default = null;
        };
      };
    };
  };
}
