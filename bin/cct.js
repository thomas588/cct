#!/usr/bin/env node

const { init } = require('../lib/init');
const { version } = require('../package.json');

const args = process.argv.slice(2);
const command = args[0];

if (command === 'init') {
  const name = args[1] || '.';
  init(name);
} else if (command === '--version' || command === '-v') {
  console.log(`cct v${version}`);
} else if (command === '--help' || command === '-h' || !command) {
  console.log(`
CCT - Claude Code Team v${version}

Usage:
  cct init <name>     Create new CCT project
  cct init .          Initialize in current folder
  cct --version       Show version
  cct --help          Show this help

Example:
  cct init my-startup
  cd my-startup
  claude --dangerously-skip-permissions
`);
} else {
  console.error(`Unknown command: ${command}`);
  console.log('Run "cct --help" for usage');
  process.exit(1);
}
