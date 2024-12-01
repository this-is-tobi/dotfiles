# Dotfiles :wrench:

This project aims to provide dotfiles templates and common scripts for backup & setup.

## Dotfiles

The `dotfiles/` folder provides the following dotfiles templates :

```sh
./dotfiles
├── .config
│   ├── cheat
│   │   └── conf.yml
│   ├── lazygit
│   │   └── config.yml
│   └── nvim
│       ├── init.lua
│       └── lua
│           ├── config
│           └── plugins
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

It can install severals profiles in addition to the core install by providing `-p <profile_name>` *(example: `./setup-osx.sh -p devops`)*. The following profiles are available :
- [base](#base) *- base packages.*
- [ai](#ia) *- ai oriented packages.*
- [devops](#devops) *- devops oriented packages.*
- [go](#go) *- go developer oriented packages.*
- [js](#javascript) *- js developer oriented packages.*
- [secops](#secops) *- secops oriented packages.*
- [extras](#extras) *- extras personnal packages (only available for osx).*

> [!TIP]
> *For more infos use `-h` flag with the script to print help.*

CLI completions are referenced and installed via [this file](./setup/completions.sh).

> *Packages can come from different sources such as homebrew, apt, npm, etc...*

> *Apt come with [WakeMeOps](https://docs.wakemeops.com/) repository.*

### Base

| Package                                                              | Description                                          | Type    | OSX installation  | Debian installation |
| -------------------------------------------------------------------- | ---------------------------------------------------- | ------- | ----------------- | ------------------- |
| [bat](https://github.com/sharkdp/bat)                                | cat command enhanced                                 | cli     | homebrew          | apt                 |
| [bat-extras](https://github.com/eth-p/bat-extras)                    | bat combo with other commands                        | cli     | homebrew          | shell               |
| [chafa](https://hpjansson.org/chafa)                                 | image viewer in terminal                             | cli     | homebrew          | apt                 |
| [cheat](https://github.com/cheat/cheat)                              | create and view interactive cheat sheets             | cli     | homebrew          | apt                 |
| [coreutils](https://www.gnu.org/software/coreutils)                  | basic file, shell and text manipulation utilities    | cli     | homebrew          | apt                 |
| [docker](https://www.docker.com)                                     | docker engine                                        | cli     | -                 | shell               |
| [exiftool](https://exiftool.org)                                     | metadata writer and reader tool                      | cli     | homebrew          | apt                 |
| [eza](https://eza.rocks)                                             | ls command enhanced                                  | cli     | homebrew          | apt                 |
| [fd](https://github.com/sharkdp/fd)                                  | simple, fast and user-friendly alternative to 'find' | cli     | homebrew          | apt                 |
| [ffmpeg](https://ffmpeg.org)                                         | audio video manipulation tool                        | cli     | homebrew          | apt                 |
| [fzf](https://github.com/junegunn/fzf)                               | command-line fuzzy finder                            | cli     | homebrew          | apt                 |
| [gh](https://cli.github.com)                                         | github cli                                           | cli     | homebrew          | apt                 |
| [glab](https://gitlab.com/gitlab-org/cli)                            | gitlab cli                                           | cli     | homebrew          | apt                 |
| [glow](https://github.com/charmbracelet/glow)                        | render markdown on the CLI, with pizzazz             | cli     | homebrew          | apt                 |
| [gnupg](https://gnupg.org)                                           | encryption tool                                      | cli     | homebrew          | apt                 |
| [gsed](https://www.gnu.org/software/sed)                             | non-interactive command-line text editor             | cli     | homebrew          | -                   |
| [jq](https://stedolan.github.io/jq)                                  | json processor tool                                  | cli     | homebrew          | apt                 |
| [lazydocker](https://github.com/jesseduffield/lazydocker)            | lazier way to manage everything docker               | cli     | homebrew          | apt                 |
| [lazygit](https://github.com/jesseduffield/lazygit)                  | lazier way to manage everything git                  | cli     | homebrew          | shell               |
| [nmap](https://nmap.org)                                             | port scanning utility                                | cli     | homebrew          | apt                 |
| [nvim](https://neovim.io)                                            | interactive cli ide (enhanced vim)                   | cli     | homebrew          | shell               |
| [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)                      | zsh configuration manager                            | cli     | shell             | shell               |
| [proto](https://moonrepo.dev/proto)                                  | pluggable multi-language version manager             | cli     | homebrew          | shell               |
| [ripgrep](https://github.com/BurntSushi/ripgrep)                     | regex pattern search cli (usefull for bat-extras)    | cli     | homebrew          | apt                 |
| [rsync](https://rsync.samba.org)                                     | file transfer tool                                   | cli     | homebrew          | apt                 |
| [sshs](https://github.com/quantumsheep/sshs)                         | interactive cli ssh client                           | cli     | homebrew          | shell               |
| [tldr++](https://github.com/isacikgoz/tldr)                          | cheatsheet interactive cli                           | cli     | homebrew          | go                  |
| [tree](https://mama.indstate.edu/users/ice/tree)                     | filesystem display as tree                           | cli     | homebrew          | apt                 |
| [ttyd](https://github.com/tsl0922/ttyd)                              | share terminal over the web                          | cli     | homebrew          | shell               |
| [vhs](https://github.com/charmbracelet/vhs)                          | cli home video recorder                              | cli     | homebrew          | apt                 |
| [vim](https://www.vim.org)                                           | cli ide                                              | cli     | homebrew          | apt                 |
| [watch](https://en.wikipedia.org/wiki/Watch_(command))               | cli tool that runs the specified command repeatedly  | cli     | homebrew          | apt                 |
| [wget](https://www.gnu.org/software/wget)                            | internet file retriever                              | cli     | homebrew          | apt                 |
| [yq](https://github.com/mikefarah/yq)                                | yaml processor tool                                  | cli     | homebrew          | apt                 |
| [brave](https://brave.com/fr)                                        | privacy compliant web browser                        | desktop | homebrew *- cask* | -                   |
| [docker](https://www.docker.com/products/docker-desktop)             | docker desktop                                       | desktop | homebrew *- cask* | -                   |
| [firefox](https://www.mozilla.org/firefox)                           | privacy compliant web browser                        | desktop | homebrew *- cask* | -                   |
| [insomnia](https://insomnia.rest)                                    | http and graphql client                              | desktop | homebrew *- cask* | -                   |
| [mattermost](https://mattermost.com)                                 | collaboration app                                    | desktop | homebrew *- cask* | -                   |
| [openvpn-connect](https://openvpn.net/client-connect-vpn-for-mac-os) | vpn client                                           | desktop | homebrew *- cask* | -                   |
| [vscode](https://code.visualstudio.com)                              | ide                                                  | desktop | homebrew *- cask* | -                   |

### Devops

| Package                                                          | Description                                                     | Type | OSX installation | Debian installation |
| ---------------------------------------------------------------- | --------------------------------------------------------------- | ---- | ---------------- | ------------------- |
| [act](https://github.com/nektos/act)                             | local github actions                                            | cli  | homebrew         | apt                 |
| [ansible](https://docs.ansible.com/)                             | automation tool                                                 | cli  | homebrew         | pip                 |
| [argo](https://argo-cd.readthedocs.io/en/stable/)                | argo-workflows cli                                              | cli  | homebrew         | apt                 |
| [argocd](https://argo-cd.readthedocs.io/en/stable/)              | argo-cd cli                                                     | cli  | homebrew         | apt                 |
| [aws](https://aws.amazon.com/fr/cli/)                            | aws cli                                                         | cli  | homebrew         | shell               |
| [coder](https://coder.com/)                                      | coder cli                                                       | cli  | homebrew         | shell               |
| [helm](https://helm.sh/)                                         | kubernetes package manager                                      | cli  | homebrew         | apt                 |
| [helm-docs](https://github.com/norwoodj/helm-docs)               | tool for auto generating markdown docs for helm charts          | cli  | homebrew         | apt                 |
| [k6](https://k6.io/)                                             | modern load testing tool, using Go and javascript               | cli  | homebrew         | apt                 |
| [k9s](https://k9scli.io/)                                        | kubernetes cluster manager cli                                  | cli  | homebrew         | apt                 |
| [kind](https://kind.sigs.k8s.io/)                                | kubernetes cluster in docker                                    | cli  | homebrew         | apt                 |
| [krew](https://sigs.k8s.io/krew/)                                | kubectl plugin manager                                          | cli  | homebrew         | apt                 |
| [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/) | kubernetes cli                                                  | cli  | homebrew         | apt                 |
| [kubectx](https://github.com/ahmetb/kubectx)                     | kubernetes context and namespace manager                        | cli  | homebrew         | apt                 |
| [mc](https://github.com/minio/mc)                                | commands replacement for object storage (minio cli)             | cli  | homebrew         | apt                 |
| [mkcert](https://github.com/FiloSottile/mkcert)                  | simple zero-config tool to make locally trusted certificates    | cli  | homebrew         | shell               |
| [oc](https://www.openshift.com/)                                 | openshift cli                                                   | cli  | homebrew         | shell               |
| [scw](https://github.com/scaleway/scaleway-cli)                  | scaleway cli                                                    | cli  | homebrew         | apt                 |
| [sshpass](https://sourceforge.net/projects/sshpass/)             | non-interactive ssh password auth                               | cli  | homebrew         | apt                 |
| [teleport](https://goteleport.com/)                              | modern ssh server for teams managing distributed infrastructure | cli  | homebrew         | apt                 |
| [terraform](https://www.terraform.io/)                           | infrastructure automation tool                                  | cli  | homebrew         | apt                 |
| [velero](https://velero.io/)                                     | kubernetes backup and migration cli                             | cli  | homebrew         | apt                 |

#### Krew plugins (kubectl)

| Plugin                                                        | Description                                              |
| ------------------------------------------------------------- | -------------------------------------------------------- |
| [cert-manager](https://cert-manager.io/docs/reference/cmctl/) | cert-manager cli                                         |
| [cnpg](https://github.com/cloudnative-pg/cloudnative-pg)      | cloud native postgres cli                                |
| [df-pv](https://github.com/yashbhutwala/kubectl-df-pv)        | df utility for pv                                        |
| [ktop](https://github.com/vladimirvivien/ktop)                | top-like tool for Kubernetes clusters                    |
| [neat](https://github.com/itaysk/kubectl-neat)                | kubernetes yaml/json output clean up to make it readable |
| [stern](https://github.com/stern/stern)                       | multi pod and container log tailing for Kubernetes       |

### Secops

| Package                                        | Description                                                 | Type | OSX installation | Debian installation |
| ---------------------------------------------- | ----------------------------------------------------------- | ---- | ---------------- | ------------------- |
| [age](https://github.com/FiloSottile/age)      | simple, modern and secure encryption tool                   | cli  | homebrew         | apt                 |
| [cosign](https://docs.sigstore.dev)            | code signing and transparency for containers and binaries   | cli  | homebrew         | apt                 |
| [dive](https://github.com/wagoodman/dive)      | tool for exploring each layer in a docker image             | cli  | homebrew         | apt                 |
| [sops](https://github.com/getsops/sops)        | simple and flexible tool for managing secrets               | cli  | homebrew         | apt                 |
| [trivy](https://aquasecurity.github.io/trivy/) | vulnerability scanner for container images and file systems | cli  | homebrew         | apt                 |
| [vault](https://vaultproject.io/)              | vault cli                                                   | cli  | homebrew         | apt                 |

#### Krew plugins (kubectl)

| Plugin                                               | Description                  |
| ---------------------------------------------------- | ---------------------------- |
| [kubescape](https://github.com/kubescape/kubescape/) | kubernetes security scan     |
| [kyverno](https://github.com/kyverno/kyverno)        | kubernetes policy management |

### Javascript

| Package                                  | Description                                          | Type | OSX installation | Debian installation |
| ---------------------------------------- | ---------------------------------------------------- | ---- | ---------------- | ------------------- |
| [@antfu/ni](https://github.com/antfu/ni) | javascript package manager wrapper                   | cli  | npm              | npm                 |
| [bun](https://bun.sh/)                   | javascript runtime environment                       | cli  | proto            | proto               |
| [node](https://nodejs.org/)              | javascript runtime environment                       | cli  | proto            | proto               |
| [pnpm](https://pnpm.io/)                 | javascript disk space efficient package manager      | cli  | proto            | proto               |
| [yarn](https://yarnpkg.com/)             | package manager that doubles down as project manager | cli  | proto            | proto               |

### Go

| Package                                                       | Description                                     | Type | OSX installation | Debian installation |
| ------------------------------------------------------------- | ----------------------------------------------- | ---- | ---------------- | ------------------- |
| [cobra-cli](https://github.com/spf13/cobra)                   | cli build tool                                  | cli  | go               | go                  |
| [go](https://go.dev/)                                         | programming language                            | cli  | proto            | proto               |
| [kubebuilder](https://github.com/kubernetes-sigs/kubebuilder) | sdk for building Kubernetes APIs using CRDs     | cli  | homebrew         | apt                 |
| [kustomize](https://github.com/kubernetes-sigs/kustomize)     | customization of kubernetes YAML configurations | cli  | homebrew         | apt                 |
| [operator-sdk](https://sdk.operatorframework.io)              | sdk for building Kubernetes applications        | cli  | homebrew         | apt                 |

### AI

| Package                      | Description                                    | Type | OSX installation  | Debian installation |
| ---------------------------- | ---------------------------------------------- | ---- | ----------------- | ------------------- |
| [ollama](https://ollama.com) | get up and running with large language models. | cli  | homebrew *- cask* | shell               |

### Extras

| Package                                                       | Description               | Type    | OSX installation  | Debian installation |
| ------------------------------------------------------------- | ------------------------- | ------- | ----------------- | ------------------- |
| [audacity](https://www.audacityteam.org/)                     | audio manipulation app    | desktop | homebrew *- cask* | -                   |
| [discord](https://discord.com/)                               | collaboration app         | desktop | homebrew *- cask* | -                   |
| [raspberry-pi-imager](https://www.raspberrypi.org/downloads/) | raspberrypi image manager | desktop | homebrew *- cask* | -                   |
| [soulseek](https://slsknet.org/)                              | file sharing app          | desktop | homebrew *- cask* | -                   |
| [transmission](https://transmissionbt.com/)                   | torrent client            | desktop | homebrew *- cask* | -                   |
| [vlc](https://videolan.org/)                                  | video player              | desktop | homebrew *- cask* | -                   |

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

In addition, this installation script adds a [utility functions](https://github.com/this-is-tobi/dotfiles/blob/main/dotfiles/.config/dotfiles/functions.sh) file that can be used locally, as well as a tools function that allows you to execute on-the-fly my list of [utility scripts](https://github.com/this-is-tobi/tools/tree/main/shell) available on Github. To use this function, type the following command :

```sh
tools <script_name> -h
```

> [!TIP]
> The function is covered by auto-completion, type `tools` then tab to see the list of scripts.

## Further utilities

- Check out [Arkade](https://github.com/alexellis/arkade) for more devops tools.
