local COLOR_OFF='\033[0m'
local COLOR_BLUE='\033[0;34m'
local COLOR_RED='\033[0;31m'
local COLOR_GREEN='\033[0;32m'
local COLOR_YELLOW='\033[0;33m'

lsfn() {
  fns=(b64d b64e dks kbp tools urle)
	for fn in ${fns[@]}; do
		echo "${COLOR_BLUE}[$fn]${COLOR_OFF}\n"
		$fn -h
		echo "\n"
	done
}

b64d() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Decode base64 string.\n"
		printf "Usage:\n"
		printf "  b64d <string>   base64 decode the given string.\n"
		;;
	*)
		echo -n "$1" | base64 -d
		;;
	esac
}

b64e() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Encode base64 string.\n"
		printf "Usage:\n"
		printf "  b64e <string>   base64 encode the given string.\n"
		;;
	*)
		echo -n "$1" | base64
		;;
	esac
}

cheat_glow() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Improve cheat sheet lisibility by piping it to glow..\n"
		printf "Usage:\n"
		printf "  cheat_glow <cheat_sheet>   enhance cheat sheet render.\n"
		;;
	*)
		cheat "$@" | glow --width=150
		;;
	esac
	cheat "$@" | glow --width=150
}

dks() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Decode a kubernetes secret by its name and optionally its namespace.\n"
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
		printf "  Kill the process running on a given port.\n"
		printf "Usage:\n"
		printf "  kbp <port_number>   kill process using the given port.\n"
		;;
	*)
		echo "Killing process running on port $1 ..."
		kill -9 $(lsof -i :$1 | tail -n +2 | awk '{print $2}')
		;;
	esac
}

tools() {
	base_url="https://raw.githubusercontent.com/this-is-tobi/tools/main"
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Use personal shell tool scripts.\n"
		printf "Usage:\n"
		printf "  tools <script_name> [script_arguments...]   execute the script with given arguments (<script_name> should include '.sh').\n"
		printf "  tools                                       print available scripts.\n"
		;;
	"")
		curl -s "$base_url/README.md" |
			grep -B 3 '.sh]' |
			sed "s|\\./|$base_url/|g" |
			glow --width=200
		;;
	*)
		script_url="$base_url/shell/$1"
		if curl --output /dev/null --silent --head --fail "$script_url"; then
			curl -s "$script_url" | bash -s -- "${@:2}"
		else
			echo "Error : script '$1' does not exist."
		fi
		;;
	esac
}

urle() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Url encode the given string.\n"
		printf "Usage:\n"
		printf "  urle <url>   url encode the given string.\n"
		;;
	*)
		jq -rn --arg x "$1" '$x | @uri'
		;;
	esac
}
