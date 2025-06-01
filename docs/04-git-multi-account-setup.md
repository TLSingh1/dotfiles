# Git Multi-Account Setup

This configuration supports using multiple GitHub accounts with SSH authentication, eliminating the need to enter credentials manually.

## Accounts Configured

- **Personal**: TLSingh1 with tai8910@gmail.com (DEFAULT)
- **Work**: TLSingh0 with tai@streamex.com

## Setup Process

### 1. Deploy Configuration

After adding the SSH module to your configuration, rebuild your system:

```bash
rebuild  # This will generate SSH keys automatically
```

### 2. Add SSH Keys to GitHub

The system will automatically generate SSH keys and display them. You need to add these to your respective GitHub accounts:

#### Personal Account (TLSingh1)
1. Copy the content of `~/.ssh/id_rsa_personal.pub`
2. Go to GitHub.com → Settings → SSH and GPG keys
3. Click "New SSH key"
4. Add the public key

#### Work Account (TLSingh0)
1. Copy the content of `~/.ssh/id_rsa_work.pub`
2. Go to GitHub.com → Settings → SSH and GPG keys (on work account)
3. Click "New SSH key"  
4. Add the public key

### 3. Test SSH Connections

```bash
# Test personal account
ssh-test-personal

# Test work account  
ssh-test-work
```

You should see messages like "Hi TLSingh1! You've successfully authenticated..."

## Usage

### Cloning Repositories

#### Personal Repositories (Default)
```bash
# Using helper command
gcp TLSingh1/my-personal-repo

# Or manually
git clone git@github-personal:TLSingh1/my-personal-repo.git
```

#### Work Repositories  
```bash
# Using helper command
gcw TLSingh0/work-repo

# Or manually
git clone git@github-work:TLSingh0/work-repo.git
```

### Directory-Based Configuration

#### Personal Projects (DEFAULT - Everywhere)
By default, git will use your personal account everywhere:
- Name: TLSingh1
- Email: tai8910@gmail.com
- SSH Key: ~/.ssh/id_rsa_personal

#### Work Projects (Streamex Only)
Only in the `~/Code/projects/streamex/` directory, git will automatically switch to:
- Name: TLSingh0  
- Email: tai@streamex.com
- SSH Key: ~/.ssh/id_rsa_work

### Converting Existing Repositories

#### From HTTPS to SSH
```bash
# For personal repos
git remote set-url origin git@github-personal:TLSingh1/repo-name.git

# For work repos
git remote set-url origin git@github-work:TLSingh0/repo-name.git
```

### Available Aliases

```bash
# Git shortcuts
g          # git
gs         # git status  
ga         # git add
gc         # git commit
gp         # git push
gl         # git log --oneline
gd         # git diff
gb         # git branch
gco        # git checkout

# Multi-account helpers
gcp        # git-clone-personal
gcw        # git-clone-work

# SSH management
ssh-add-personal    # Add personal key to agent
ssh-add-work       # Add work key to agent  
ssh-test-personal  # Test personal GitHub connection
ssh-test-work      # Test work GitHub connection
```

## Troubleshooting

### SSH Key Issues
```bash
# Check if keys exist
ls -la ~/.ssh/id_rsa_*

# Test SSH connections
ssh -T git@github-personal
ssh -T git@github-work

# Add keys to SSH agent manually
ssh-add-personal
ssh-add-work
```

### Wrong Account Used
If git is using the wrong account:

1. Check which directory you're in
2. For work projects, ensure you're in `~/Code/projects/streamex/`
3. Check git configuration:
   ```bash
   git config user.name
   git config user.email
   ```

### Repository Access Issues  
```bash
# Check remote URL
git remote -v

# Fix remote URL for personal repo
git remote set-url origin git@github-personal:TLSingh1/repo-name.git

# Fix remote URL for work repo  
git remote set-url origin git@github-work:TLSingh0/repo-name.git
```

## How SSH + GitHub Multi-Account Setup Works

### The SSH Foundation

SSH (Secure Shell) is the protocol that GitHub uses for secure communication. Instead of using username/password authentication, we use SSH key pairs:

- **Private Key**: Stays on your machine, never shared
- **Public Key**: Added to your GitHub account, proves your identity

### The Multi-Account Challenge

The problem: GitHub identifies you by your SSH key, but SSH traditionally uses one key per host. Since both accounts use `github.com`, we need a way to use different keys for the same host.

### Our Solution: SSH Host Aliases

We create "fake" hostnames that all point to the same real GitHub server but use different SSH keys:

```ssh
# ~/.ssh/config (managed by home-manager)
Host github-personal
    HostName github.com
    User git  
    IdentityFile ~/.ssh/id_rsa_personal
    IdentitiesOnly yes

Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa_work  
    IdentitiesOnly yes

Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa_personal  # Default to personal
    IdentitiesOnly yes
```

### How Git Remote URLs Work

When you clone a repository, the remote URL determines which SSH configuration is used:

```bash
# Uses github-personal SSH config (personal key)
git clone git@github-personal:TLSingh1/my-repo.git

# Uses github-work SSH config (work key)  
git clone git@github-work:TLSingh0/work-repo.git

# Uses default github.com SSH config (personal key)
git clone git@github.com:TLSingh1/my-repo.git
```

### Directory-Based Git Configuration

Git supports conditional configuration using `includeIf`. Our setup:

```gitconfig
# ~/.gitconfig (managed by home-manager)
[user]
    name = TLSingh1
    email = tai8910@gmail.com
[core]  
    sshCommand = ssh -i ~/.ssh/id_rsa_personal

[includeIf "gitdir:~/Code/projects/streamex/"]
    path = ~/.config/git/work
```

When you're in `~/Code/projects/streamex/`, Git automatically includes the work configuration:

```gitconfig
# ~/.config/git/work
[user]
    name = TLSingh0
    email = tai@streamex.com
[core]
    sshCommand = ssh -i ~/.ssh/id_rsa_work
```

### The Complete Flow

1. **SSH Key Generation**: Home-manager automatically creates two 4096-bit RSA keys
2. **SSH Configuration**: Host aliases route to GitHub with different keys
3. **Git Global Config**: Defaults to personal account everywhere
4. **Git Conditional Config**: Switches to work account in streamex directory
5. **Helper Scripts**: Simplify cloning with correct account

### Security Features

- **IdentitiesOnly yes**: Prevents SSH from trying other keys
- **PasswordAuthentication no**: Forces key-based authentication
- **ControlMaster**: Reuses SSH connections for speed
- **Proper permissions**: Keys are 600 (owner read/write only)

### URL Rewriting Magic

The configuration includes URL rewriting to automatically convert HTTPS URLs:

```gitconfig
[url "git@github-personal:"]
    insteadOf = https://github.com/TLSingh1/

[url "git@github-work:"]  
    insteadOf = https://github.com/TLSingh0/
```

This means if you accidentally use HTTPS URLs, they'll be automatically converted to SSH with the correct key.

## SSH Configuration Details

The SSH configuration creates these host aliases:

- `github-personal` → routes to github.com with personal key
- `github-work` → routes to github.com with work key  
- `github.com` → defaults to personal key

This allows you to use different keys for the same host (github.com) by using different aliases in your git remote URLs. 