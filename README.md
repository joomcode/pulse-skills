# JoomPulse Skills

Public agent skills for working with JoomPulse.

This repository is a catalog of reusable skills that help AI agents turn
JoomPulse product and market data into practical workflows for Mercado Livre
sellers and teams.

## Install

In Claude Code, add the marketplace and install the plugin:

```bash
/plugin marketplace add joomcode/pulse-skills
/plugin install pulse-skills@joomcode
```

After installation, start a new session so the skill metadata is loaded.

## Prerequisites

The skills in this repository require JoomPulse MCP access. For product context,
account setup, and access requests, use the public JoomPulse site:

https://joompulse.com

## Skills

| Skill | What it does | Typical requests |
| --- | --- | --- |
| [`pulse-find-exact-same-product`](skills/pulse-find-exact-same-product/SKILL.md) | Finds product listings that appear to represent the same real-world product as a reference item. | "find the same product", "match this product", "find duplicate listings" |

## How These Skills Work

Each skill is a Markdown file with YAML frontmatter. The frontmatter tells the
agent when the skill is relevant; the body provides the workflow to follow once
the skill is triggered.

Skills should describe public behavior and user-visible workflow. They must not
publish private service names, credentials, internal paths, private URLs, or
implementation details that are not intended for external use.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Security

See [SECURITY.md](SECURITY.md).
