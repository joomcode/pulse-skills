---
name: fast-growing-international-products
description: >
  Finds fast-growing international (imported) products ACROSS ALL Mercado Livre
  (Brasil) categories, using JoomPulse, and returns them as one product table
  that includes each item's category, with price, estimated weekly sales and
  revenue, rating, time on air, shipping, listing type, seller medal, and a
  JoomPulse link per item. Use it when a seller wants rising imported products
  marketwide, not inside a single niche. Triggers include: "fast-growing
  international products", "imported products that are taking off", "cross-border
  winners across all categories", and the pt-BR equivalents "produtos
  internacionais em alta", "produtos importados crescendo rápido", "produtos
  internacionais que mais crescem em todas as categorias". Sales and revenue are
  JoomPulse estimates, not real transactions. For the same search limited to one
  category, use the single-category international skill; to match items to a
  specific JoomPro product for import, use the international-product-matcher skill.
---

# Fast-Growing International Products

This skill returns the **fast-growing international (imported) products across all
Mercado Livre (Brasil) categories** — a marketwide shortlist of cross-border
items with recent momentum, each shown with the category it sits in. It is the
all-categories sibling of the single-category international skill.

For imported products inside one specific category, use the single-category
international skill. To match each item to a specific JoomPro product with a
per-item import action, use the international-product-matcher skill.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The available JoomPulse tools can return active international listings across
  categories with their category, price, estimated sales and revenue, rating,
  time on air, logistics, listing type and seller medal.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can find international products.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **Sales and revenue are JoomPulse estimates** derived from historical listing
  data — not real transactions. Price, rating, and reviews are real history.
  Disclose the estimate caveat in every output.
- **Read-only.** The skill never writes or modifies anything.
- **Language:** detect the seller's language and respond in it. Default to pt-BR.
- **Keep the workflow invisible.** Show `—` for any missing value; never fabricate.

## Workflow

### Step 1 — Optional narrowing

This skill is marketwide by default. The seller may optionally narrow it to a
broad area; if they do and the term is ambiguous, disambiguate before continuing.

### Step 2 — Find fast-growing international products marketwide

Use JoomPulse to get active **international (imported)** listings across
categories. There is no single "fast growth" flag, so it must be defined from a
real momentum proxy — **revenue alone is not growth**, and ranking by it surfaces
old, high-ticket slow movers rather than rising items.

**Default fast-growth rule (always apply and disclose):** an item is "fast-growing"
only when it is **recently listed (low time on air)** *and* has **strong estimated
weekly sales (and/or estimated weekly revenue)** — that is, it gained real traction
in a short time. Rank the shortlist by that momentum (estimated weekly sales/revenue
relative to how recently it was listed), not by revenue on its own. **State this
rule in the output.**

Keep a clearly stated **top-N** (for example top 30) and say it is a top-N.

**Fallback (not "growth"):** if recency data is unavailable, you may instead show
the **top international items by estimated weekly revenue** — but label it plainly
as a *top-by-revenue fallback*, never call it "fast-growing" or "growth", and say
the momentum rule could not be applied.

## Output

Respond in the seller's language (default pt-BR). The product list always renders
as a markdown table, and **includes a Category column** (the cross-category
differentiator):

| MLB | Nome | Vendedor | Categoria | Preço | Vendas (semana) | Receita (semana) | Classificação | Avaliações | Tempo no ar | Frete grátis | Mercado Envios Full | Tipo de anúncio | Medalha |
|---|---|---|---|--:|--:|--:|--:|--:|--:|:--:|:--:|---|---|

- The **MLB** identifier links to the item's JoomPulse page.
- State the fast-growth rule — recently listed **and** strong estimated weekly
  sales/revenue, ranked by that momentum — and the top-N cap you applied, in one
  short line. If you used the top-by-revenue fallback instead, say so and do not
  call it growth.

**Disclaimer (every report):**

> ⚠️ Sales and revenue are JoomPulse **estimates** based on historical listing
> data — they are **not** actual transactions. Price, rating, and reviews are
> real Mercado Livre history. / Vendas e receita são **estimativas** do JoomPulse
> com base no histórico de anúncios — **não são transações reais**. Preço,
> classificação e avaliações são histórico real do Mercado Livre.

## Visualization

When the client can render inline visuals, present metric cards and a chart;
otherwise fall back to the markdown table plus text cards. Never block on visuals.
The product table always renders as markdown, on every surface, and the ⚠️
disclaimer always stays in the text.

When inline visuals are available:

- **Three cards:** number of products in the shortlist (top-N), number of distinct
  categories represented, and average ticket.
- **A horizontal bar** of the top products by estimated weekly revenue, plus an
  optional small companion bar of which categories contribute the most
  fast-growing international products. Render charts only when there are enough
  items (skip under about four).

Presentation rules: render a chart only when the data supports it; any change
column uses a word header, never a bare "Δ".

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **High-ticket, low-rotation skew:** marketwide imported items can skew toward
  expensive, slow-moving SKUs; surface that honestly rather than implying broad
  momentum that is not there.
- **Market data temporarily unavailable:** retry once quietly; if it is still
  down, say market data is temporarily unavailable and to try again. Never paste
  internal error text, HTTP codes, or field names to the seller.
- **Never silently limit coverage** — always state the top-N cap.
