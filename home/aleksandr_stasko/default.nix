{
  inputs,
  outputs,
  ...
}: let
  username = "aleksandr_stasko";
in {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  users.users.${username}.home = "/Users/${username}";
  home-manager = {
    extraSpecialArgs = {inherit inputs outputs username;};
    useUserPackages = true;
    users.${username} = import ./home.nix;
  };
}
