local COLOR_OFF='\033[0m'
local COLOR_BLUE='\033[0;34m'
local COLOR_RED='\033[0;31m'
local COLOR_GREEN='\033[0;32m'
local COLOR_YELLOW='\033[0;33m'

lsfn() {
  fns=(b64d b64e browser dks kbp tools urld urle)
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
		printf "  Decode base64 string.\n\n"
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
		printf "  Encode base64 string.\n\n"
		printf "Usage:\n"
		printf "  b64e <string>   base64 encode the given string.\n"
		;;
	*)
		echo -n "$1" | base64
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
			docker run --rm -it browsh/browsh "$1"
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
	cheat "$@" | glow --width=150
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
		printf "  Use personal shell tool scripts.\n\n"
		printf "Usage:\n"
		printf "  tools <script_name> [script_arguments...]   execute the script with given arguments (<script_name> should include '.sh').\n"
		printf "  tools                                       print available scripts.\n"
		;;
	"")
		printf "Description:\n"
		printf "  Use personal shell tool scripts.\n\n"
		printf "Usage:\n"
		printf "  tools <script_name> [script_arguments...]   execute the script with given arguments (<script_name> should include '.sh').\n"
		printf "  tools                                       print available scripts.\n\n"
		printf "Scripts:"
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

urld() {
	case "$1" in
	-h | --help)
		printf "Description:\n"
		printf "  Url decode the given string.\n\n"
		printf "Usage:\n"
		printf "  urle <url>   url decode the given string.\n"
		;;
	*)
		echo "$1" | jq -rR '
			# Emit . and stop as soon as "condition" is true.
			def until(condition; next):
				def u: if condition then . else (next|u) end;
				u;

			def url_decode:
				# The helper function converts the input string written in the given
				# "base" to an integer
				def to_i(base):
					explode
					| reverse
					| map(if 65 <= . and . <= 90 then . + 32  else . end)   # downcase
					| map(if . > 96  then . - 87 else . - 48 end)  # "a" ~ 97 => 10 ~ 87
					| reduce .[] as $c
							# base: [power, ans]
							([1,0]; (.[0] * base) as $b | [$b, .[1] + (.[0] * $c)]) | .[1];
				. as $in
				| length as $length
				| [0, ""]  # i, answer
				| until ( .[0] >= $length;
						.[0] as $i
						|  if $in[$i:$i+1] == "%"
							then [ $i + 3, .[1] + ([$in[$i+1:$i+3] | to_i(16)] | implode) ]
							else [ $i + 1, .[1] + $in[$i:$i+1] ]
							end)
				| .[1];  # answer

			. | url_decode
			'
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
		;;
	*)
		jq -rn --arg x "$1" '$x | @uri'
		;;
	esac
}
