sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon

export PATH=$PATH:$HOME/.nix-profile/bin
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
