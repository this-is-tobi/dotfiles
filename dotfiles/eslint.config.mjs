// ESLint looks up its config from each linted file's folder upward, so a
// project's own config always wins, and files under the home directory that
// have none get the shared one (installed in ~/.config/eslint-fallback)
export { default } from './.config/eslint-fallback/eslint.config.mjs'
