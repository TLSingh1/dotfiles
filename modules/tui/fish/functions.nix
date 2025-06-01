# Fish shell functions
{ pkgs, lib, ... }:
{
  # Create and enter directory
  mkcd = ''
    if test (count $argv) -ne 1
      echo "Usage: mkcd <directory>"
      return 1
    end
    mkdir -p $argv[1] && cd $argv[1]
  '';

  # Extract various archive formats
  extract = ''
    if test (count $argv) -ne 1
      echo "Usage: extract <file>"
      return 1
    end
    
    set file $argv[1]
    
    if not test -f $file
      echo "Error: '$file' is not a valid file"
      return 1
    end
    
    switch $file
      case "*.tar.bz2"
        tar xjf $file
      case "*.tar.gz"
        tar xzf $file
      case "*.bz2"
        bunzip2 $file
      case "*.rar"
        unrar x $file
      case "*.gz"
        gunzip $file
      case "*.tar"
        tar xf $file
      case "*.tbz2"
        tar xjf $file
      case "*.tgz"
        tar xzf $file
      case "*.zip"
        unzip $file
      case "*.Z"
        uncompress $file
      case "*.7z"
        7z x $file
      case "*"
        echo "Error: '$file' cannot be extracted via extract()"
    end
  '';

  # Find file by name
  ff = ''
    find . -type f -iname "*$argv*" 2>/dev/null
  '';

  # Find directory by name
  fd = ''
    find . -type d -iname "*$argv*" 2>/dev/null
  '';

  # Quick file search with preview using fzf
  fzf-file = ''
    fzf --preview 'bat --style=numbers --color=always {}'
  '';

  # Git commit with message
  gcom = ''
    if test (count $argv) -eq 0
      echo "Usage: gcom <commit message>"
      return 1
    end
    git add . && git commit -m "$argv"
  '';

  # Quick backup of a file
  backup = ''
    if test (count $argv) -ne 1
      echo "Usage: backup <file>"
      return 1
    end
    cp $argv[1] $argv[1].bak.(date +%Y%m%d_%H%M%S)
  '';

  # Show disk usage for current directory
  du-here = ''
    du -h --max-depth=1 . | sort -hr
  '';

  # Quick weather check (requires curl)
  weather = ''
    if test (count $argv) -eq 0
      curl -s "wttr.in/?format=3"
    else
      curl -s "wttr.in/$argv[1]?format=3"
    end
  '';

  # Process killer by name
  killall-fuzzy = ''
    if test (count $argv) -eq 0
      echo "Usage: killall-fuzzy <process_name_pattern>"
      return 1
    end
    ps aux | grep $argv[1] | grep -v grep | awk '{print $2}' | xargs -r kill
  '';
} 