#!/bin/bash
# Shared Homebrew helpers - sourced (not executed) by the macOS profiles.

# shellcheck source=run.sh
. "$(dirname "${BASH_SOURCE[0]}")/run.sh"

# brew_bundle <Brewfile> [HOMEBREW_DOTFILES_<NAME>=value...]: install what a
# profile's Brewfile lists with `brew bundle`, which taps, installs or upgrades
# only what is missing or outdated (a re-run does nothing else).
#
# A Brewfile is Ruby and reads the mode from HOMEBREW_DOTFILES_LITE (1 with -l):
# Homebrew only passes HOMEBREW_* variables through to it. Extra variables for
# the Brewfile, such as the devops categories, follow the file.
brew_bundle() {
  local brewfile="$1" lite=0
  shift
  [ "${FULL_MODE_SETUP:-true}" = "true" ] || lite=1
  run env HOMEBREW_DOTFILES_LITE="$lite" "$@" brew bundle --file "$brewfile"
}

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
    run brew uninstall --formula "$name"
  fi
}
