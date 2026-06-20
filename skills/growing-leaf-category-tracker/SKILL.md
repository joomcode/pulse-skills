---
name: growing-leaf-category-tracker
description: >
  Finds the fastest-growing deep sub-categories (leaf categories, deeper than the
  third level) under a chosen Mercado Livre (Brasil) category, ranked by
  month-over-month revenue growth, using JoomPulse market data. Use it when a
  seller picks a category and wants the niches inside it that are growing fastest
  right now. Triggers include: "fast-growing subcategories", "which niches are
  growing in this category", "deep growing categories", and the pt-BR equivalents
  "subcategorias em crescimento", "nichos que mais crescem nesta categoria",
  "categorias profundas em alta". Sales and revenue are JoomPulse estimates, not
  real transactions. For one category's opportunity index, use the
  opportunity-index skill; for week-over-week category aggregates, use the
  category-monitor skill; for new products inside a category, use the new-products
  skill.
---

# Growing Leaf Category Tracker

This skill takes one Mercado Livre (Brasil) category and surfaces the **deep
sub-categories inside it that are growing fastest** — the leaf niches (below the
third level of the category tree) with the strongest month-over-month growth in
estimated revenue. It helps a seller who already knows a broad area decide which
specific niche to move into next.

This is a niche-discovery snapshot, not a tracker over time. For a single
category's opportunity index and market size, use the opportunity-index skill.
To watch a category's aggregate numbers change week over week, use the
category-monitor skill. To find specific new products inside a category, use the
new-products skill.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user names a parent category (free text is fine).
- The available JoomPulse tools can resolve a category, walk its sub-categories,
  and return each one's current monthly market stats (estimated revenue and
  sales, number of active sellers, number of products) and its growth direction.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can find growing niches.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **Sales and revenue are JoomPulse estimates** derived from historical listing
  data — not real transactions. Disclose this in every output.
- **Read-only.** The skill never writes or modifies anything.
- **Language:** detect the seller's language and respond in it. Default to pt-BR.
- **Keep the workflow invisible.** Surface the answer, not the steps. Never fill
  gaps from general knowledge; show `—` for any missing value.

## Workflow

### Step 1 — Resolve the parent category

Ask the seller for a category if none was given, then use JoomPulse to match the
free text to a category. If several plausible matches come back, list the top
candidates (name and depth level) and let the seller choose.

### Step 2 — Collect the deep sub-categories

Use JoomPulse to list the descendant categories below the chosen one, keeping the
**deep ones — leaf niches deeper than the third level**. For each, get the
current monthly estimated revenue and sales, the number of active sellers, the
number of products, and the month-over-month revenue growth.

### Step 3 — Rank by growth

Rank the deep sub-categories by **month-over-month revenue growth**, highest
first. Use the always-positive monthly totals for size (revenue, sales,
products); use growth only for ranking — never present a change figure as a total.

## Output

Respond in the seller's language (default pt-BR), with no commentary about how the
result was produced. The ranking always renders as a markdown table:

| Categoria | Vendedores | Receita (mês est.) | Vendas (mês est.) | Produtos | Crescimento |
|---|--:|--:|--:|--:|--:|

- **Crescimento** is the month-over-month revenue growth; mark it 🟢 when high.
- Each category links to its JoomPulse category dashboard page.

**Disclaimer (every report):**

> ⚠️ Receita e vendas são estimativas do JoomPulse com base no histórico de
> anúncios — não são transações reais. / Revenue and sales are JoomPulse
> estimates based on historical listing data — not actual transactions.

## Visualization

When the client can render inline visuals, present metric cards and a chart;
otherwise fall back to the markdown table plus text cards. Never block on visuals.
The ranking table always renders as markdown in the response text, on every
surface, and the ⚠️ disclaimer always stays in the text.

When inline visuals are available:

- **Three cards:** number of growing niches found, the single fastest-growing
  niche (name + growth %), and the average growth across the shortlist.
- **A size-versus-growth bubble chart:** each niche placed by market size
  (estimated monthly revenue) against its growth %, with bubble size showing the
  number of sellers — the upper-right area is the large-and-fast-growing sweet
  spot. Render this chart only when the data supports it (a few niches); fall back
  to a simple bar of the top niches by growth, and skip the chart entirely when
  there are too few niches.

Presentation rules: any change or difference column uses a word as its header
("Variação" / "Crescimento"), never a bare "Δ" symbol; render a chart only when
the underlying data supports it.

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **Flat parent category:** if the chosen category has no sub-categories deeper
  than the third level, say so plainly and offer to look at a broader parent
  category instead of returning an empty table.
- **Negative or odd growth:** some niches may be shrinking; surface that honestly
  rather than hiding it, and never invent a positive trend.
- **Market data temporarily unavailable:** retry once quietly; if it is still
  down, say market data is temporarily unavailable and to try again. Never paste
  internal error text, HTTP codes, or field names to the seller.
- **Never silently limit coverage** — if you rank only some of the niches, say so.
