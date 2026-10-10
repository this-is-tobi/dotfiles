# Environment loaded by .zshrc. Managed by the dotfiles setup: edits here are
# overwritten on the next run, so keep secrets and per-machine values in
# secrets.env instead (see secrets.env.example).

# secrets.env holds KEY=value lines; it is created once by the setup and never overwritten
if [ -r "$HOME/.config/dotfiles/secrets.env" ]; then
  set -a
  . "$HOME/.config/dotfiles/secrets.env"
  set +a
fi
