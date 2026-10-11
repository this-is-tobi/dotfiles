#!/bin/bash
# Shared Homebrew helpers - sourced (not executed) by the macOS profiles.

# brew_leave_core <formula>: uninstall <formula> when it comes from
# homebrew/core, before the formula of the same name is installed from a tap.
#
# Homebrew refuses to install a tap formula while the core one of the same name
# is installed, so a machine set up before the switch could not run the profile
# again. `brew list --full-name` prints core formulae without a tap prefix.
brew_leave_core() {
  local name="$1"
  if brew list --formula --full-name 2>/dev/null | grep -qxF "$name"; then
    printf "Uninstalling %s from homebrew/core, it is installed from a tap instead\n" "$name"
    brew uninstall --formula "$name"
  fi
}
