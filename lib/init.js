const fs = require('fs');
const path = require('path');

function init(name) {
  const targetDir = name === '.' ? process.cwd() : path.join(process.cwd(), name);
  const templatesDir = path.join(__dirname, '..', 'templates');

  // Create directory if not exists
  if (name !== '.' && !fs.existsSync(targetDir)) {
    fs.mkdirSync(targetDir, { recursive: true });
  }

  // Create folder structure
  const folders = ['features', 'leads', '.context', '.outputs', '.sessions'];
  for (const folder of folders) {
    const dir = path.join(targetDir, folder);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
  }

  // Copy CLAUDE.md (orchestrator)
  const orchestratorSrc = path.join(templatesDir, 'orchestrator.md');
  const orchestratorDest = path.join(targetDir, 'CLAUDE.md');
  if (fs.existsSync(orchestratorSrc)) {
    fs.copyFileSync(orchestratorSrc, orchestratorDest);
  }

  // Copy lead template to templates/ in project (for orchestrator to use)
  const projectTemplatesDir = path.join(targetDir, 'templates');
  if (!fs.existsSync(projectTemplatesDir)) {
    fs.mkdirSync(projectTemplatesDir, { recursive: true });
  }
  const leadSrc = path.join(templatesDir, 'lead.md');
  const leadDest = path.join(projectTemplatesDir, 'lead.md');
  if (fs.existsSync(leadSrc)) {
    fs.copyFileSync(leadSrc, leadDest);
  }

  // Copy all feature files
  const featureFiles = ['agents.md', 'skills.md', 'commands.md', 'mcps.md', 'TEMPLATE.md'];
  for (const file of featureFiles) {
    const src = path.join(templatesDir, file);
    const dest = path.join(targetDir, 'features', file);
    if (fs.existsSync(src)) {
      fs.copyFileSync(src, dest);
    }
  }

  const displayPath = name === '.' ? 'current directory' : name;
  console.log(`
✅ CCT project initialized: ${displayPath}

Created:
  CLAUDE.md          - Orchestrator instructions
  features/          - Agent, skill, MCP catalog
  leads/             - Team leads (orchestrator creates)
  templates/lead.md  - Lead template
  .context/          - Shared project context
  .outputs/          - Lead outputs
  .sessions/         - Session IDs

Hierarchy:
  Orchestrator → Leads → Workers

Next steps:
  ${name !== '.' ? `cd ${name}` : ''}
  claude --dangerously-skip-permissions

Then give the orchestrator a task!
`);
}

module.exports = { init };
