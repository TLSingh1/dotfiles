{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    
    # Default to personal account
    userName = "TLSingh1";
    userEmail = "tai8910@gmail.com";
    
    # Git configuration
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      
      # SSH transport configuration (default to personal)
      core.sshCommand = "ssh -i ~/.ssh/id_rsa_personal";
      
      # URL rewriting for different GitHub accounts
      url = {
        "git@github-personal:" = {
          insteadOf = "https://github.com/TLSingh1/";
        };
        "git@github-work:" = {
          insteadOf = "https://github.com/TLSingh0/";
        };
      };
      
      # Conditional configuration based on directory
      includeIf = {
        "gitdir:~/Code/projects/streamex/" = {
          path = "~/.config/git/work";
        };
      };
    };
  };
  
  # Create conditional git config for work projects
  home.file.".config/git/work".text = ''
    [user]
      name = TLSingh0
      email = tai@streamex.com
    [core]
      sshCommand = ssh -i ~/.ssh/id_rsa_work
  '';
} 