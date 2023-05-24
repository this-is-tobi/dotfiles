# Dotfiles :wrench:

This project aims to provide dotfiles templates and common scripts for backup & setup.

## Dotfiles

The `dotfiles/` folder provides the following dotfiles templates :

```txt
├── .gitconfig
├── .vscode
│   ├── extensions.json
│   └── settings.json
└── .zshrc
```

## Backup

These scripts are intended to backup common files to another directory (local or remote) :
- [backup-osx.sh](./backup/backup-osx.sh)
- [backup-debian.sh](./backup/backup-osx.sh)

> For more infos use `-h` flag with the script to print help.

## Setup

These scripts are intended to install common packages on proper os :
- [setup-osx.sh](./setup/setup-osx.sh)
- [setup-debian.sh](./setup/setup-debian.sh)

It can install severals profiles in addition to the core install by providing `-p <profile_name>` *(example: `./setup-osx.sh -p devops`)*. The following additional profiles are available :
- [base](#base) *- base packages*
- [devops](#devops) *- devops oriented packages*
- [extras](#extras) *- extras personnal packages (only available for osx)*
- [js](#javascript) *- js developer oriented packages*

> For more infos use `-h` flag with the script to print help.

> Packages can come from different sources such as homebrew, apt, npm, etc...

> Apt come with [WakeMeOps](https://docs.wakemeops.com/) repository.

### Base

| Package                                                               | Description                                       | Type    | OSX installation  | Debian installation |
| --------------------------------------------------------------------- | ------------------------------------------------- | ------- | ----------------- | ------------------- |
| [bat](https://github.com/sharkdp/bat)                                 | cat command enhanced                              | cli     | homebrew          | apt                 |
| [bat-extras](https://github.com/eth-p/bat-extras)                     | bat combo with other commands                     | cli     | homebrew          | shell               |
| [docker](https://www.docker.com/)                                     | docker engine                                     | cli     | -                 | shell               |
| [exa](https://the.exa.website)                                        | ls command enhanced                               | cli     | homebrew          | apt                 |
| [ffmpeg](https://ffmpeg.org/)                                         | audio video manipulation tool                     | cli     | homebrew          | apt                 |
| [gh](https://cli.github.com/)                                         | github cli                                        | cli     | homebrew          | apt                 |
| [glab](https://gitlab.com/gitlab-org/cli)                             | gitlab cli                                        | cli     | homebrew          | apt                 |
| [go](https://go.dev/)                                                 | programming language                              | cli     | homebrew          | apt                 |
| [gnupg](https://gnupg.org/)                                           | encryption tool                                   | cli     | homebrew          | apt                 |
| [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh/)                      | zsh configuration manager                         | cli     | shell             | shell               |
| [jq](https://stedolan.github.io/jq/)                                  | json processor tool                               | cli     | homebrew          | apt                 |
| [nmap](https://nmap.org/)                                             | port scanning utility                             | cli     | homebrew          | apt                 |
| [ripgrep](https://github.com/BurntSushi/ripgrep)                      | regex pattern search cli (usefull for bat-extras) | cli     | homebrew          | apt                 |
| [rsync](https://rsync.samba.org/)                                     | file transfer tool                                | cli     | homebrew          | apt                 |
| [tldr++](https://github.com/isacikgoz/tldr)                           | cheatsheet cli                                    | cli     | homebrew          | go                  |
| [tree](https://mama.indstate.edu/users/ice/tree/)                     | filesystem display as tree                        | cli     | homebrew          | apt                 |
| [vim](https://www.vim.org/)                                           | cli ide                                           | cli     | homebrew          | apt                 |
| [wget](https://www.gnu.org/software/wget/)                            | internet file retriever                           | cli     | homebrew          | apt                 |
| [yq](https://github.com/mikefarah/yq)                                 | yaml processor tool                               | cli     | homebrew          | apt                 |
| [brave](https://brave.com/fr/)                                        | privacy compliant web browser                     | desktop | homebrew *- cask* | -                   |
| [docker](https://www.docker.com/products/docker-desktop/)             | docker desktop                                    | desktop | homebrew *- cask* | -                   |
| [mattermost](https://mattermost.com/)                                 | collaboration app                                 | desktop | homebrew *- cask* | -                   |
| [openvpn-connect](https://openvpn.net/client-connect-vpn-for-mac-os/) | vpn client                                        | desktop | homebrew *- cask* | -                   |
| [vscode](https://code.visualstudio.com/)                              | ide                                               | desktop | homebrew *- cask* | -                   |

### Devops

| Package                                                          | Description                                                 | Type | OSX installation | Debian installation |
| ---------------------------------------------------------------- | ----------------------------------------------------------- | ---- | ---------------- | ------------------- |
| [act](https://github.com/nektos/act)                             | local github actions                                        | cli  | homebrew         | apt                 |
| [ansible](https://docs.ansible.com/)                             | automation tool                                             | cli  | homebrew         | shell               |
| [argocd](https://argo-cd.readthedocs.io/en/stable/)              | argocd cli                                                  | cli  | homebrew         | apt                 |
| [helm](https://helm.sh/)                                         | kubernetes package manager                                  | cli  | homebrew         | apt                 |
| [k9s](https://k9scli.io/)                                        | kubernetes cluster manager cli                              | cli  | homebrew         | apt                 |
| [kind](https://kind.sigs.k8s.io/)                                | kubernetes cluster in docker                                | cli  | homebrew         | apt                 |
| [krew](https://sigs.k8s.io/krew/)                                | kubectl plugin manager                                      | cli  | homebrew         | apt                 |
| [kubectx](https://github.com/ahmetb/kubectx)                     | kubernetes context and namespace manager                    | cli  | homebrew         | apt                 |
| [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/) | kubernetes cli                                              | cli  | homebrew         | apt                 |
| [mc](https://github.com/minio/mc)                                | commands replacement for object storage (minio cli)         | cli  | homebrew         | apt                 |
| [scalingo](https://doc.scalingo.com/)                            | scalingo cli                                                | cli  | shell            | shell               |
| [scw](https://github.com/scaleway/scaleway-cli)                  | scaleway cli                                                | cli  | homebrew         | apt                 |
| [terraform](https://www.terraform.io/)                           | infrastructure automation tool                              | cli  | homebrew         | apt                 |
| [trivy](https://aquasecurity.github.io/trivy/)                   | vulnerability scanner for container images and file systems | cli  | homebrew         | apt                 |
| [vault](https://vaultproject.io/)                                | vault cli                                                   | cli  | homebrew         | apt                 |

### Javascript

| Package                                     | Description                                     | Type    | OSX installation  | Debian installation |
| ------------------------------------------- | ----------------------------------------------- | ------- | ----------------- | ------------------- |
| [node](https://nodejs.org/)                 | javascript runtime environment                  | cli     | homebrew          | volta               |
| [pnpm](https://pnpm.io/fr/)                 | javascript disk space efficient package manager | cli     | homebrew          | npm                 |
| [volta](https://volta.sh/)                  | javascript tool manager                         | cli     | homebrew          | shell               |
| [@antfu/ni](https://github.com/antfu/ni)    | javascript package manager wrapper              | cli     | npm               | npm                 |
| [firefox](https://www.mozilla.org/firefox/) | privacy compliant web browser                   | desktop | homebrew *- cask* | -                   |
| [insomnia](https://insomnia.rest/)          | http and graphql client                         | desktop | homebrew *- cask* | -                   |

### Extras

| Package                                                       | Description               | Type    | OSX installation  | Debian installation |
| ------------------------------------------------------------- | ------------------------- | ------- | ----------------- | ------------------- |
| [audacity](https://www.audacityteam.org/)                     | audio manipulation app    | desktop | homebrew *- cask* | -                   |
| [discord](https://discord.com/)                               | collaboration app         | desktop | homebrew *- cask* | -                   |
| [raspberry-pi-imager](https://www.raspberrypi.org/downloads/) | raspberrypi image manager | desktop | homebrew *- cask* | -                   |
| [soulseek](https://slsknet.org/)                              | file sharing app          | desktop | homebrew *- cask* | -                   |
| [transmission](https://transmissionbt.com/)                   | torrent client            | desktop | homebrew *- cask* | -                   |
| [vlc](https://videolan.org/)                                  | video player              | desktop | homebrew *- cask* | -                   |

## Further utilities

- Check out [Arkade](https://github.com/alexellis/arkade) for more devops tools.
