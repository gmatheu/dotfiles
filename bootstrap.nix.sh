
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon


nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

