_tools_completion() {
	local base_url="https://raw.githubusercontent.com/this-is-tobi/tools/main"
	local scripts=$(curl -s "$base_url/docs/07-shell.md" | grep -o '[^ ]*\.sh]' | sed 's/^\[//; s/\]$//')

	COMPREPLY=($(compgen -W "$scripts" -- "${COMP_WORDS[1]}"))
}

complete -F _tools_completion tools
