local COLOR_OFF='\033[0m'
local COLOR_BLUE='\033[0;34m'
local COLOR_RED='\033[0;31m'
local COLOR_GREEN='\033[0;32m'
local COLOR_YELLOW='\033[0;33m'

lsfn() {
  fns=(
		b64d
		b64e
		browser
		cheat_glow
		check_cert
		dks
		kbp
		randompass
		secrets
		timestampd
		timestampe
		tools
		urld
		urle
		vault-cp
		weather
	)
	for fn in ${fns[@]}; do
		echo "${COLOR_BLUE}[$fn]${COLOR_OFF}\n"
		$fn -h
		echo "\n"
	done
}

# Writes the value an encoding function works on: its argument when there is one,
# otherwise standard input, read without echo when it is a terminal. Without an
# argument a secret stays out of the shell history and of the process list.
_fn_input() {
	if (( $# )); then
		printf '%s' "$1"
	elif [ -t 0 ]; then
		local value
		read -rs "value?Value (hidden): " || return 1
		printf '\n' >&2
		printf '%s' "$value"
	else
		cat
	fi
}

b64d() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Decode base64 string.\n\n"
		printf "Usage:\n"
		printf "  b64d <string>   base64 decode the given string.\n"
		printf "  b64d            base64 decode standard input, or ask for the string (hidden) in a terminal.\n"
		;;
	*)
		_fn_input "$@" | base64 -d
		;;
	esac
}

b64e() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Encode base64 string.\n\n"
		printf "Usage:\n"
		printf "  b64e <string>   base64 encode the given string.\n"
		printf "  b64e            base64 encode standard input as is, or ask for the string (hidden) in a terminal.\n"
		;;
	*)
		_fn_input "$@" | base64
		;;
	esac
}

browser() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Start a browsh web browser using docker.\n\n"
		printf "Usage:\n"
		printf "  browser           launch the web browser.\n"
		printf "  browser -- <url>  launch the web browser on the given url.\n"
		;;
	*)
		if ! docker info > /dev/null 2>&1; then
			echo "This function uses docker, and it isn't running - please start docker and try again!"
		else
			docker run --rm -it browsh/browsh "$@"
		fi
	esac
}

cheat_glow() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Improve cheat sheet lisibility by piping it to glow.\n\n"
		printf "Usage:\n"
		printf "  cheat_glow <cheat_sheet>   enhance cheat sheet render.\n"
		;;
	*)
		cheat "$@" | glow --width=150
		;;
	esac
}

check_cert() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Print certificate infos for the given domain.\n\n"
		printf "Usage:\n"
		printf "  check_cert <url>   Print cert infos.\n"
		;;
	*)
		curl -w '%{certs}' -k "$1"
		;;
	esac
}

dks() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Decode a kubernetes secret by its name and optionally its namespace.\n\n"
		printf "Usage:\n"
		printf "  dks <secret_name> [namespace]  decode kubernetes secret given its name and optionally its namespace as a second argument.\n"
		;;
	*)
		if [ -n "$2" ]; then
			kubectl -n "$2" get secret "$1" -oyaml | yq '.data | map_values(. | @base64d)'
		else
			kubectl get secret "$1" -oyaml | yq '.data | map_values(. | @base64d)'
		fi
		;;
	esac
}

kbp() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Kill the process running on a given port.\n\n"
		printf "Usage:\n"
		printf "  kbp <port_number>   kill process using the given port.\n"
		;;
	*)
		local pids
		pids=$(lsof -ti tcp:"$1" -sTCP:LISTEN)
		if [ -z "$pids" ]; then
			echo "Nothing is listening on port $1."
			return 1
		fi
		printf '%s\n' "$pids" | xargs kill -9
		;;
	esac
}

randompass() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Generate a password with the given length.\n\n"
		printf "Usage:\n"
		printf "  randompass <password_length>   generate a password with the given length.\n"
		;;
	*)
		if [ "${1:-24}" -lt 4 ]; then
			echo "The password length must be at least 4."
			return 1
		fi
		while true; do
			local password=$(LC_ALL=C tr -dc 'A-Za-z0-9=!?%~_-' < /dev/urandom | head -c ${1:-24})
			[[ $password != *[=\!?\%~_-]* ]] && continue
			[[ $password != *[A-Z]* ]] && continue
			[[ $password != *[a-z]* ]] && continue
			[[ $password != *[0-9]* ]] && continue
			echo "$password"
			break
		done
		;;
	esac
}

secrets() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Load secrets from the rta store (rta kv) into this shell.\n\n"
		printf "Usage:\n"
		printf "  secrets   export the rta keys named in DOTFILES_RTA_KEYS (set it in secrets.env),\n"
		printf "            asking for the passphrase of the store or of its key (RTA_KV_IDENTITY) when needed.\n"
		;;
	*)
		if ! command -v rta >/dev/null 2>&1; then
			echo "rta is not installed" >&2
			return 1
		fi
		if [ -z "$DOTFILES_RTA_KEYS" ]; then
			echo "DOTFILES_RTA_KEYS is empty: list the rta kv keys to export in ~/.config/dotfiles/secrets.env" >&2
			return 1
		fi
		local rta_env
		# --format and --prefix are explicit so an rta config that changes them
		# (dotenv output, a prefix) cannot make eval set the wrong variables
		rta_env="$(rta kv env --format export --prefix '' -- ${=DOTFILES_RTA_KEYS})" || return 1
		eval "$rta_env"
		echo "loaded: $DOTFILES_RTA_KEYS"
		;;
	esac
}

