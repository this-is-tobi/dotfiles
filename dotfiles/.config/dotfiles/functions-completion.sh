# Completion of the tools function: the scripts of the tools repository at TOOLS_REF
# (main by default), with their description. The list is cached for a day so that
# Tab does not wait on the network; when a refresh fails (offline), the previous
# list is used and the next try waits an hour.

# _tools_cache_scripts <base_url> <cache_file>: write "name:description" lines
_tools_cache_scripts() {
	local base_url="$1" cache="$2" tmp
	tmp="$(mktemp "$cache.XXXXXX" 2>/dev/null)" || return 1
	# only names a tools call accepts, and no control character from the description
	# reaches the terminal
	curl -fsS --max-time 3 "$base_url/docs/07-shell.md" 2>/dev/null |
		sed -nE 's/^\| *\[([A-Za-z0-9._-]+\.sh)\]\([^)]*\) *\| *\**([^*|]*)\**.*$/\1:\2/p' |
		sed -E 's/ +$//' |
		LC_ALL=C tr -cd '[:print:]\n' > "$tmp"
	if [[ -s $tmp ]]; then
		mv -f "$tmp" "$cache"
	else
		rm -f "$tmp"
		return 1
	fi
}

_tools() {
	if (( CURRENT > 2 )); then
		# the arguments of the script itself
		_default
		return
	fi
	setopt localoptions extendedglob
	local base_url ref="${TOOLS_REF:-main}"
	base_url="$(_tools_base_url 2>/dev/null)" || return 1
	local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"
	local cache="$cache_dir/tools-scripts-${ref//\//_}"
	mkdir -p "$cache_dir" 2>/dev/null || return 1
	if [[ -z $cache(#qN.mh-24) && -z $cache.failed(#qN.mh-1) ]]; then
		_tools_cache_scripts "$base_url" "$cache" || : >| "$cache.failed"
	fi
	local -a scripts
	[[ -r $cache ]] && scripts=(${(f)"$(<"$cache")"})
	_describe -t scripts 'tools script' scripts
}

# compdef exists once compinit has run: oh-my-zsh runs it before .zshrc sources this file
if (( $+functions[compdef] )); then
	compdef _tools tools
fi
