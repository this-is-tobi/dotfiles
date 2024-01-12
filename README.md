# Dotfiles :wrench:

This project aims to provide dotfiles templates and common scripts for backup & setup.

## Dotfiles

The `dotfiles/` folder provides the following dotfiles templates :

```sh
./dotfiles
├── .vscode
│   ├── extensions.json
│   └── settings.json
├── .config
│   ├── lazygit
│   │   └── config.yml
│   └── nvim
│       └── lua
│           ├── config
│           ├── plugins
│           └── init.lua
├── .gitconfig
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

It can install severals profiles in addition to the core install by providing `-p <profile_name>` *(example: `./setup-osx.sh -p devops`)*. The following additional profiles are available :
- [base](#base) *- base packages*
- [devops](#devops) *- devops oriented packages*
- [extras](#extras) *- extras personnal packages (only available for osx)*
- [go](#go) *- go developer oriented packages*
- [js](#javascript) *- js developer oriented packages*

> *For more infos use `-h` flag with the script to print help.*

> *Packages can come from different sources such as homebrew, apt, npm, etc...*

> *Apt come with [WakeMeOps](https://docs.wakemeops.com/) repository.*

### Base

| Package                                                               | Description                                       | Type    | OSX installation  | Debian installation |
| --------------------------------------------------------------------- | ------------------------------------------------- | ------- | ----------------- | ------------------- |
| [age](https://github.com/FiloSottile/age)                             | simple, modern and secure encryption tool         | cli     | homebrew          | apt                 |
| [bat](https://github.com/sharkdp/bat)                                 | cat command enhanced                              | cli     | homebrew          | apt                 |
| [bat-extras](https://github.com/eth-p/bat-extras)                     | bat combo with other commands                     | cli     | homebrew          | shell               |
| [chafa](https://hpjansson.org/chafa/)                                 | image viewer in terminal                          | cli     | homebrew          | apt                 |
| [coreutils](https://www.gnu.org/software/coreutils/)                  | basic file, shell and text manipulation utilities | cli     | homebrew          | apt                 |
| [docker](https://www.docker.com/)                                     | docker engine                                     | cli     | -                 | shell               |
| [exa](https://the.exa.website)                                        | ls command enhanced                               | cli     | homebrew          | apt                 |
| [exiftool](https://exiftool.org/)                                     | metadata writer and reader tool                   | cli     | homebrew          | apt                 |
| [ffmpeg](https://ffmpeg.org/)                                         | audio video manipulation tool                     | cli     | homebrew          | apt                 |
| [fzf](https://github.com/junegunn/fzf)                                | command-line fuzzy finder                         | cli     | homebrew          | apt                 |
| [gh](https://cli.github.com/)                                         | github cli                                        | cli     | homebrew          | apt                 |
| [glab](https://gitlab.com/gitlab-org/cli)                             | gitlab cli                                        | cli     | homebrew          | apt                 |
| [gnupg](https://gnupg.org/)                                           | encryption tool                                   | cli     | homebrew          | apt                 |
| [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh/)                      | zsh configuration manager                         | cli     | shell             | shell               |
| [jq](https://stedolan.github.io/jq/)                                  | json processor tool                               | cli     | homebrew          | apt                 |
| [lazydocker](https://github.com/jesseduffield/lazydocker)             | lazier way to manage everything docker            | cli     | homebrew          | apt                 |
| [lazygit](https://github.com/jesseduffield/lazygit)                   | lazier way to manage everything git               | cli     | homebrew          | shell               |
| [nmap](https://nmap.org/)                                             | port scanning utility                             | cli     | homebrew          | apt                 |
| [nvim](https://neovim.io/)                                            | interactive cli ide (enhanced vim)                | cli     | homebrew          | shell               |
| [ripgrep](https://github.com/BurntSushi/ripgrep)                      | regex pattern search cli (usefull for bat-extras) | cli     | homebrew          | apt                 |
| [rsync](https://rsync.samba.org/)                                     | file transfer tool                                | cli     | homebrew          | apt                 |
| [tldr++](https://github.com/isacikgoz/tldr)                           | cheatsheet interactive cli                        | cli     | homebrew          | go                  |
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
| [coder](https://coder.com/)                                      | coder cli                                                   | cli  | homebrew         | shell               |
| [helm](https://helm.sh/)                                         | kubernetes package manager                                  | cli  | homebrew         | apt                 |
| [k9s](https://k9scli.io/)                                        | kubernetes cluster manager cli                              | cli  | homebrew         | apt                 |
| [kind](https://kind.sigs.k8s.io/)                                | kubernetes cluster in docker                                | cli  | homebrew         | apt                 |
| [krew](https://sigs.k8s.io/krew/)                                | kubectl plugin manager                                      | cli  | homebrew         | apt                 |
| [kubectx](https://github.com/ahmetb/kubectx)                     | kubernetes context and namespace manager                    | cli  | homebrew         | apt                 |
| [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/) | kubernetes cli                                              | cli  | homebrew         | apt                 |
| [mc](https://github.com/minio/mc)                                | commands replacement for object storage (minio cli)         | cli  | homebrew         | apt                 |
| [oc](https://www.openshift.com/)                                 | openshift cli                                               | cli  | homebrew         | -                   |
| [scw](https://github.com/scaleway/scaleway-cli)                  | scaleway cli                                                | cli  | homebrew         | apt                 |
| [sops](https://github.com/getsops/sops)                          | simple and flexible tool for managing secrets               | cli  | homebrew         | apt                 |
| [terraform](https://www.terraform.io/)                           | infrastructure automation tool                              | cli  | homebrew         | apt                 |
| [trivy](https://aquasecurity.github.io/trivy/)                   | vulnerability scanner for container images and file systems | cli  | homebrew         | apt                 |
| [vault](https://vaultproject.io/)                                | vault cli                                                   | cli  | homebrew         | apt                 |
| [velero](https://velero.io/)                                     | kubernetes backup and migration cli                         | cli  | homebrew         | apt                 |

#### Krew plugins (kubectl)

| Plugin                                                        | Description                                              |
| ------------------------------------------------------------- | -------------------------------------------------------- |
| [cert-manager](https://cert-manager.io/docs/reference/cmctl/) | cert-manager cli                                         |
| [cnpg](https://github.com/cloudnative-pg/cloudnative-pg)      | cloud native postgres cli                                |
| [ktop](https://github.com/vladimirvivien/ktop)                | top-like tool for Kubernetes clusters                    |
| [kubescape](https://github.com/kubescape/kubescape/)          | kubernetes security scan                                 |
| [kyverno](https://github.com/kyverno/kyverno)                 | kubernetes policy management                             |
| [neat](https://github.com/itaysk/kubectl-neat)                | kubernetes yaml/json output clean up to make it readable |

### Javascript

| Package                                     | Description                                     | Type    | OSX installation  | Debian installation |
| ------------------------------------------- | ----------------------------------------------- | ------- | ----------------- | ------------------- |
| [bun](https://bun.sh/)                      | javascript runtime environment                  | cli     | homebrew          | npm                 |
| [node](https://nodejs.org/)                 | javascript runtime environment                  | cli     | homebrew          | volta               |
| [pnpm](https://pnpm.io/fr/)                 | javascript disk space efficient package manager | cli     | homebrew          | npm                 |
| [volta](https://volta.sh/)                  | javascript tool manager                         | cli     | homebrew          | shell               |
| [@antfu/ni](https://github.com/antfu/ni)    | javascript package manager wrapper              | cli     | npm               | npm                 |
| [firefox](https://www.mozilla.org/firefox/) | privacy compliant web browser                   | desktop | homebrew *- cask* | -                   |
| [insomnia](https://insomnia.rest/)          | http and graphql client                         | desktop | homebrew *- cask* | -                   |

### Go

| Package                                                       | Description                                     | Type | OSX installation | Debian installation |
| ------------------------------------------------------------- | ----------------------------------------------- | ---- | ---------------- | ------------------- |
| [cobra-cli](https://github.com/spf13/cobra)                   | cli build tool                                  | cli  | go               | go                  |
| [go](https://go.dev/)                                         | programming language                            | cli  | homebrew         | shell               |
| [kubebuilder](https://github.com/kubernetes-sigs/kubebuilder) | sdk for building Kubernetes APIs using CRDs     | cli  | homebrew         | shell               |
| [kustomize](https://github.com/kubernetes-sigs/kustomize)     | customization of kubernetes YAML configurations | cli  | homebrew         | apt                 |
| [operator-sdk](https://sdk.operatorframework.io)              | sdk for building Kubernetes applications        | cli  | homebrew         | apt                 |

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
