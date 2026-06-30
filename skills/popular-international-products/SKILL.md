---
name: popular-international-products
description: >
  Finds fast-growing international (imported) products inside ONE chosen Mercado
  Livre (Brasil) category, using JoomPulse, and returns them as a product table
  with price, estimated weekly sales and revenue, rating, reviews, time on air,
  shipping, listing type and seller medal, a JoomPulse link per item, and a
  pointer to JoomPro for sourcing. Use it when a seller wants the trending
  imported items in a specific category. Triggers include: "popular international
  products in this category", "fast-growing imported products", and the pt-BR
  equivalents "produtos internacionais em alta nessa categoria", "produtos
  importados que mais crescem", "achados internacionais para importar". Sales and
  revenue are JoomPulse estimates, not real transactions. For the same search
  across all categories at once, use the all-categories international skill.
---

# Popular International Products

This skill looks inside **one** Mercado Livre (Brasil) category and returns the
**fast-growing international (imported) products** in it — items flagged as
cross-border, ranked by recent momentum. For each it shows price, estimated
weekly sales and revenue, rating, reviews, time on air, shipping, listing type
and seller medal, with a JoomPulse link per item and a pointer to JoomPro for
sourcing.

It covers a single category and gives a general JoomPro search link. To scan all
categories at once, use the all-categories international skill.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user names a category (free text is fine).
- The available JoomPulse tools can return the active international listings in a
  category with their price, estimated sales and revenue, rating, reviews, time
  on air, logistics, listing type and seller medal.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can find international products.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **Sales and revenue are JoomPulse estimates** derived from historical listing
  data — not real transactions. By contrast, price, rating, and review count are
  real history. Disclose the estimate caveat in every output.
- **Read-only.** The skill never writes or modifies anything.
- **Language:** detect the seller's language and respond in it. Default to pt-BR.
- **Keep the workflow invisible.** Surface the answer, not the steps. Show `—` for
  any missing value; never fabricate one.

## Workflow

### Step 1 — Resolve the category

Ask for a category if none was given, then use JoomPulse to match the free text to
a category, disambiguating with the seller when several plausible matches return.

### Step 2 — Find fast-growing international products

Use JoomPulse to get the active **international (imported)** listings in the
category. There is no single "fast growth" flag, so use a clear momentum proxy
and **state the rule you used**: recently listed items (low time on air) with
strong estimated weekly sales or revenue. Do not label a list as fast-growing
when it is ranked by revenue alone. Keep the shortlist (about 10).

## Output

Respond in the seller's language (default pt-BR). The product list always renders
as a markdown table:

| MLB | Nome | Vendedor | Preço | Vendas (semana) | Receita (semana) | Classificação | Avaliações | Tempo no ar | Frete grátis | Mercado Envios Full | Tipo de anúncio | Medalha | JoomPro |
|---|---|---|--:|--:|--:|--:|--:|--:|:--:|:--:|---|---|---|

- The **MLB** identifier links to the item's JoomPulse page.
- **JoomPro** is a general JoomPro search link (`https://joom.pro/pt-br/search`)
  for sourcing the item.
- State the fast-growth rule you applied, in one short line.

**Disclaimer (every report):**

> ⚠️ Vendas e receita são estimativas do JoomPulse com base no histórico de
> anúncios — não são transações reais. Preço, classificação e avaliações são
> histórico real do Mercado Livre.

## Visualization

When the client can render inline visuals, present metric cards and a chart;
otherwise fall back to the markdown table plus text cards. Never block on visuals.
The product table always renders as markdown, on every surface, and the ⚠️
disclaimer always stays in the text.

When inline visuals are available:

- **Three cards:** number of international products found, total estimated weekly
  sales, and average ticket.
- **A horizontal bar** of the top ~10 international products by estimated weekly
  revenue. Render the chart only when there are enough products (skip it under
  about four), and never block on it.

Presentation rules: render a chart only when the data supports it; any change
column uses a word header, never a bare "Δ".

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **Few or no international items:** imported listings in some categories are
  high-ticket and low-rotation; if the shortlist is thin or has little estimated
  movement, say so honestly instead of padding it.
- **Market data temporarily unavailable:** retry once quietly; if it is still
  down, say market data is temporarily unavailable and to try again. Never paste
  internal error text, HTTP codes, or field names to the seller.
- **Never silently limit coverage** — if you show only part of what was found,
  say so.
