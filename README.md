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

The script [setup-osx.sh](./setup/setup-osx.sh) is intended to install common packages on osx.
It can install severals profiles in addition to the [basic](#base) by providing `-p <profile_name>` *(example: `./setup-osx.sh -p devops`)*. The following additional profiles are available :
- [extras](#extras) *- extras personnal packages*
- [devops](#devops) *- devops oriented packages*
- [js](#javascript) *- js developer oriented packages*

> For more infos use `-h` flag with the script to print help.

*Packages can come from different sources such as homebrew, npm or shell installation.*

### OSX

#### Base

- Homebrew *- formulae* :
  - [bat](https://github.com/sharkdp/bat) *- cat command enhanced*
  - [bat-extras](https://github.com/eth-p/bat-extras) *- bat combo with other commands*
  - [exa](https://the.exa.website) *- ls command enhanced*
  - [ffmpeg](https://ffmpeg.org/) *- audio video manipulation tool*
  - [gh](https://cli.github.com/) *- github cli*
  - [glab](https://gitlab.com/gitlab-org/cli) *- gitlab cli*
  - [go](https://go.dev/) *- programming language*
  - [gnupg](https://gnupg.org/) *- encryption tool*
  - [jq](https://stedolan.github.io/jq/) *- json processor tool*
  - [nmap](https://nmap.org/) *- port scanning utility*
  - [ripgrep](https://github.com/BurntSushi/ripgrep) *- regex pattern search cli (usefull for bat-extras)*
  - [rsync](https://rsync.samba.org/) *- file transfer tool*
  - [tldr++](https://github.com/isacikgoz/tldr) *- cheatsheet cli*
  - [tor](https://www.torproject.org/) *- anonymizing overlay network for TCP*
  - [tree](https://mama.indstate.edu/users/ice/tree/) *- filesystem display as tree*
  - [vim](https://www.vim.org/) *- cli ide*
  - [yq](https://github.com/mikefarah/yq) *- yaml processor tool*

- Homebrew *- cask* :
  - [brave](https://brave.com/fr/) *- privacy compliant web browser*
  - [docker](https://www.docker.com/) *- container engine*
  - [mattermost](https://mattermost.com/) *- collaboration app*
  - [openvpn-connect](https://openvpn.net/client-connect-vpn-for-mac-os/) *- vpn client*
  - [vscode](https://code.visualstudio.com/) *- ide*

- Shell :
  - [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh/) *- zsh configuration manager*

#### Extras

- Homebrew *- cask* :
  - [audacity](https://www.audacityteam.org/) *- audio manipulation app*
  - [discord](https://discord.com/) *- collaboration app*
  - [raspberry-pi-imager](https://www.raspberrypi.org/downloads/) *- raspberrypi image manager*
  - [soulseek](https://slsknet.org/) *- file sharing app*
  - [transmission](https://transmissionbt.com/) *- torrent client*
  - [vlc](https://videolan.org/) *- video player*

#### Devops

- Homebrew *- formulae* :
  - [act](https://github.com/nektos/act) *- local github actions*
  - [argocd](https://argoproj.github.io/cd) *- argocd cli*
  - [ansible](https://docs.ansible.com/) *- automation tool*
  - [helm](https://helm.sh/) *- kubernetes package manager*
  - [k9s](https://k9scli.io/) *- kubernetes cluster manager cli*
  - [kind](https://kind.sigs.k8s.io/) *- kubernetes cluster in docker*
  - [krew](https://sigs.k8s.io/krew/) *- kubectl plugin manager*
  - [kubectx](https://github.com/ahmetb/kubectx) *- kubernetes context and namespace manager*
  - [kubernetes-cli](https://kubernetes.io/docs/reference/kubectl/kubectl/) *- kubernetes cli*
  - [terraform](https://www.terraform.io/) *- infrastructure automation tool*
  - [trivy](https://aquasecurity.github.io/trivy/) *- vulnerability scanner for container images and file systems*
  - [vault](https://vaultproject.io/) *- vault cli*

- Shell :
  - [scalingo](https://doc.scalingo.com/) *- scalingo cli*

#### Javascript

- Homebrew *- formulae* :
  - [node](https://nodejs.org/) *- javascript runtime environment*
  - [pnpm](https://pnpm.io/fr/) *- javascript disk space efficient package manager*
  - [volta](https://volta.sh/) *- javascript tool manager*

- Homebrew  *- cask* :
  - [firefox](https://www.mozilla.org/firefox/) *- privacy compliant web browser*
  - [insomnia](https://insomnia.rest/) *- http and graphql client*

- Npm :
  - [@antfu/ni](https://github.com/antfu/ni) *- javascript package manager wrapper*
