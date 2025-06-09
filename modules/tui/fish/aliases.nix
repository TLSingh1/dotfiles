# Fish shell aliases
{
  # File operations
  ll = "eza -la";
  la = "eza -la";
  ls = "eza -l";
  lt = "eza --tree";
  tree = "eza -T";

  # Directory navigation
  ".." = "cd ..";
  "..." = "cd ../..";
  "...." = "cd ../../..";

  # Screenshots (using grimblast with notifications)
  ss = "grimblast --notify copy area"; # Screenshot area to clipboard
  ssf = "grimblast --notify save area"; # Screenshot area to file
  sss = "grimblast --notify copy screen"; # Screenshot screen to clipboard
  sssf = "grimblast --notify save screen"; # Screenshot screen to file
  ssw = "grimblast --notify copy active"; # Screenshot window to clipboard
  sswf = "grimblast --notify save active"; # Screenshot window to file

  # Git shortcuts
  g = "git";
  gs = "git status";
  ga = "git add";
  gc = "git commit -m";
  gp = "git push";
  gl = "git log --oneline";
  gd = "git diff";
  gb = "git branch";
  gco = "git checkout";

  # Git clone helpers for multiple accounts
  gcp = "git-clone-personal";
  gcw = "git-clone-work";

  # SSH key management
  ssh-add-personal = "ssh-add ~/.ssh/id_rsa_personal";
  ssh-add-work = "ssh-add ~/.ssh/id_rsa_work";
  ssh-test-personal = "ssh -T git@github-personal";
  ssh-test-work = "ssh -T git@github-work";

  # System shortcuts
  c = "clear";
  e = "exit";
  h = "history";

  # Package management (NixOS specific)
  rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles";
  hm-switch = "home-manager switch --flake ~/.dotfiles";

  # Development
  v = "nvim";
  nv = "nvim";
  vim = "nvim";

  # Networking
  ping = "ping -c 5";

  # File viewing
  cat = "bat --style=auto";
  grep = "rg";

  # System monitoring
  top = "btop";
  htop = "btop";

  # Safety nets
  rm = "rm -i";
  cp = "cp -i";
  mv = "mv -i";

  # Restart caelestia
  restart-desktop = "systemctl --user restart caelestia-shell.service";
}
