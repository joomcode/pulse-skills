---
name: unbranded-products-in-category
description: >
  Finds products with no brand (unbranded / no-name / generic) in one Mercado
  Livre (Brasil) category, using JoomPulse — an opening to enter the category with
  your own brand / private label, since buyers there are not anchored to a brand
  name. Asks the user for a category, lists the active listings that have no brand,
  ranked by estimated weekly demand, and returns a product table with price,
  estimated weekly sales and revenue, rating, reviews, time on air, shipping,
  listing type and seller medal, plus a JoomPulse link per item. Use it when a
  seller wants white-label / private-label openings. Triggers include: "unbranded
  products", "no-name products in category", "products without a brand",
  "private-label opportunities", and the pt-BR equivalents "produtos sem marca",
  "genéricos que vendem", "oportunidade de marca própria". Sales and revenue are
  JoomPulse estimates, not real transactions. NOT for ranking the brands in a
  category (use the top-brand-position-tracker skill), brand-new listings (use the
  new-growing-products-in-category skill), high-demand low-rated products (use the
  high-demand-low-quality-finder skill), or niches without platinum sellers (use
  the uncontested-niche-finder skill).
---

# Unbranded Products In Category

This skill surfaces the **products that have no brand** (unbranded / no-name /
generic) in one Mercado Livre (Brasil) category — the listings where the brand is
empty. These are spots where a seller can enter with their **own brand / private
label**, because buyers there aren't anchored to a brand name. For each it shows
price, estimated weekly sales and revenue, rating, reviews, time on air, shipping,
listing type and seller medal, with a JoomPulse link per item.

It is the opposite of ranking a category's brands (for that, use the
top-brand-position-tracker skill). For fresh listings use the
new-growing-products-in-category skill; for low-rated, well-selling products use
the high-demand-low-quality-finder skill; for deep niches without platinum sellers
use the uncontested-niche-finder skill.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user names a category (free text is fine).
- The available JoomPulse tools can return the active listings in a category, tell
  which of them have no brand, and provide each listing's price, estimated weekly
  sales and revenue, rating, reviews, time on air, logistics, listing type and
  seller medal.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can find unbranded products.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **Sales and revenue are JoomPulse estimates** derived from historical listing
  data — not real transactions. By contrast, price, rating, and review count are
  real history. Disclose the estimate caveat in every output.
- **Read-only.** The skill never writes or modifies anything, and does not render
  product images.
- **Language:** detect the seller's language and respond in it. Default to pt-BR.
- **Keep the workflow invisible.** Show `—` for any missing value; never fabricate.

## Workflow

### Step 1 — Resolve the category

Ask for a category if none was given, then use JoomPulse to match the free text to
a category. If several plausible matches come back, list the top candidates (name
and depth level) and let the user choose — do not guess between unrelated categories.

### Step 2 — Find the unbranded products

Use JoomPulse to get the category's **active** listings that have **no brand**
(brand empty / unbranded). Rank them by estimated weekly demand (estimated weekly
revenue, or weekly sales), highest first, and keep the strongest ~20–30.

## Output

Respond in the seller's language (default pt-BR). The product list always renders
as a markdown table:

| MLB | Nome | Vendedor | Preço | Vendas (semana) | Receita (semana) | Classificação | Avaliações | Tempo no ar | Frete grátis | Mercado Envios Full | Tipo de anúncio | Medalha do vendor |
|---|---|---|--:|--:|--:|--:|--:|--:|:--:|:--:|---|---|

- The **MLB** identifier links to the item's JoomPulse page.
- Lead with a one-line summary (category + how many unbranded products were found),
  sort by estimated weekly demand, and end with the disclaimer.

**Disclaimer (every report):**

> ⚠️ Vendas e receita são estimativas do JoomPulse com base no histórico de
> anúncios — não são transações reais. Preço, classificação e avaliações são
> histórico real do Mercado Livre. / Sales and revenue are JoomPulse estimates
> based on historical listing data — not actual transactions. Price, rating, and
> reviews are real Mercado Livre history.

## Visualization

When the client can render inline visuals, present metric cards and a chart;
otherwise fall back to the markdown table plus text cards. Never block on visuals.
The product table always renders as markdown in the response text, on every
surface, and the ⚠️ disclaimer always stays in the text. No product images.

When inline visuals are available:

- **Three cards:** number of unbranded products found, total estimated weekly
  sales, and average ticket.
- **A horizontal bar** of the top ~10 unbranded products by estimated weekly
  revenue. Render the chart only when there are enough products (skip it under
  about four), and never block on it.

Presentation rules: render a chart only when the data supports it; any column with
movement uses a word header, never a bare "Δ".

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **No unbranded products in the category:** the category may be brand-dominated —
  say so plainly and suggest a broader or adjacent category. Never fabricate rows.
- **Ambiguous category name:** list the candidates and ask the user to choose.
- **Market data temporarily unavailable:** retry once quietly; if it is still
  down, say market data is temporarily unavailable and to try again. Never paste
  internal error text, HTTP codes, or field names to the seller.
- **Never silently limit coverage** — if the category is larger than what you
  pulled, say the table covers the strongest unbranded products, not all of them.
