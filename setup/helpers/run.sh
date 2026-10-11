#!/bin/bash
# Dry-run helper - sourced (not executed) by the setup scripts, profiles and helpers.
#
# `setup-<os>.sh -n` exports DOTFILES_DRY_RUN=1 and still goes through every step
# and profile: the checks that only read the machine (is it installed, which
# version) run for real, and every command that would change it goes through
# `run`, which prints it instead. The output lists what a real run would do.

# dry_run: true during a dry run.
dry_run() {
  [ "${DOTFILES_DRY_RUN:-}" = "1" ]
}

# run <command> [args...]: run the command, or print it (shell-quoted) during a dry run.
run() {
  if dry_run; then
    printf "[dry-run]"
    printf " %q" "$@"
    printf "\n"
  else
    "$@"
  fi
}
