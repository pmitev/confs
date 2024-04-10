https://nix.dev/tutorials/first-steps/

```bash
nix-shell -p gawk
nix-shell -p cowsay --run "cowsay Nix"
```

https://nixos.org/manual/nix/stable/installation/upgrading#linux-multi-user

```bash
nix-env --install --file '<nixpkgs>' --attr nix cacert -I nixpkgs=channel:nixpkgs-unstable
systemctl daemon-reload
systemctl restart nix-daemon
```

```bash
nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable
nix-channel --update 
nix-env -iA unstable.vim
```

```bash
nix-channel --add https://nixos.org/channels/nixos-23.11 nixos
nix-channel --update 
nix-env -iA nixos.vim
```

```bash
nix-collect-garbage -d
```