timestampd() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Show human readable version of a timestamp date.\n\n"
		printf "Usage:\n"
		printf "  timestampd <timestamp>   print a human readable date.\n"
		;;
	*)
		if [[ $OSTYPE == darwin* ]]; then
			date -r "$1"
		elif [[ $OSTYPE == linux* ]]; then
			date -d @"$1"
		else
			echo "Error: unsupported OS"
		fi
		;;
	esac
}

timestampe() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Show timestamp from a human readable date.\n\n"
		printf "Usage:\n"
		printf "  timestampe <date>   print the timestamp of a date (date in format 'YYYY-mm-ddTHH:MM:ss').\n"
		;;
	*)
		if [[ $OSTYPE == darwin* ]]; then
			date -j -f "%Y-%m-%dT%H:%M:%S" "$1" "+%s" 2>/dev/null || date -j -f "%Y-%m-%d" "$1" "+%s"
		elif [[ $OSTYPE == linux* ]]; then
			date -d "$1" "+%s"
		else
			echo "Error: unsupported OS"
		fi
		;;
	esac
}

# Prints the raw URL of the tools repository at TOOLS_REF (main by default). The
# ref ends up in a URL, so anything but a plain branch, tag or commit is refused.
_tools_base_url() {
	local ref="${TOOLS_REF:-main}"
	if [[ ! $ref =~ '^[A-Za-z0-9._/-]+$' || $ref == *..* ]]; then
		echo "Error : TOOLS_REF '$ref' is not a branch, tag or commit." >&2
		return 1
	fi
	printf '%s\n' "https://raw.githubusercontent.com/this-is-tobi/tools/$ref"
}

tools() {
	local base_url
	base_url="$(_tools_base_url)" || return 1
	case "$1" in
	-h | --help | "")
		printf "Description:\n"
		printf "  Use personal shell tool scripts.\n\n"
		printf "Usage:\n"
		printf "  tools <script_name> [script_arguments...]   execute the script with given arguments (<script_name> should include '.sh').\n"
		printf "  tools                                       print available scripts.\n\n"
		printf "  Scripts come from the main branch of github.com/this-is-tobi/tools; TOOLS_REF=<commit|tag|branch> pins another ref.\n"
		[ -n "$1" ] && return 0
		printf "\nScripts (%s):" "${TOOLS_REF:-main}"
		local -a pager=(glow --width=200)
		command -v glow >/dev/null 2>&1 || pager=(cat)
		curl -fsS --max-time 10 "$base_url/docs/07-shell.md" |
			grep -B 3 '.sh]' |
			sed "s|\.\./|$base_url/|g" |
			"${pager[@]}"
		;;
	*)
		# a name with a slash would reach any file of the repository (curl resolves ../)
		if [[ ! $1 =~ '^[A-Za-z0-9._-]+\.sh$' ]]; then
			echo "Error : '$1' is not a script name (letters, digits, '.', '_' or '-', ending in '.sh')." >&2
			return 1
		fi
		local script_url="$base_url/shell/$1" script rc=0
		script="$(mktemp)" || return 1
		if curl -fsL "$script_url" -o "$script"; then
			bash "$script" "${@:2}" || rc=$?
		else
			echo "Error : script '$1' does not exist." >&2
			rc=1
		fi
		rm -f "$script"
		return $rc
		;;
	esac
}

urld() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Url decode the given string.\n\n"
		printf "Usage:\n"
		printf "  urld <url>   url decode the given string.\n"
		printf "  urld         url decode standard input, or ask for the string (hidden) in a terminal.\n"
		;;
	*)
		local encoded
		encoded="$(_fn_input "$@")" || return 1
		# %xx -> \xxx for printf, with literal backslashes escaped first so they are not interpreted
		encoded="${encoded//\\/\\\\}"
		printf '%b\n' "${encoded//\%/\\x}"
		;;
	esac
}

urle() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Url encode the given string.\n\n"
		printf "Usage:\n"
		printf "  urle <url>   url encode the given string.\n"
		printf "  urle         url encode standard input, or ask for the string (hidden) in a terminal.\n"
		;;
	*)
		# through stdin rather than a jq argument, which the process list would show; the
		# newline that ends piped input (echo ... | urle) is not part of the value
		_fn_input "$@" | jq -sRr 'rtrimstr("\n") | @uri'
		;;
	esac
}

vault-cp() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Copy Vault secret from a path to another.\n\n"
		printf "Usage:\n"
		printf "  vault-cp <old_location> <new_location>	copy a secret from a path to another.\n"
		printf "  vault-cp -f <old_location> <new_location>	copy every version of a secret from a path to another.\n"
		;;
	-f | --full)
		local version data
		for version in $(vault kv metadata get -format=json "$2" | jq -r '.data.versions | keys | map(tonumber) | sort | .[]'); do
			data=$(vault kv get -version="$version" -format=json -field=data "$2") || { echo "Skipping version $version (destroyed or deleted)."; continue; }
			printf '%s' "$data" | vault kv put "$3" -
		done
		;;
	*)
		vault kv get -format=json -field=data "$1" | vault kv put "$2" -
		;;
	esac
}

weather() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Get the weather for a given location.\n\n"
		printf "Usage:\n"
		printf "  weather <location>   get the weather.\n"
		;;
	*)
		curl -fsS "https://wttr.in/$(jq -rn --arg location "$1" '$location | @uri')"
		;;
	esac
}
