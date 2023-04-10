# Dotfiles :wrench:

The `dotfiles/` folder provides the following dotfiles templates :

```txt
├── .gitconfig
├── .vscode
│   ├── extensions.json
│   └── settings.json
└── .zshrc
```

## Backup

The script [backup-osx.sh](./backup/backup-osx.sh) is intended to backup common files to another directory (local or remote). 

> For more infos use `-h` flag with the script to print help.

## Setup

These scripts are intended to install common packages on proper os :
- [setup-osx.sh](./setup/setup-osx.sh)
- [setup-debian.sh](./setup/setup-debian.sh)

It can install severals profiles in addition to the [basic](#base) by providing `-p <profile_name>` *(example: `./setup-osx.sh -p devops`)*. The following additional profiles are available :
- [extras](#extras) *- extras personnal packages*
- [devops](#devops) *- devops oriented packages*
- [js](#javascript) *- js developer oriented packages*

> For more infos use `-h` flag with the script to print help.

> Packages can come from different sources such as homebrew, apt, npm, etc...

> Apt come with [WakeMeOps](https://docs.wakemeops.com/) repository.

### Base

__Terminal :__

| Package                                           | Description                                       | OSX installation | Debian installation |
| ------------------------------------------------- | ------------------------------------------------- | ---------------- | ------------------- |
| [bat](https://github.com/sharkdp/bat)             | cat command enhanced                              | homebrew         | apt                 |
| [bat-extras](https://github.com/eth-p/bat-extras) | bat combo with other commands                     | homebrew         | shell               |
| [docker](https://www.docker.com/)                 | docker engine                                     | -                | shell               |
| [exa](https://the.exa.website)                    | ls command enhanced                               | homebrew         | apt                 |
| [ffmpeg](https://ffmpeg.org/)                     | audio video manipulation tool                     | homebrew         | apt                 |
| [gh](https://cli.github.com/)                     | github cli                                        | homebrew         | apt                 |
| [glab](https://gitlab.com/gitlab-org/cli)         | gitlab cli                                        | homebrew         | apt                 |
| [go](https://go.dev/)                             | programming language                              | homebrew         | apt                 |
| [gnupg](https://gnupg.org/)                       | encryption tool                                   | homebrew         | apt                 |
| [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh/)  | zsh configuration manager                         | shell            | shell               |
| [jq](https://stedolan.github.io/jq/)              | json processor tool                               | homebrew         | apt                 |
| [nmap](https://nmap.org/)                         | port scanning utility                             | homebrew         | apt                 |
| [ripgrep](https://github.com/BurntSushi/ripgrep)  | regex pattern search cli (usefull for bat-extras) | homebrew         | apt                 |
| [rsync](https://rsync.samba.org/)                 | file transfer tool                                | homebrew         | apt                 |
| [tldr++](https://github.com/isacikgoz/tldr)       | cheatsheet cli                                    | homebrew         | go                  |
| [tree](https://mama.indstate.edu/users/ice/tree/) | filesystem display as tree                        | homebrew         | apt                 |
| [vim](https://www.vim.org/)                       | cli ide                                           | homebrew         | apt                 |
| [yq](https://github.com/mikefarah/yq)             | yaml processor tool                               | homebrew         | apt                 |

__Desktop :__

| Package                                                               | Description                   | OSX installation  | Debian installation |
| --------------------------------------------------------------------- | ----------------------------- | ----------------- | ------------------- |
| [brave](https://brave.com/fr/)                                        | privacy compliant web browser | homebrew *- cask* | -                   |
| [docker](https://www.docker.com/products/docker-desktop/)             | docker desktop                | homebrew *- cask* | -                   |
| [mattermost](https://mattermost.com/)                                 | collaboration app             | homebrew *- cask* | -                   |
| [openvpn-connect](https://openvpn.net/client-connect-vpn-for-mac-os/) | vpn client                    | homebrew *- cask* | -                   |
| [vscode](https://code.visualstudio.com/)                              | ide                           | homebrew *- cask* | -                   |

### Devops

__Terminal :__

| Package                                                          | Description                                                 | OSX installation | Debian installation |
| ---------------------------------------------------------------- | ----------------------------------------------------------- | ---------------- | ------------------- |
| [act](https://github.com/nektos/act)                             | local github actions                                        | homebrew         | apt                 |
| [argocd](https://argoproj.github.io/cd)                          | argocd cli                                                  | homebrew         | apt                 |
| [ansible](https://docs.ansible.com/)                             | automation tool                                             | homebrew         | shell               |
| [helm](https://helm.sh/)                                         | kubernetes package manager                                  | homebrew         | apt                 |
| [k9s](https://k9scli.io/)                                        | kubernetes cluster manager cli                              | homebrew         | apt                 |
| [kind](https://kind.sigs.k8s.io/)                                | kubernetes cluster in docker                                | homebrew         | apt                 |
| [krew](https://sigs.k8s.io/krew/)                                | kubectl plugin manager                                      | homebrew         | apt                 |
| [kubectx](https://github.com/ahmetb/kubectx)                     | kubernetes context and namespace manager                    | homebrew         | apt                 |
| [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/) | kubernetes cli                                              | homebrew         | apt                 |
| [mc](https://github.com/minio/mc)                                | commands replacement for object storage (minio cli)         | homebrew         | apt                 |
| [scalingo](https://doc.scalingo.com/)                            | scalingo cli                                                | shell            | shell               |
| [scw](https://github.com/scaleway/scaleway-cli)                  | scaleway cli                                                | homebrew         | apt                 |
| [terraform](https://www.terraform.io/)                           | infrastructure automation tool                              | homebrew         | apt                 |
| [trivy](https://aquasecurity.github.io/trivy/)                   | vulnerability scanner for container images and file systems | homebrew         | apt                 |
| [vault](https://vaultproject.io/)                                | vault cli                                                   | homebrew         | apt                 |

### Javascript

__Terminal :__

| Package                                  | Description                                     | OSX installation | Debian installation |
| ---------------------------------------- | ----------------------------------------------- | ---------------- | ------------------- |
| [node](https://nodejs.org/)              | javascript runtime environment                  | homebrew         | volta               |
| [pnpm](https://pnpm.io/fr/)              | javascript disk space efficient package manager | homebrew         | npm                 |
| [volta](https://volta.sh/)               | javascript tool manager                         | homebrew         | shell               |
| [@antfu/ni](https://github.com/antfu/ni) | javascript package manager wrapper              | npm              | npm                 |

__Desktop :__

| Package                                     | Description                   | OSX installation  | Debian installation |
| ------------------------------------------- | ----------------------------- | ----------------- | ------------------- |
| [firefox](https://www.mozilla.org/firefox/) | privacy compliant web browser | homebrew *- cask* | -                   |
| [insomnia](https://insomnia.rest/)          | http and graphql client       | homebrew *- cask* | -                   |

### Extras

__Desktop :__

| Package                                                       | Description               | OSX installation  | Debian installation |
| ------------------------------------------------------------- | ------------------------- | ----------------- | ------------------- |
| [audacity](https://www.audacityteam.org/)                     | audio manipulation app    | homebrew *- cask* | -                   |
| [discord](https://discord.com/)                               | collaboration app         | homebrew *- cask* | -                   |
| [raspberry-pi-imager](https://www.raspberrypi.org/downloads/) | raspberrypi image manager | homebrew *- cask* | -                   |
| [soulseek](https://slsknet.org/)                              | file sharing app          | homebrew *- cask* | -                   |
| [transmission](https://transmissionbt.com/)                   | torrent client            | homebrew *- cask* | -                   |
| [vlc](https://videolan.org/)                                  | video player              | homebrew *- cask* | -                   |
