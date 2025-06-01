{ config, pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;
    
    # SSH configuration for multiple GitHub accounts
    matchBlocks = {
      # Personal GitHub account
      "github-personal" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_rsa_personal";
        identitiesOnly = true;
      };
      
      # Work GitHub account  
      "github-work" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_rsa_work";
        identitiesOnly = true;
      };
      
      # Default github.com (fallback to personal)
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_rsa_personal";
        identitiesOnly = true;
      };
    };
    
    # Additional SSH configuration
    extraConfig = ''
      # Prevent SSH from prompting for passwords
      PasswordAuthentication no
      PubkeyAuthentication yes
      
      # Speed up SSH connections
      ControlMaster auto
      ControlPath ~/.ssh/master-%r@%h:%p
      ControlPersist 10m
    '';
  };
  
  # Generate SSH keys if they don't exist
  home.activation.generateSSHKeys = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p ~/.ssh
    $DRY_RUN_CMD chmod 700 ~/.ssh
    
    # Generate personal SSH key if it doesn't exist
    if [[ ! -f ~/.ssh/id_rsa_personal ]]; then
      $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_personal -C "tai8910@gmail.com" -N ""
      $DRY_RUN_CMD chmod 600 ~/.ssh/id_rsa_personal
      $DRY_RUN_CMD chmod 644 ~/.ssh/id_rsa_personal.pub
      echo "Generated personal SSH key at ~/.ssh/id_rsa_personal"
      echo "Add the following public key to your personal GitHub account:"
      echo "$(cat ~/.ssh/id_rsa_personal.pub)"
    fi
    
    # Generate work SSH key if it doesn't exist
    if [[ ! -f ~/.ssh/id_rsa_work ]]; then
      $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_work -C "tai@streamex.com" -N ""
      $DRY_RUN_CMD chmod 600 ~/.ssh/id_rsa_work
      $DRY_RUN_CMD chmod 644 ~/.ssh/id_rsa_work.pub
      echo "Generated work SSH key at ~/.ssh/id_rsa_work"
      echo "Add the following public key to your work GitHub account:"
      echo "$(cat ~/.ssh/id_rsa_work.pub)"
    fi
  '';
} 