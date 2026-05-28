{ pkgs, inputs, ... }:

{
  home-manager.users.stephen = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
    };
  };
}
