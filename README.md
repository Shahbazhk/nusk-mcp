<div align="center">

<img src="assets/logo-mark.svg" alt="Nusk logo" width="72">

# Nusk MCP

**Let your AI agent read and update your projects.**<br>
A remote [MCP](https://modelcontextprotocol.io) server for [Nusk](https://nusk.dev/?utm_source=github&utm_medium=readme&utm_campaign=nusk-mcp), a project management tool with sprints, Gantt schedules, RAID logs and a wiki.

[![License: MIT](https://img.shields.io/badge/license-MIT-2563eb.svg)](LICENSE)
[![MCP](https://img.shields.io/badge/MCP-streamable%20HTTP-6a45f5.svg)](https://modelcontextprotocol.io)
[![Tools](https://img.shields.io/badge/tools-30-0b1f3a.svg)](#tools)
[![Website](https://img.shields.io/badge/nusk.dev-visit-2563eb.svg)](https://nusk.dev/mcp?utm_source=github&utm_medium=badge&utm_campaign=nusk-mcp)

<img src="assets/social-preview.png" alt="An agent asks for the top risks on a project and gets a ranked list from Nusk" width="720">

</div>

## What this is

Nusk is where your team keeps tasks, schedules, risks and docs. This server lets an AI agent, such as Claude Code, Cursor or Codex, work with that same data from your editor or terminal. You skip the copy and paste between the tracker and the chat.

Ask things like:

- "What is on my plate this week?"
- "What are the top risks on project HQ?"
- "Which tasks are on the critical path?"
- "Create a task under HQ-12 for the login timeout bug and add it to the current sprint."

The server runs on nusk.dev. This repository holds the setup guide, config examples and the registry file. There is no code to install.

## Quick start

You need a Nusk workspace. If you don't have one, [create one](https://nusk.dev/signup?utm_source=github&utm_medium=readme&utm_campaign=nusk-mcp).

**1. Create a token.** In Nusk, open **Profile → API tokens** and create one. Start with **read-only**. The token is shown once, so copy it.

**2. Connect your agent.** Replace `YOUR-WORKSPACE` with your workspace name (the part after `nusk.dev/` in the address bar).

Claude Code:

```bash
claude mcp add --transport http nuskpm \
  https://nusk.dev/YOUR-WORKSPACE/api/mcp \
  --header "Authorization: Bearer nusk_..."
```

Cursor and other clients that read `mcp.json` ([file](examples/cursor-mcp.json)):

```json
{
  "mcpServers": {
    "nuskpm": {
      "url": "https://nusk.dev/YOUR-WORKSPACE/api/mcp",
      "headers": { "Authorization": "Bearer nusk_..." }
    }
  }
}
```

Codex, in `~/.codex/config.toml` ([file](examples/codex-config.toml)):

```toml
[mcp_servers.nuskpm]
url = "https://nusk.dev/YOUR-WORKSPACE/api/mcp"
bearer_token_env_var = "NUSKPM_TOKEN"
```

Any client that supports remote HTTP MCP servers with a bearer header should work the same way.

**3. Ask a question.** Try `list my projects`. If the agent answers with your project codes, you're connected.

Self-hosting Nusk? The address is `https://<your-server>/api/mcp`.

## What it looks like

These are real screens from the sample workspace the tools read from.

| | |
|---|---|
| ![Portfolio overview with progress, milestones and work item charts](assets/portfolio.png) | ![Gantt chart with critical path and task dependencies](assets/gantt.png) |
| **Portfolio.** Progress across all projects. | **Gantt.** Dependencies, float and critical path (`get_schedule`). |
| ![Sprint velocity chart and sprint list](assets/sprints.png) | ![RAID log with a risk heat map and ranked risks](assets/raid.png) |
| **Sprints.** Velocity and sprint contents (`list_sprints`). | **RAID.** Risks, issues, assumptions, dependencies (`list_risks`). |

## Tools

30 tools. Sixteen only read data. Fourteen change data and are hidden when you use a read-only token.

### Read

| Tool | What it does |
|---|---|
| `list_projects` | Projects you belong to, with your role |
| `list_templates` | Built-in and saved project templates |
| `my_work` | Your open work items, soonest due first |
| `search` | Find work items by words in the title or key |
| `list_work_items` | Work items, filtered by status, owner, sprint or type |
| `get_work_item` | One item in full: description, acceptance criteria, parent, children, comments |
| `work_item_options` | Allowed types, priorities and statuses |
| `list_sprints` | Sprints with dates, status and done/total counts |
| `list_risks` | Risks, highest score first |
| `list_issues` | Issues |
| `list_assumptions` | Assumptions |
| `list_dependencies` | Dependencies |
| `get_schedule` | Dates, durations, float and critical flags, plus the work calendar |
| `list_wiki_pages` | The wiki page tree |
| `get_wiki_page` | One page, its path, child pages and backlinks |
| `import_status` | Recent imports and whether they were rolled back |

### Write

| Tool | What it does |
|---|---|
| `create_project` | Create a project. You become its admin |
| `create_work_item`, `create_work_items` | Create one or many work items |
| `update_work_item` | Change fields on an item |
| `move_to_iteration` | Move items between sprints |
| `add_comment` | Comment on an item |
| `add_risk`, `add_issue`, `add_assumption`, `add_dependency` | Add RAID entries |
| `create_minutes_action_items` | Turn meeting-minute actions into tasks |
| `create_wiki_page` | Create a wiki page, optionally from a template |
| `reschedule_project` | Recalculate dates from dependencies and the work calendar |
| `delete_work_item` | Delete one item. Needs the delete permission |

Projects are named by their two-letter code, for example `HQ`. Work items use keys such as `HQ-0012`.

## Safety

- **The agent is you.** It has your project roles and nothing more. It cannot see or change what you can't.
- **Read-only tokens** expose only the read tools.
- **Tokens expire.** You choose the expiry, and you can revoke a token any time under Profile → API tokens.
- **Changes are traceable.** Edits made through MCP are marked "via AI agent (MCP)" in revision history and can be reverted.
- **Rate limit:** 600 requests per minute per token.

Treat a token like a password. Don't commit it. Use an environment variable where your client supports it, as in the Codex example.

## Troubleshooting

| You see | Fix |
|---|---|
| `Use a personal access token (Profile > API tokens)` | The header is missing, or the token doesn't start with `nusk_`. |
| `No project XX (list_projects shows yours)` | Wrong project code, or you aren't a member. Run `list_projects`. |
| Agent only offers read tools | The token is read-only. Create a read-and-write token. |
| 404 on the URL | Check the workspace name in the address. |

## Try Nusk without installing anything

- [Live demo](https://nusk.dev/demo?utm_source=github&utm_medium=readme&utm_campaign=nusk-mcp): a sample workspace with three projects, no signup. It lasts one hour. Connecting an agent needs your own workspace.
- [Full MCP guide](https://nusk.dev/mcp?utm_source=github&utm_medium=readme&utm_campaign=nusk-mcp)
- [Features](https://nusk.dev/features?utm_source=github&utm_medium=readme&utm_campaign=nusk-mcp)
- [Jira alternative](https://nusk.dev/jira-alternative?utm_source=github&utm_medium=readme&utm_campaign=nusk-mcp): how Nusk compares and how to import your Jira issues
- [Self-hosted option](https://nusk.dev/self-hosted?utm_source=github&utm_medium=readme&utm_campaign=nusk-mcp): run Nusk on your own servers
- [Learn project management](https://nusk.dev/learn-project-management?utm_source=github&utm_medium=readme&utm_campaign=nusk-mcp)

## Feedback

Missing a tool? Something broke? [Open an issue](../../issues/new/choose). A bug report with the tool name and the error text gets fixed fastest. If Nusk is useful to you, a star helps other people find it.

## License

The docs and examples in this repository are MIT licensed ([LICENSE](LICENSE)). The Nusk service, name and logo are not part of that license.
