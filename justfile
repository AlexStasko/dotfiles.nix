_default:
    just --list

nix-build profile:
    nix build --json --no-link --print-build-logs ".#{{ profile }}"

check:
    nix flake check --show-trace

build profile="epam":
    just nix-build "darwinConfigurations.{{ profile }}.config.system.build.toplevel"

switch profile="epam":
    darwin-rebuild switch --flake ".#{{ profile }}"

test profile="epam":
    darwin-rebuild check --flake ".#{{ profile }}"

update:
    nix flake update
