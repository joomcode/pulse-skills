---
name: category-monitor
description: >
  Monitor of one Mercado Livre (Brasil) category's aggregate health, using JoomPulse — estimated
  sales, number of products, catalog products, active sellers, the seller-medal distribution, and the
  monopolization level. Each run builds today's snapshot table for the category and offers it as a
  downloadable table; to see what changed, the user sends the table from a previous period and the
  skill shows the metric-by-metric difference (old → new). The baseline is whatever table the user
  supplies — there is no hidden session memory. It can also be pointed at a single listing or a
  catalog product, but defaults to the whole category. Use it when a seller wants to track a
  category's totals over time. Triggers include: "monitor this category", "what changed in this
  category", "track category sales and sellers", "compare this category with last period", and the
  pt-BR equivalents "monitorar esta categoria", "o que mudou na categoria", "comparar a categoria com
  o período anterior", "variação de vendas e vendedores da categoria". Sales and revenue are JoomPulse
  estimates, not real transactions. To track one named product over time, use the product-change-monitor
  skill; for a one-shot opportunity / market-size snapshot, use the category-opportunity-index skill.
---

# Category Monitor

This skill tracks **one Mercado Livre (Brasil) category's aggregate health over time** — its estimated
sales, number of products and catalog products, number of active sellers, the distribution of sellers
across medal tiers, and how concentrated the market is (monopolization).

Each run builds **today's snapshot table** for the category and offers it as a **downloadable table**.
To see what changed, the user **supplies the table from a previous period** (the one this skill
produced before); the skill compares the two and shows the difference per metric. **The baseline is
whatever table the user provides — there is no hidden session memory and nothing is stored
server-side.** The default view is the whole category; the user may instead point it at a single
listing or a catalog product (a catalog product rolls up its competing listings).

To track one named product over time, use the product-change-monitor skill. For a one-shot
opportunity / market-size snapshot, use the category-opportunity-index skill.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user names a category (or, optionally, a single listing or catalog product).
- For a period comparison, the user supplies a previous table that this skill produced for the same
  category (pasted or uploaded). Without it, the skill produces a standalone snapshot.
- The available JoomPulse tools can return a category's aggregate metrics and its seller-medal
  distribution.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires JoomPulse MCP setup
before it can monitor a category.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **Sales and revenue are JoomPulse estimates** derived from historical listing data — not real
  transactions. Disclose this in every output.
- **Read-only.** The skill never writes or modifies anything; it does not store the snapshot — the
  user keeps the downloadable table and brings it back next period.
- **Language:** detect the seller's language and respond in it. Default to pt-BR.
- **The baseline is user-supplied.** Never claim a change without a previous table to compare against,
  and never infer or fabricate one from memory.

## Workflow

### Step 1 — Resolve what to monitor

Ask for a category if none was given, then use JoomPulse to match the free text to a category
(disambiguate with the user when several plausible matches return). Optionally, the user can point the
skill at a single listing or a catalog product instead.

### Step 2 — Collect today's aggregates

Use JoomPulse to collect, for the target: estimated sales, number of products, number of catalog
products, number of active sellers, the seller-medal distribution, and the monopolization level.

### Step 3 — Present today's snapshot and offer it for download

Render the snapshot table for **today** (head it with the category name and the date). This table is
the deliverable — and **offer it as a downloadable file (`.csv` / `.xlsx`)** so the user can save it
and bring it back next period as the baseline. On a standalone snapshot there is **no change column
and no color-dot legend** — just metric and current value.

### Step 4 — Offer comparison, and compare if a previous table is supplied

Invite the user to send a previous table for the same category to compare periods. **If they provide
one**, parse its metric values, align by metric to today's snapshot, and render a comparison table
with the difference per metric. A difference **requires both an old and a new value** for the same
metric — if a metric is missing or unreadable in the supplied table, show `—`, never a fabricated
trend. If no previous table is supplied, the snapshot stands on its own and the user is told to save
it for next time.

## Output

Respond in the seller's language (default pt-BR).

**Snapshot (always):** a markdown table `| Métrica | Valor atual |` for **Vendas (estimadas),
Produtos, Produtos de catálogo, Vendedores, Distribuição de medalhas, Monopolização**, plus a
downloadable `.csv` / `.xlsx` of the same data.

**Comparison (only when a previous table is supplied):** a markdown table `| Métrica | Anterior |
Atual |`. Put the change (figure or percentage point) inside the **Atual** cell, prefixed with a
semantic color dot:

- **Vendas ↑ = 🟢**; Vendas ↓ = 🔴.
- **Monopolização is inverted** (like cancellation rate): **down = 🟢** (easier to enter), **up = 🔴**.
- **Produtos / Vendedores** moving is neutral context — show the change without a strong good/bad dot.
- **Distribuição de medalhas** — show the tiers that moved (for example `platina 4 → 5`).

Column headers are words (`Métrica | Anterior | Atual`), never a bare "Δ" symbol. Show the color-dot
legend (🟢/🔴) **only** in the comparison table, where the dots actually appear — never on a plain
snapshot.

Close with a short **Principais insights** section: with a comparison, interpret what moved; on a
standalone snapshot, frame it as the starting picture with no trend claims.

**Disclaimer (every report):**

> ⚠️ Vendas, vendedores, produtos e monopolização são estimativas do JoomPulse com base no histórico
> de anúncios — não são transações reais. / Sales, sellers, products, and monopolization are JoomPulse
> estimates based on historical listing data — not actual transactions.

## Visualization

When the client can render inline visuals, present metric cards and a medal-distribution chart;
otherwise fall back to the markdown tables plus text cards. Never block on visuals. The snapshot table
(and the comparison table, when present) always render as markdown in the response text, and the
downloadable file mirrors what is shown.

When inline visuals are available:

- **Cards:** estimated sales, number of products, number of catalog products, and number of active
  sellers — plus the monopolization level as a value or small bar. With a comparison, you may annotate
  each card with its `anterior → atual` change.
- **A medal-distribution bar:** sellers (or listings) split across medal tiers, using the medal
  palette — platina = purple, ouro = amber, prata = blue, sem medalha = white with a thin border
  (white needs the border to stay visible on a light background). With a previous table, note the shift.
- **No synthesized trend line** from a single run (there is no server-side history). Only if the user
  supplies several past-period tables may you plot a simple line across those periods.

Presentation rules: column headers are words, never a bare "Δ" symbol; show the color-dot legend only
when those dots appear (the comparison table); render a chart only when the data supports it.

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **No previous table supplied:** render today's snapshot only (no change column, no legend) and
  invite the user to save it for next time.
- **Supplied table is for a different category, malformed, or unreadable:** say so plainly and fall
  back to the snapshot only; do not force a misaligned comparison.
- **Empty or failed data:** say the data is temporarily unavailable and to try again. Never paste
  internal error text, HTTP codes, or field names to the seller.
- **Catalog product input:** when monitoring a catalog product, note the buy-box competition (how many
  sellers compete) rather than implying a single listing.
