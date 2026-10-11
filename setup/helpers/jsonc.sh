#!/bin/bash
# JSONC helpers - sourced (not executed) by the setup scripts.
#
# VS Code files (settings.json, extensions.json) are JSONC: comments and trailing
# commas are allowed, which jq refuses. Strings are matched first so that a "//"
# inside one, like a URL, is never taken for a comment. perl is on macOS and in
# every Debian install (perl-base).

# jsonc_to_json [file...]: print plain JSON, from the files or from stdin.
jsonc_to_json() {
  perl -0777 -pe '
    s#("(?:\\.|[^"\\])*")|//[^\n]*|/\*.*?\*/#defined $1 ? $1 : ""#gse;
    s#("(?:\\.|[^"\\])*")|,(\s*[}\]])#defined $1 ? $1 : $2#gse;
  ' "$@"
}
