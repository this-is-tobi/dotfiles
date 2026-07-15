// Shared fallback ESLint config for editors (Neovim, VS Code): used when the
// project being linted has no ESLint config of its own.
//
// This file doubles as a dispatcher: it looks for a local eslint.config.* in
// (and above, up to the git root of) the current working directory and, if
// found, defers to it instead. This lets it be registered unconditionally as
// a global "eslint.options.overrideConfigFile" (VS Code has no per-workspace
// hook to apply the override only when needed, unlike Neovim's lspconfig
// root_dir). Neovim's own lua/plugins/eslint.lua already only points here
// when no local config exists, so this dispatch is mostly a no-op safety net
// there, but it's load-bearing for VS Code.
//
// Falls back to https://github.com/this-is-tobi/template-monorepo-ts/blob/main/packages/eslint-config/src/index.ts
import { existsSync } from 'node:fs'
import path from 'node:path'
import antfu from '@antfu/eslint-config'
import { createJiti } from 'jiti'

const LOCAL_CONFIG_NAMES = [
  'eslint.config.js',
  'eslint.config.mjs',
  'eslint.config.cjs',
  'eslint.config.ts',
  'eslint.config.mts',
  'eslint.config.cts',
]

function findProjectRoot(startDir) {
  let dir = startDir
  while (true) {
    if (existsSync(path.join(dir, '.git'))) {
      return dir
    }
    const parent = path.dirname(dir)
    if (parent === dir) {
      return startDir
    }
    dir = parent
  }
}

function findLocalConfig(startDir) {
  const projectRoot = findProjectRoot(startDir)
  let dir = startDir
  while (true) {
    for (const name of LOCAL_CONFIG_NAMES) {
      const candidate = path.join(dir, name)
      if (existsSync(candidate)) {
        return candidate
      }
    }
    if (dir === projectRoot) {
      break
    }
    const parent = path.dirname(dir)
    if (parent === dir) {
      break
    }
    dir = parent
  }
  return undefined
}

async function loadConfig() {
  const localConfigPath = findLocalConfig(process.cwd())
  if (localConfigPath) {
    const jiti = createJiti(import.meta.url)
    return await jiti.import(localConfigPath, { default: true })
  }

  return antfu(
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
}

export default loadConfig()
