# mainecoon

どっしり構えてるやつ

## セットアップ

```sh
sudo nixos-rebuild switch --flake ~/dotfiles/nix#mainecoon
```

適用後、Tailscale にログインする

```sh
sudo tailscale up
```

## 動作確認

GPU / ROCm の認識確認:

```sh
rocminfo | grep -E "Name:|Marketing Name:"
rocm-smi
amdgpu_top
```
