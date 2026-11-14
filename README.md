# Cosmic Panel APT repository

Binary packages for Cosmic Panel built automatically from commits on `master`.

```sh
echo "deb [trusted=yes] https://raw.githubusercontent.com/VibedByKaKi-cosmic/cosmic-panel/refs/heads/apt stable main" | sudo tee /etc/apt/sources.list.d/cosmic-panel.list
sudo apt update
sudo apt install cosmic-panel
```
