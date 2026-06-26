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
| [`top-sellers-in-category`](skills/top-sellers-in-category/SKILL.md) | Ranks the top sellers in a category by estimated average monthly revenue as a downloadable leaderboard, and tracks how the ranking moves when you supply a previous-period leaderboard. | "top sellers in this category", "rank sellers by revenue", "who moved up or down" | "principais vendedores da categoria", "ranking de vendedores por receita", "quem subiu ou caiu na categoria" |
| [`seller-overview-tracker`](skills/seller-overview-tracker/SKILL.md) | Builds today's snapshot table for one Mercado Livre seller (revenue, sales, listings, reputation, medal, cancellation rate) as a downloadable table; to see what changed, the user sends the seller's table from a previous period for a metric-by-metric comparison. | "track this seller", "monitor this store", "what changed for this seller" | "monitorar este vendedor", "acompanhar esta loja", "o que mudou nesse vendedor" |
| [`international-product-matcher`](skills/international-product-matcher/SKILL.md) | Finds fast-growing international products in a category and matches each to a JoomPro product, with a per-item import action. | "find international products and match them to JoomPro", "imported products I can source" | "produtos internacionais para importar na JoomPro", "achar internacionais e casar com a JoomPro" |
| [`fast-growing-international-products`](skills/fast-growing-international-products/SKILL.md) | Finds fast-growing international (imported) products across all categories as one table, each tagged with its category. | "fast-growing international products", "imported products taking off", "cross-border winners across all categories" | "produtos internacionais em alta", "produtos importados crescendo rápido", "internacionais que mais crescem em todas as categorias" |
| [`new-growing-products-in-category`](skills/new-growing-products-in-category/SKILL.md) | Finds new, already-selling listings in a category (recently listed, well rated, with estimated sales traction) as a product table. | "new products in category", "what's launching and already selling", "recent best-sellers" | "produtos novos na categoria", "novos anúncios que já vendem", "lançamentos em alta" |
| [`popular-international-products`](skills/popular-international-products/SKILL.md) | Finds fast-growing international (imported) products in one category, with a JoomPulse link per item and a JoomPro sourcing pointer. | "popular international products in this category", "fast-growing imported products", "trending imported items" | "produtos internacionais em alta nessa categoria", "produtos importados que mais crescem", "achados internacionais para importar" |
| [`high-demand-low-quality-finder`](skills/high-demand-low-quality-finder/SKILL.md) | Finds products in a category with high demand but a low rating — openings to enter with a better offer. | "high demand low rating products", "products I can beat", "low quality opportunities" | "produtos com muita demanda e nota baixa", "produtos mal avaliados que vendem", "onde entrar com oferta melhor" |
| [`top-brand-position-tracker`](skills/top-brand-position-tracker/SKILL.md) | Ranks the brands in a category by estimated weekly revenue (GMV) and tracks how each brand's position changes between periods when the user supplies a previous brand table. | "top brands in this category", "which brands are growing", "brand ranking" | "principais marcas da categoria", "ranking de marcas", "quais marcas estão crescendo" |
| [`my-product-vs-catalog`](skills/my-product-vs-catalog/SKILL.md) | Compares the seller's own Mercado Livre listing against the available competing listings of the same catalog product (the buy-box competition), scoring price, free shipping, Mercado Envios Full, listing type, seller reputation and medal, and official store (reviews and rating shown as context), and returning a verdict, a comparison table, and a prioritized action list. | "why don't I win the buy-box", "compare me to the catalog", "my position in the catalog" | "por que não ganho o buy-box", "por que não vendo se tenho o mesmo produto", "comparar meu anúncio com o catálogo" |

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
