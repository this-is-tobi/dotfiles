// Shared ESLint config for projects without one of their own, used by Neovim,
// VS Code and the CLI. ~/eslint.config.mjs re-exports it. ESLint 10 looks up
// its config from each linted file's folder upward, so a project's own config
// is always found first and this one only serves files that have none. ESLint
// 9 looks up from the working directory instead: set
// ESLINT_FLAGS=v10_config_lookup_from_file to get the same behaviour. Projects
// still on .eslintrc under the home directory are ignored by ESLint 9/10 and
// linted with this config instead.
//
// Falls back to https://github.com/this-is-tobi/template-monorepo-ts/blob/main/packages/eslint-config/src/index.ts
import antfu from '@antfu/eslint-config'

export default antfu(
  {
    stylistic: {
      overrides: {
        'antfu/if-newline': 'off',
        'jsonc/sort-keys': 'off',
        'no-console': 'off',
        'style/comma-dangle': ['error', 'always-multiline'],
        'style/quote-props': ['error', 'as-needed', { keywords: false, unnecessary: true }],
        'style/brace-style': ['error', '1tbs', { allowSingleLine: true }],
        'style/max-statements-per-line': ['error', { max: 2 }],
        'ts/ban-ts-comment': 'off',
        'unicorn/error-message': 'off', // Disabled due to compatibility issue with ESLint 9.25+
        'unused-imports/no-unused-imports': 'error',
        'unused-imports/no-unused-vars': ['error', { vars: 'all', varsIgnorePattern: '^_', args: 'after-used', argsIgnorePattern: '^_', caughtErrors: 'all', caughtErrorsIgnorePattern: '^_', destructuredArrayIgnorePattern: '^_' }],
        'vue/no-v-html': 'off',
        'vue/no-irregular-whitespace': 'off',
        'vue/script-indent': 'off',
      },
    },
    typescript: true,
    yaml: {
      overrides: {
        'yaml/quotes': ['error', { prefer: 'double' }],
        'yaml/indent': ['error', 2, { indentBlockSequences: false }],
      },
    },
    ignores: [
      '**/node_modules',
      '**/pnpm-lock.yaml',
      '**/.turbo',
      '**/dist/',
      '**/types/',
      '**/coverage/',
      '**/playwright-report/',
      '**/test-results/',
      '**/templates/**/*.{yaml,yml}',
      '**/Chart.yaml',
      '**/*.d.ts',
      '**/*.md/*.js',
      '**/*.md/*.ts',
    ],
  },
).override('antfu/node/rules', {
  rules: {
    'node/prefer-global/process': ['error', 'always'],
    'node/prefer-global/console': ['error', 'always'],
    'node/prefer-global/buffer': ['error', 'always'],
  },
})
