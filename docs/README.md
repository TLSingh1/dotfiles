# NixOS Configuration Documentation

## Quick Reference

| Task | Command | Documentation |
|------|---------|---------------|
| Rebuild system | `sudo nixos-rebuild switch --flake .` | [Daily Operations](./01-daily-operations.md) |
| Add new host | See formula | [Host Management](./02-host-management.md) |
| Add new user | See formula | [User Management](./03-user-management.md) |
| Add package | Multiple methods | [Package Management](./04-package-management.md) |
| Create module | See template | [Module Creation](./05-module-creation.md) |

## Documentation Structure

1. **[Daily Operations](./01-daily-operations.md)** - Common commands and tasks
2. **[Host Management](./02-host-management.md)** - Adding and managing multiple machines
3. **[User Management](./03-user-management.md)** - Single and multi-user setups
4. **[Package Management](./04-package-management.md)** - Packages, overlays, and derivations
5. **[Module Creation](./05-module-creation.md)** - Creating reusable configuration modules

## System Architecture

```plantuml
@startuml
!theme plain

package "Repository Structure" {
  [flake.nix] as flake
  
  package "hosts/" {
    [my-nixos/] as host1
    [nixos-desktop/] as host2
  }
  
  package "modules/" {
    [wm/] as wm
    [gui/] as gui
    [tui/] as tui
  }
  
  package "home/" {
    [tai/home.nix] as home
  }
}

flake --> host1 : configures
flake --> host2 : configures
flake --> home : references

host1 --> wm : imports
host1 --> gui : imports
host1 --> tui : imports

home --> wm : conditionally imports
home --> gui : conditionally imports
home --> tui : conditionally imports

note right of flake : Entry point\nDefines all hosts
note right of modules : Reusable configs\nShared between hosts/users
note bottom of home : User-specific\nPer-host conditional

@enduml
``` 