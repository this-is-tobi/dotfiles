# Dotfiles :wrench:

This project aims to provide dotfiles templates and common scripts for backup & setup.

## Dotfiles

The `dotfiles/` folder provides the following dotfiles templates :

```sh
./dotfiles
├── .config
│   ├── cheat
│   │   └── conf.yml
│   ├── dotfiles
│   │   ├── functions-completion.sh
│   │   └── functions.sh
│   ├── lazygit
│   │   └── config.yml
│   └── nvim
│       ├── init.lua
│       └── lua
│           ├── config
│           └── plugins
├── .continue
│   └── config.json
├── .mattermost
│   └── theme-config.json
├── .oh-my-zsh
│   └── this-is-tobi.zsh-theme
├── .vscode
│   ├── extensions.json
│   └── settings.json
├── .gitconfig
├── .prototools
└── .zshrc
```

> *Some lines may be commented inside `.zshrc`, uncomment them following profile needs.*

## Backup

These scripts are intended to backup common files to another directory (local or remote) :
- [backup-osx.sh](./backup/backup-osx.sh)
- [backup-debian.sh](./backup/backup-osx.sh)

> For more infos use `-h` flag with the script to print help.

## Setup

These scripts are intended to install common packages on proper os :
- [setup-osx.sh](./setup/setup-osx.sh)
- [setup-debian.sh](./setup/setup-debian.sh)

