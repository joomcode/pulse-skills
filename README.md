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

| Skill | What it does | Typical requests | Typical requests (pt-BR) |
| --- | --- | --- | --- |
| [`pulse-find-exact-same-product`](skills/pulse-find-exact-same-product/SKILL.md) | Finds product listings that appear to represent the same real-world product as a reference item. | "find the same product", "match this product", "find duplicate listings" | "encontrar o mesmo produto", "achar produto igual", "encontrar anúncios duplicados" |
| [`ml-product-analysis`](skills/ml-product-analysis/SKILL.md) | Analyzes one Mercado Livre product and its competitors, returning a product card and a ranked table of comparable products with price, estimated sales and revenue, logistics, and catalog / buy-box status. | "analyze this product", "how much does this sell", "find competing products" | "analisar este produto", "quanto vende esse produto", "encontrar produtos concorrentes" |
| [`product-change-monitor`](skills/product-change-monitor/SKILL.md) | Tracks how a Mercado Livre product changed over a period (by default week over week), returning a change table with the current price, rating, review count, estimated weekly sales and revenue, logistics, and seller details, each shown against about a week ago. | "monitor this product", "track price changes", "what changed this week", "did the price drop" | "monitorar este produto", "acompanhar este anúncio", "o preço caiu", "variação de avaliações" |
| [`international-product-matcher`](skills/international-product-matcher/SKILL.md) | Finds fast-growing international products in a category and matches each to a JoomPro product, with a per-item import action. | "find international products and match them to JoomPro", "imported products I can source" | "produtos internacionais para importar na JoomPro", "achar internacionais e casar com a JoomPro" |

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
