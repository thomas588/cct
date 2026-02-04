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
  const folders = ['leads', 'workers', '.context', '.outputs', '.sessions', '.cct/hooks', '.claude/commands'];
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

  // Copy templates (lead, worker, roles catalog)
  const projectTemplatesDir = path.join(targetDir, 'templates');
  if (!fs.existsSync(projectTemplatesDir)) {
    fs.mkdirSync(projectTemplatesDir, { recursive: true });
  }

  const templateFiles = ['lead.md', 'worker.md', 'roles.yaml'];
  for (const file of templateFiles) {
    const src = path.join(templatesDir, file);
    const dest = path.join(projectTemplatesDir, file);
    if (fs.existsSync(src)) {
      fs.copyFileSync(src, dest);
    }
  }

  // Copy hooks
  const hooksSrcDir = path.join(templatesDir, 'hooks');
  const hooksDestDir = path.join(targetDir, '.cct', 'hooks');
  if (fs.existsSync(hooksSrcDir)) {
    const hookFiles = fs.readdirSync(hooksSrcDir);
    for (const file of hookFiles) {
      const src = path.join(hooksSrcDir, file);
      const dest = path.join(hooksDestDir, file);
      fs.copyFileSync(src, dest);
      fs.chmodSync(dest, '755');
    }
  }

  // Copy .claude/settings.json for hooks
  const claudeDir = path.join(targetDir, '.claude');
  const settingsSrc = path.join(templatesDir, 'settings.json');
  const settingsDest = path.join(claudeDir, 'settings.json');
  if (fs.existsSync(settingsSrc)) {
    fs.copyFileSync(settingsSrc, settingsDest);
  }

  // Copy commands to .claude/commands/
  const commandsSrcDir = path.join(templatesDir, 'commands');
  const commandsDestDir = path.join(claudeDir, 'commands');
  if (fs.existsSync(commandsSrcDir)) {
    const commandFiles = fs.readdirSync(commandsSrcDir);
    for (const file of commandFiles) {
      const src = path.join(commandsSrcDir, file);
      const dest = path.join(commandsDestDir, file);
      fs.copyFileSync(src, dest);
    }
  }

  const displayPath = name === '.' ? 'current directory' : name;
  console.log(`
✅ CCT project initialized: ${displayPath}

Structure:
  CLAUDE.md              - Orchestrator instructions
  .claude/
    settings.json        - Hooks config
    commands/            - Slash commands (11)
  .cct/hooks/            - Hook scripts
  templates/
    lead.md              - Lead template
    worker.md            - Worker template
    roles.yaml           - Roles catalog (44 entries)
  leads/                 - For Hierarchical mode
  workers/               - For Flat mode
  .context/              - Shared project context
  .outputs/              - Results + status files
  .sessions/             - Session IDs

Commands (type / to see autocomplete):
  /cct.flat              - Simple tasks (Orchestrator → Workers)
  /cct.full              - Complex tasks (Orchestrator → Leads → Workers)
  /cct.discover          - BA research phase
  /cct.design            - UX/UI design phase
  /cct.spec              - Specification phase
  /cct.architect         - Architecture phase
  /cct.implement         - Implementation phase
  /cct.test              - Testing phase
  /cct.docs              - Documentation phase
  /cct.review            - Review phase
  /cct.brainstorm        - Brainstorming session

Next:
  ${name !== '.' ? `cd ${name}` : ''}
  claude --dangerously-skip-permissions
`);
}

module.exports = { init };