It can install severals profiles in addition to the core install by providing `-p <profile_name>` *(example: `./setup-osx.sh -p 'devops,secops'`)*. The following profiles are available :
- [base](#base) *- base packages.*
- [ai](#ia) *- ai oriented packages.*
- [devops](#devops) *- devops oriented packages.*
- [go](#go) *- go developer oriented packages.*
- [js](#javascript) *- js developer oriented packages.*
- [secops](#secops) *- secops oriented packages.*
- [extras](#extras) *- extras personnal packages (only available for osx).*

> [!TIP]
> *Use flag `-l` to use lite mode setup and install only main tools.*
> 
> *For more infos use `-h` flag with the script to print help.*

CLI completions are referenced and installed via the [zsh-completions](https://github.com/zsh-users/zsh-completions) repository and [this custom file](./setup/completions.sh).

> *Packages can come from different sources such as homebrew, apt, npm, etc...*

> *Apt come with [WakeMeOps](https://docs.wakemeops.com) repository.*


### Core

#### Command line interfaces

| Package                                                               | Description                                                           | Lite mode | OSX installation | Debian installation |
| --------------------------------------------------------------------- | --------------------------------------------------------------------- | --------- | ---------------- | ------------------- |
| [build-essential](https://packages.debian.org/en/sid/build-essential) | informational list of essential packages for building debian packages | x         | -                | apt                 |
| [ca-certificates](https://packages.debian.org/en/sid/ca-certificates) | common CA certificates                                                | x         | homebrew         | apt                 |
| [coreutils](https://www.gnu.org/software/coreutils)                   | basic file, shell and text manipulation utilities                     | x         | -                | apt                 |
| [curl](https://curl.se/)                                              | command line tool and library for transferring data with URLs         | x         | homebrew         | apt                 |
| [gnupg](https://gnupg.org)                                            | encryption tool                                                       | x         | homebrew         | apt                 |
| [gzip](https://www.gnu.org/software/gzip)                             | popular data compression program                                      | x         | homebrew         | apt                 |
| [jq](https://stedolan.github.io/jq)                                   | json processor tool                                                   | x         | homebrew         | apt                 |
| [locales](https://packages.debian.org/en/sid/locales)                 | tools to generate locale definitions                                  | x         | -                | apt                 |
| [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)                       | zsh configuration manager                                             | x         | shell            | shell               |
| [sed](https://www.gnu.org/software/sed)                               | non-interactive command-line text editor                              | x         | homebrew         | apt                 |
| [tar](https://www.gnu.org/software/tar)                               | program to create and manipulate tar archives                         | x         | -                | apt                 |
| [unzip](https://packages.debian.org/en/sid/unzip)                     | de-archiver for zip files                                             | x         | homebrew         | apt                 |
| [wget](https://www.gnu.org/software/wget)                             | package for retrieving files using HTTP, HTTPS, FTP and FTPS          | x         | homebrew         | apt                 |
| [xz-utils](https://packages.debian.org/en/sid/xz-utils)               | xz format compression utilities                                       | x         | homebrew         | apt                 |

### Base

#### Command line interfaces

| Package                                                   | Description                                          | Lite mode | OSX installation | Debian installation |
| --------------------------------------------------------- | ---------------------------------------------------- | --------- | ---------------- | ------------------- |
| [bat](https://github.com/sharkdp/bat)                     | cat command enhanced                                 | x         | homebrew         | apt                 |
| [bat-extras](https://github.com/eth-p/bat-extras)         | bat combo with other commands                        | x         | homebrew         | shell               |
| [chafa](https://hpjansson.org/chafa)                      | image viewer in terminal                             | -         | homebrew         | apt                 |
| [cheat](https://github.com/cheat/cheat)                   | create and view interactive cheat sheets             | x         | homebrew         | apt                 |
| [exiftool](https://exiftool.org)                          | metadata writer and reader tool                      | -         | homebrew         | apt                 |
| [eza](https://eza.rocks)                                  | ls command enhanced                                  | x         | homebrew         | apt                 |
| [fd](https://github.com/sharkdp/fd)                       | simple, fast and user-friendly alternative to 'find' | x         | homebrew         | apt                 |
| [ffmpeg](https://ffmpeg.org)                              | audio video manipulation tool                        | -         | homebrew         | apt                 |
| [fzf](https://github.com/junegunn/fzf)                    | command-line fuzzy finder                            | x         | homebrew         | apt                 |
| [gh](https://cli.github.com)                              | github cli                                           | -         | homebrew         | apt                 |
| [glab](https://gitlab.com/gitlab-org/cli)                 | gitlab cli                                           | -         | homebrew         | apt                 |
| [glow](https://github.com/charmbracelet/glow)             | render markdown on the CLI, with pizzazz             | x         | homebrew         | apt                 |
| [lazydocker](https://github.com/jesseduffield/lazydocker) | lazier way to manage everything docker               | -         | homebrew         | apt                 |
| [lazygit](https://github.com/jesseduffield/lazygit)       | lazier way to manage everything git                  | -         | homebrew         | apt                 |
| [nmap](https://nmap.org)                                  | port scanning utility                                | -         | homebrew         | apt                 |
| [nvim](https://neovim.io)                                 | interactive cli ide (enhanced vim)                   | -         | homebrew         | shell               |
| [pandoc](https://pandoc.org)                              | universal markup converter                           | -         | homebrew         | apt                 |
| [proto](https://moonrepo.dev/proto)                       | pluggable multi-language version manager             | x         | homebrew         | shell               |
| [ripgrep](https://github.com/BurntSushi/ripgrep)          | regex pattern search cli (usefull for bat-extras)    | x         | homebrew         | apt                 |
| [rclone](https://rclone.org)                              | the swiss army knife of cloud storage                | -         | homebrew         | apt                 |
| [rsync](https://rsync.samba.org)                          | file transfer tool                                   | x         | homebrew         | apt                 |
| [sshs](https://github.com/quantumsheep/sshs)              | interactive cli ssh client                           | x         | homebrew         | shell               |
| [tldr++](https://github.com/isacikgoz/tldr)               | cheatsheet interactive cli                           | -         | homebrew         | shell               |
| [tree](https://mama.indstate.edu/users/ice/tree)          | filesystem display as tree                           | x         | homebrew         | apt                 |
| [ttyd](https://github.com/tsl0922/ttyd)                   | share terminal over the web                          | -         | homebrew         | apt                 |
| [vhs](https://github.com/charmbracelet/vhs)               | cli home video recorder                              | -         | homebrew         | apt                 |
| [vim](https://www.vim.org)                                | cli ide                                              | x         | homebrew         | apt                 |
| [watch](https://en.wikipedia.org/wiki/Watch_(command))    | cli tool that runs the specified command repeatedly  | x         | homebrew         | apt                 |
| [yq](https://github.com/mikefarah/yq)                     | yaml processor tool                                  | x         | homebrew         | apt                 |

#### Applications

| Package                                                              | Description                   | Lite mode | OSX installation  | Debian installation |
| -------------------------------------------------------------------- | ----------------------------- | --------- | ----------------- | ------------------- |
| [brave](https://brave.com/fr)                                        | privacy compliant web browser | -         | homebrew *- cask* | -                   |
| [firefox](https://www.mozilla.org/firefox)                           | privacy compliant web browser | -         | homebrew *- cask* | -                   |
| [insomnia](https://insomnia.rest)                                    | http and graphql client       | -         | homebrew *- cask* | -                   |
| [mattermost](https://mattermost.com)                                 | collaboration app             | -         | homebrew *- cask* | -                   |
| [openvpn-connect](https://openvpn.net/client-connect-vpn-for-mac-os) | vpn client                    | -         | homebrew *- cask* | -                   |
| [vscode](https://code.visualstudio.com)                              | ide                           | -         | homebrew *- cask* | -                   |

### Devops

#### Command line interfaces

| Package                                                         | Description                                                     | Lite mode | OSX installation | Debian installation |
| --------------------------------------------------------------- | --------------------------------------------------------------- | --------- | ---------------- | ------------------- |
| [act](https://github.com/nektos/act)                            | local github actions                                            | -         | homebrew         | apt                 |
| [ansible](https://docs.ansible.com)                             | automation tool                                                 | x         | homebrew         | pip                 |
| [ansible-lint](https://ansible.readthedocs.io/projects/lint)    | cli tool for linting ansible playbooks, roles and collections   | -         | homebrew         | pip                 |
| [argo](https://argo-cd.readthedocs.io/en/stable)                | argo-workflows cli                                              | -         | homebrew         | apt                 |
| [argocd](https://argo-cd.readthedocs.io/en/stable)              | argo-cd cli                                                     | -         | homebrew         | apt                 |
| [aws](https://aws.amazon.com/fr/cli)                            | aws cli                                                         | -         | homebrew         | apt                 |
| [coder](https://coder.com)                                      | coder cli                                                       | -         | homebrew         | shell               |
| [docker](https://www.docker.com)                                | docker engine                                                   | x         | -                | shell               |
| [helm](https://helm.sh)                                         | kubernetes package manager                                      | x         | homebrew         | apt                 |
| [helm-docs](https://github.com/norwoodj/helm-docs)              | tool for auto generating markdown docs for helm charts          | x         | homebrew         | apt                 |
| [k6](https://k6.io)                                             | modern load testing tool, using Go and javascript               | -         | homebrew         | apt                 |
| [k9s](https://k9scli.io)                                        | kubernetes cluster manager cli                                  | -         | homebrew         | apt                 |
| [kind](https://kind.sigs.k8s.io)                                | kubernetes cluster in docker                                    | -         | homebrew         | apt                 |
| [krew](https://sigs.k8s.io/krew)                                | kubectl plugin manager                                          | x         | homebrew         | apt                 |
| [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl) | kubernetes cli                                                  | x         | homebrew         | apt                 |
| [kubectx](https://github.com/ahmetb/kubectx)                    | kubernetes context and namespace manager                        | x         | homebrew         | apt                 |
| [mc](https://github.com/minio/mc)                               | commands replacement for object storage (minio cli)             | x         | homebrew         | apt                 |
| [mkcert](https://github.com/FiloSottile/mkcert)                 | simple zero-config tool to make locally trusted certificates    | -         | homebrew         | shell               |
| [oc](https://www.openshift.com)                                 | openshift cli                                                   | -         | homebrew         | apt                 |
| [scw](https://github.com/scaleway/scaleway-cli)                 | scaleway cli                                                    | -         | homebrew         | apt                 |
| [sshpass](https://sourceforge.net/projects/sshpass)             | non-interactive ssh password auth                               | x         | homebrew         | apt                 |
| [teleport](https://goteleport.com)                              | modern ssh server for teams managing distributed infrastructure | -         | homebrew         | apt                 |
| [terraform](https://www.terraform.io)                           | infrastructure automation tool                                  | x         | homebrew         | apt                 |
| [velero](https://velero.io)                                     | kubernetes backup and migration cli                             | -         | homebrew         | apt                 |

#### Applications

| Package                                                  | Description    | Lite mode | OSX installation  | Debian installation |
| -------------------------------------------------------- | -------------- | --------- | ----------------- | ------------------- |
| [docker](https://www.docker.com/products/docker-desktop) | docker desktop | x         | homebrew *- cask* | -                   |

#### Kubectl plugins

| Plugin                                                       | Description                                              | Lite mode | OSX installation | Debian installation |
| ------------------------------------------------------------ | -------------------------------------------------------- | --------- | ---------------- | ------------------- |
| [cert-manager](https://cert-manager.io/docs/reference/cmctl) | cert-manager cli                                         | x         | krew             | krew                |
| [cnpg](https://github.com/cloudnative-pg/cloudnative-pg)     | cloud native postgres cli                                | x         | krew             | krew                |
| [df-pv](https://github.com/yashbhutwala/kubectl-df-pv)       | df utility for pv                                        | x         | krew             | krew                |
| [ktop](https://github.com/vladimirvivien/ktop)               | top-like tool for Kubernetes clusters                    | x         | krew             | krew                |
| [neat](https://github.com/itaysk/kubectl-neat)               | kubernetes yaml/json output clean up to make it readable | x         | krew             | krew                |
| [stern](https://github.com/stern/stern)                      | multi pod and container log tailing for Kubernetes       | x         | krew             | krew                |

### Secops

#### Command line interfaces

| Package                                             | Description                                                 | Lite mode | OSX installation | Debian installation |
| --------------------------------------------------- | ----------------------------------------------------------- | --------- | ---------------- | ------------------- |
| [age](https://github.com/FiloSottile/age)           | simple, modern and secure encryption tool                   | -         | homebrew         | apt                 |
| [cosign](https://docs.sigstore.dev)                 | code signing and transparency for containers and binaries   | x         | homebrew         | apt                 |
| [dive](https://github.com/wagoodman/dive)           | tool for exploring each layer in a docker image             | -         | homebrew         | apt                 |
| [kubescape](https://github.com/kubescape/kubescape) | kubernetes security scan                                    | -         | homebrew         | apt                 |
| [kyverno](https://github.com/kyverno/kyverno)       | kubernetes policy managemen                                 | -         | homebrew         | apt                 |
| [sops](https://github.com/getsops/sops)             | simple and flexible tool for managing secrets               | -         | homebrew         | apt                 |
| [trivy](https://aquasecurity.github.io/trivy)       | vulnerability scanner for container images and file systems | x         | homebrew         | apt                 |
| [vault](https://vaultproject.io)                    | vault cli                                                   | -         | homebrew         | apt                 |

### Javascript

#### Command line interfaces

| Package                                  | Description                                          | Lite mode | OSX installation | Debian installation |
| ---------------------------------------- | ---------------------------------------------------- | --------- | ---------------- | ------------------- |
| [@antfu/ni](https://github.com/antfu/ni) | javascript package manager wrapper                   | x         | npm              | npm                 |
| [bun](https://bun.sh)                    | javascript runtime environment                       | -         | proto            | proto               |
| [node](https://nodejs.org)               | javascript runtime environment                       | x         | proto            | proto               |
| [npm](https://github.com/npm/cli)        | javascript package manager                           | x         | proto            | proto               |
| [pnpm](https://pnpm.io)                  | javascript disk space efficient package manager      | -         | proto            | proto               |
| [yarn](https://yarnpkg.com)              | package manager that doubles down as project manager | -         | proto            | proto               |

### Go

#### Command line interfaces

| Package                                                       | Description                                     | Lite mode | OSX installation | Debian installation |
| ------------------------------------------------------------- | ----------------------------------------------- | --------- | ---------------- | ------------------- |
| [cobra-cli](https://github.com/spf13/cobra)                   | cli build tool                                  | -         | go               | go                  |
| [go](https://go.dev)                                          | programming language                            | x         | proto            | proto               |
| [kubebuilder](https://github.com/kubernetes-sigs/kubebuilder) | sdk for building Kubernetes APIs using CRDs     | -         | homebrew         | apt                 |
| [kustomize](https://github.com/kubernetes-sigs/kustomize)     | customization of kubernetes YAML configurations | -         | homebrew         | apt                 |
| [operator-sdk](https://sdk.operatorframework.io)              | sdk for building Kubernetes applications        | -         | homebrew         | apt                 |

### AI

#### Applications

| Package                      | Description                                    | Lite mode | OSX installation  | Debian installation |
| ---------------------------- | ---------------------------------------------- | --------- | ----------------- | ------------------- |
| [ollama](https://ollama.com) | get up and running with large language models. | -         | homebrew *- cask* | shell               |

### Extras

#### Command line interfaces

| Package                                                      | Description               | Lite mode | OSX installation  | Debian installation |
| ------------------------------------------------------------ | ------------------------- | --------- | ----------------- | ------------------- |
| [audacity](https://www.audacityteam.org)                     | audio manipulation app    | -         | homebrew *- cask* | -                   |
| [discord](https://discord.com)                               | collaboration app         | -         | homebrew *- cask* | -                   |
| [raspberry-pi-imager](https://www.raspberrypi.org/downloads) | raspberrypi image manager | -         | homebrew *- cask* | -                   |
| [soulseek](https://slsknet.org)                              | file sharing app          | -         | homebrew *- cask* | -                   |
| [transmission](https://transmissionbt.com)                   | torrent client            | -         | homebrew *- cask* | -                   |
| [vlc](https://videolan.org)                                  | video player              | x         | homebrew *- cask* | -                   |

## Oh-my-zsh

Zsh is used as the default shell and is supplied with [oh-my-zsh](https://ohmyz.sh/) and a number of plugins which are listed below to enhance the shell experience :

- [aliases](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/aliases) *- list the shortcuts that are currently available.*
- [ansible](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ansible) *- add several aliases for useful ansible.*
- [brew](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/brew) *- add several aliases for common brew commands.*
- [bun](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/bun) *- set up completion for bun.*
- [colored-man-pages](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colored-man-pages) *- add colors to man pages.*
- [docker](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker) *- set up completion and aliases for docker commands.*
- [docker-compose](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker-compose) *- set up completion and aliases for docker-compose commands.*
- [gh](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gh) *- add completion for the GitHub cli.*
- [git](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git) *- provide many aliases and a few useful functions.*
- [gitignore](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gitignore) *- use of gitignore.io from the command line.*
- [golang](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/golang) *- set up completion and aliases for golang.*
- [helm](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/helm) *- set up completion and aliases for helm commands.*
- [kind](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kind) *- add completion for the Kind tool.*
- [kubectl](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl) *- add completion and aliases for kubectl commands.*
- [kubectx](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectx) *- show active kubectl context.*
- [microk8s](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/microk8s) *- provide completion and useful aliases for microk8s.*
- [minikube](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/minikube) *- set up completion for minikube.*
- [nmap](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/nmap) *- add some useful aliases for nmap.*
- [node](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/node) *- add node-docs function that opens proper section in nodejs doc.*
- [npm](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/npm) *- provide completion as well as adding many useful aliases.*
- [oc](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/oc) *- provide completion for OC commands.*
- [rsync](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/rsync) *- add aliases for frequent rsync commands.*
- [scw](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/scw) *- add completion options for all scw commands.*
- [sudo](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo) *- prefix current/previous command with sudo by pressing esc twice.*
- [systemadmin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/systemadmin) *- add bunch of aliases and functions for sysadmins.*
- [terraform](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/terraform) *- add completion for terraform, as well as aliases and a prompt function.*

This configuration uses a [custom oh-my-zsh theme](./dotfiles/.oh-my-zsh/this-is-tobi.zsh-theme) that blends [gnzh theme](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#gnzh) with the [kube-ps1 plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kube-ps1).

## Cheatsheets

The setup scripts install [cheat](https://github.com/cheat/cheat) and add [a few extra sheets](https://github.com/this-is-tobi/cheatsheets) which can be listed with the command `cheat -l -p personal`.

## Functions

In addition, this installation script adds an [utility functions](https://github.com/this-is-tobi/dotfiles/blob/main/dotfiles/.config/dotfiles/functions.sh) file and source it to use it locally, following functions are declared :

| Name      | Description                                                            |
| --------- | ---------------------------------------------------------------------- |
| `lsfn`    | *list all available functions and their helpers.*                      |
| `b64d`    | *decode base64 string.*                                                |
| `b64e`    | *encode base64 string.*                                                |
| `browser` | *start a browsh web browser (terminal browser) using docker.*          |
| `dks`     | *decode a kubernetes secret by its name and optionally its namespace.* |
| `kbp`     | *kill the process running on a given port.*                            |
| `tools`   | *use personal shell tool scripts.*                                     |
| `urld`    | *url decode the given string.*                                         |
| `urle`    | *url encode the given string.*                                         |
| `weather` | *check the weather for a current location.*                            |

The `tools` function allows you to execute on-the-fly my list of [utility scripts](https://github.com/this-is-tobi/tools/tree/main/shell) available on Github. To use this function, type the following command :

```sh
# To list all available scripts
tools

# To print the helper of a given script
tools <script_name> -h
```

> [!TIP]
> The function is covered by auto-completion, type `tools` then `<tab>` to see the list of scripts.

## Further utilities

- Check out [Arkade](https://github.com/alexellis/arkade) for more devops tools.
