#!/bin/bash
# Profile registry - sourced (not executed) by the setup scripts.
#
# A profile is a script named setup/profiles/<os>/setup-<name>.sh. Two lines of
# its header are all the setup scripts need to list it in the help, accept it
# with -p and run it:
#   # Profile: <what it installs, one line>
#   # Order: <number; the selected profiles run by increasing order>
# Adding a profile is adding such a script: nothing else has to be edited.

# Fallbacks so this file is safe to source under `set -u` before the caller has
# defined its own palette.
red="${red:-\e[0;31m}"
no_color="${no_color:-\033[0m}"

PROFILES_DIR=""
PROFILES_SELECTED=" "

# profiles_init <dir>: use the profiles of <dir> (setup/profiles/<os>).
profiles_init() {
  PROFILES_DIR="$1"
}

# profile_field <name> <field>: the value of a "# <field>: ..." header line.
profile_field() {
  sed -n "s/^# $2: *//p" "$PROFILES_DIR/setup-$1.sh" | head -n 1
}

# profiles_list: the profile names, in run order (then by name), one per line.
profiles_list() {
  local file name order
  for file in "$PROFILES_DIR"/setup-*.sh; do
    [ -f "$file" ] || continue
    name="${file##*/setup-}"
    name="${name%.sh}"
    order="$(profile_field "$name" Order)"
    printf "%s %s\n" "${order:-50}" "$name"
  done | sort -k1,1n -k2,2 | cut -d ' ' -f 2
}

# profiles_help: one help line per profile, sorted by name.
profiles_help() {
  local name
  for name in $(profiles_list | sort); do
    printf "          -> %-8s %s\n" "'$name'" "$(profile_field "$name" Profile)"
  done
}

# profiles_select <csv>: add the profiles of a comma-separated list to the
# selection. An unknown name is an error listing the valid ones.
profiles_select() {
  local name names
  IFS=',' read -r -a names <<< "$1"
  for name in ${names[@]+"${names[@]}"}; do
    # Only plain names: the name becomes part of a path
    if case "$name" in "" | *[!a-z0-9_-]*) true;; *) false;; esac \
      || [ ! -f "$PROFILES_DIR/setup-$name.sh" ]; then
      printf "Error: unknown profile '%s'. Valid profiles: %s\n" "$name" "$(profiles_list | sort | paste -sd ',' - | sed 's/,/, /g')" >&2
      return 1
    fi
    profile_selected "$name" || PROFILES_SELECTED="$PROFILES_SELECTED$name "
  done
}

# profile_selected <name>: true when -p selected the profile.
profile_selected() {
  case "$PROFILES_SELECTED" in
    *" $1 "*) return 0;;
    *) return 1;;
  esac
}

# profiles_settings: one "install [name] profile: true|false" line per profile.
profiles_settings() {
  local name selected
  for name in $(profiles_list | sort); do
    selected=false
    profile_selected "$name" && selected=true
    printf "  -> install ${red}[%s]${no_color} profile: ${red}%s${no_color}\n" "$name" "$selected"
  done
}

# profiles_run: run the selected profiles in order, as numbered steps. The
# step counter $i belongs to the setup script.
profiles_run() {
  local name
  for name in $(profiles_list); do
    profile_selected "$name" || continue
    printf "\n${red}%s.${no_color} Install %s profile\n\n" "$i" "$name"
    i=$((i + 1))
    "$PROFILES_DIR/setup-$name.sh"
  done
}
