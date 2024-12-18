{pkgs, ...}: {
  system.stateVersion = 5;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  services.nix-daemon.enable = true;

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
  };

  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["GeistMono"];})
    font-awesome
  ];
}
