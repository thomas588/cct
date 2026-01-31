const fs = require('fs');
const path = require('path');

function init(name) {
  const targetDir = name === '.' ? process.cwd() : path.join(process.cwd(), name);
  const templatesDir = path.join(__dirname, '..', 'templates');

  // Create directory if not exists
  if (name !== '.' && !fs.existsSync(targetDir)) {
    fs.mkdirSync(targetDir, { recursive: true });
  }

  // Create features folder
  const featuresDir = path.join(targetDir, 'features');
  if (!fs.existsSync(featuresDir)) {
    fs.mkdirSync(featuresDir, { recursive: true });
  }

  // Copy CLAUDE.md (orchestrator)
  const orchestratorSrc = path.join(templatesDir, 'orchestrator.md');
  const orchestratorDest = path.join(targetDir, 'CLAUDE.md');

  if (fs.existsSync(orchestratorSrc)) {
    fs.copyFileSync(orchestratorSrc, orchestratorDest);
  }

  // Copy all feature files
  const featureFiles = ['agents.md', 'skills.md', 'commands.md', 'mcps.md', 'TEMPLATE.md'];
  for (const file of featureFiles) {
    const src = path.join(templatesDir, file);
    const dest = path.join(featuresDir, file);
    if (fs.existsSync(src)) {
      fs.copyFileSync(src, dest);
    }
  }

  const displayPath = name === '.' ? 'current directory' : name;
  console.log(`
✅ CCT project initialized: ${displayPath}

Created:
  CLAUDE.md        - Orchestrator instructions
  features/        - Agent & skill templates

Next steps:
  ${name !== '.' ? `cd ${name}` : ''}
  claude --dangerously-skip-permissions

Then give the orchestrator a task!
`);
}

module.exports = { init };
