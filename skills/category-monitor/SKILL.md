---
name: category-monitor
description: >
  Weekly monitor of one Mercado Livre (Brasil) category's aggregate health, using
  JoomPulse — estimated sales, number of products, catalog products, active
  sellers, the seller-medal distribution, and the monopolization level — reporting
  what changed since the last run. It can also be pointed at a single listing or a
  catalog product, but defaults to the whole category. Use it when a seller wants
  ongoing week-over-week tracking of a category's totals. Triggers include:
  "monitor this category weekly", "what changed in this category this week", "track
  category sales and sellers", and the pt-BR equivalents "monitorar esta
  categoria", "acompanhar a categoria toda semana", "o que mudou na categoria essa
  semana", "variação de vendas e vendedores da categoria". Sales and revenue are
  JoomPulse estimates, not real transactions. To track one named product over
  time, use the product-change-monitor skill; for a one-shot opportunity snapshot
  with no diffs, use the opportunity-index skill.
---

# Category Monitor

This skill tracks **one Mercado Livre (Brasil) category's aggregate health, week
over week** — its estimated sales, number of products and catalog products, number
of active sellers, the distribution of sellers across medal tiers, and how
concentrated the market is (monopolization). Each run reports what changed since
the last one.

Each run is its own session, and the previous run's output is the baseline. The
default view is the whole category; the user may instead point it at a single
listing or a catalog product (a catalog product rolls up its competing listings).
To track one named product over time, use the product-change-monitor skill. For a
one-shot opportunity snapshot with no week-over-week diffs, use the
opportunity-index skill.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user names a category (or, optionally, a single listing or catalog product),
  set once at setup.
- The available JoomPulse tools can return a category's aggregate metrics and its
  seller-medal distribution.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can monitor a category.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **Sales and revenue are JoomPulse estimates** derived from historical listing
  data — not real transactions. Disclose this in every output.
- **Read-only.** The skill never writes or modifies anything.
- **Language:** detect the seller's language and respond in it. Default to pt-BR.
- **Run-to-run comparison.** Movement is measured between this run and the previous
  run's recorded table.

## Workflow

1. Resolve the category (default) — or the listing / catalog product if that is
   what was set up — and collect the aggregate metrics: estimated sales, number of
   products, number of catalog products, number of active sellers, the seller-medal
   distribution, and the monopolization level.
2. **First run** (no previous output): present the metrics as the starting
   baseline, state that monitoring has begun, and report no diffs.
3. **Subsequent runs:** read the previous run's recorded table and fill, per
   metric, the change as `antigo → novo`. A change requires both an old and a new
   value — no old value means show `—`, never a fabricated trend.
4. **Always end by restating the full current table** — it is the next run's
   baseline. On an empty or failed run, say so and keep the previous baseline.

## Output

Respond in the seller's language (default pt-BR). The change table always renders
as markdown:

| Métrica | Era | Agora |
|---|---|---|

for **Vendas (estimadas), Produtos, Produtos de catálogo, Vendedores,
Monopolização**. Put the dynamic (the change, with the figure or percentage point)
inside the **Agora** cell, prefixed with a semantic color dot:

- **Vendas ↑ = 🟢** (rising demand is favorable for a seller entering); Vendas ↓ = 🔴.
- **Monopolização is inverted** (like cancellation rate): **down = 🟢** (easier to
  enter), **up = 🔴** (harder to enter).
- **Produtos / Vendedores** moving is neutral context — show the change without a
  strong good/bad dot.
- On the **first run**, every Agora cell is the baseline value, with no dots and no
  diffs.

Close with a short **Principais insights** section.

**Disclaimer (every report):**

> ⚠️ Vendas e receita são estimativas do JoomPulse com base no histórico de
> anúncios — não são transações reais. / Sales and revenue are JoomPulse estimates
> based on historical listing data — not actual transactions.

## Visualization

When the client can render inline visuals, present metric cards and a medal-
distribution chart; otherwise fall back to the markdown change table plus text
cards. Never block on visuals. The change table always renders as markdown, on
every surface, and the ⚠️ disclaimer always stays in the text.

When inline visuals are available:

- **Four cards:** estimated sales, number of products, number of catalog products,
  and number of active sellers — plus the monopolization level shown as a value or
  small bar.
- **A medal-distribution bar:** sellers (or listings) split across medal tiers,
  using the medal palette — platina = purple, ouro = amber, prata = blue, sem
  medalha = white with a thin border (white needs the border to stay visible on a
  light background). Note the week-over-week shift.
- A category-sales trend line appears only once several runs have accumulated;
  otherwise show none.

Presentation rules: column headers are words (`Métrica | Era | Agora`), never a
bare "Δ" symbol. Show the color-dot legend (🟢/🔴) **only on runs where those dots
actually appear** in the table — never on the first or baseline run. Render a chart
only when the data supports it.

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **First run / no baseline:** snapshot only, every change cell `—`, no dots.
- **Empty or failed run:** say the data is temporarily unavailable, keep the
  previous baseline intact, do not overwrite it. Never paste internal error text,
  HTTP codes, or field names to the seller.
- **Catalog product input:** when monitoring a catalog product, note the buy-box
  competition (how many sellers compete) rather than implying a single listing.
