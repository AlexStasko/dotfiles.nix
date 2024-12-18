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

  homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
    };
    casks = [
      "1password"
      "arc"
      "chef-workstation"
      "discord"
      "fliqlo"
      "grammarly-desktop"
      "httpie"
      "microsoft-teams"
      "obsidian"
      "podman-desktop"
      "raycast"
      "slack"
      "spotify"
      "telegram"
      "vlc"
      "logi-options+"
    ];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs username;};
    useUserPackages = true;
    users.${username} = import ./home.nix;
  };
}
