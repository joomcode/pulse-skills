---
name: high-demand-low-quality-finder
description: >
  Finds Mercado Livre (Brasil) products in one category that have high demand but
  a low rating — listings that sell well yet score at or below a rating threshold
  the user chooses, an opening to enter with a better offer. Use it when a seller
  wants weak-rated but well-selling products to beat. The skill asks for a category
  and a rating threshold, then returns the matching active listings ranked by
  demand, using JoomPulse market data. Triggers include: "high demand low rating
  products", "low quality opportunities", "products I can beat", and the pt-BR
  equivalents "produtos com muita demanda e nota baixa", "oportunidades de baixa
  qualidade", "produtos mal avaliados que vendem", "onde entrar com oferta melhor".
  Sales and revenue are JoomPulse estimates, not real transactions; price, rating,
  and review count are real history. For brand-new listings in a category, use the
  new-and-growing-products skill; for niches without strong incumbents, use the
  uncontested-niche skill; for sizing up a single product and its competitors, use
  the single-product analysis skill.
---

# High-Demand, Low-Quality Finder

This skill surfaces products in one Mercado Livre (Brasil) category that **sell
well but are poorly rated** — listings with strong demand whose rating sits at or
below a threshold the seller chooses. These are the products a seller has the best
chance of beating: the demand is already proven, and a better offer can win on
quality. The result is a ranked product table, ordered by estimated demand, with a
JoomPulse link per product.

This is different from finding fresh entrants or empty niches. To find brand-new
listings that are already selling in a category, use the new-and-growing-products
skill. To find niches with no strong incumbents, use the uncontested-niche skill.
To size up a single product and the products that compete with it, use the
single-product analysis skill. This skill answers "which proven sellers in this
category are weak on quality, so I can enter with a better offer?"

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user provides the **category** (a name or a category identifier) **and** a
  **rating threshold** (for example `4.0`). Both are required.
- The available JoomPulse tools can resolve a category and list the active
  listings in it with their demand, rating, price, and logistics.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can find opportunities.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **Sales and revenue are JoomPulse estimates** derived from historical listing
  data — not real transactions. Disclose this in every output. By contrast,
  **price, rating, and review count are real history** from Mercado Livre — say
  so, it is a strength of the report.
- **Read-only.** The skill does not sign in as the seller or modify any listing.
- **Language:** detect the seller's language and respond in it. Default to pt-BR.
- **Keep the workflow invisible.** The seller wants the answer, not a play-by-
  play. If one approach does not return data, switch to another quietly; only if
  every approach fails do you say one short, friendly sentence.

## Workflow

### Step 1 — Collect the inputs

1. Ask the user for both the **category** and the **rating threshold**. Both are
   required before you proceed.
2. Resolve the user's category text to a category identifier. If they gave a name,
   look it up in JoomPulse and confirm the match if it is ambiguous; if they gave
   an identifier, use it directly.
3. The rating threshold becomes the upper bound: keep only products whose rating
   is **at or below** the chosen value.

### Step 2 — Pull the category's listings

Use JoomPulse to obtain the active listings in the chosen category whose rating is
at or below the threshold. For each listing, gather the data needed for the table:
estimated weekly sales and revenue, estimated monthly demand, rating, review
count, price, time on air, free shipping, Mercado Envios Full, listing type, and
seller medal.

### Step 3 — Filter and rank

- Defensively drop any row whose rating is above the threshold, and ignore rows
  with no rating at all unless the user asks to include them.
- **Rank by demand**, highest first, so the high-demand, low-quality products
  surface at the top (use estimated weekly revenue as a tiebreaker).
- Keep roughly the top 20–30 rows for the table.

## Output

Respond in the seller's language. Present the result with no commentary about how
it was produced. The product table always renders as markdown so it displays
cleanly in any client.

**Product table** — one row per listing, with these columns (pt-BR labels by
default):

- product / listing identifier
- Nome (name)
- Categoria (category)
- Vendedor (seller)
- Preço (price)
- Vendas estimadas (semana) — estimated weekly sales
- Receita estimada (semana) — estimated weekly revenue
- Classificação (rating)
- Avaliações (review count)
- Tempo do anúncio no ar (time on air)
- Frete grátis (free shipping)
- Mercado Envios Full
- Tipo de anúncio (listing type)
- Medalha do vendedor (seller medal)
- A JoomPulse link for the product

Below the table, state the inputs used (the category and the rating threshold) and
that rows are ranked by estimated demand. When a cell has no value, show `—`;
never guess or fabricate.

**Disclaimer (every report):**

> ⚠️ Sales and revenue are JoomPulse **estimates** based on historical listing
> data — they are **not** actual transactions. Price, rating, and reviews are
> real Mercado Livre history. / Vendas e receita são **estimativas** do JoomPulse
> com base no histórico de anúncios — **não são transações reais**. Preço,
> classificação e número de avaliações são histórico real do Mercado Livre.

## Visualization

When the client can render inline visuals, present metric cards and a chart on top
of the markdown table — never instead of it. The product table always renders as
markdown. Otherwise, fall back to plain text: the cards as text lines and the
table as markdown, with no chart.

**Metric cards (three):**

- **Oportunidades encontradas** — the count of products kept (rows in the table).
- **Demanda total** — the estimated monthly demand summed across the kept rows.
- **Nota média** — the average rating across the kept rows. It will be low by
  construction; label it as the low-quality signal.

**Demand × rating chart:** one point per product — demand on the horizontal axis,
rating on the vertical axis, and bubble size by estimated weekly revenue.
Highlight the sweet spot (high demand, low rating — the bottom-right) by drawing
those points in **coral**, with all other points muted/grey: these are exactly the
products worth beating. **Skip the chart when there are fewer than five points** —
show the table only; no graph for the sake of a graph.

Presentation rules:

- Round numbers and format them in **pt-BR** (for example `R$ 1.234`,
  `1.234 vendas/mês`, rating `3,8`).
- Use the medal palette for any seller-medal styling: platina = purple,
  ouro = amber, prata = blue, sem medalha = white with a thin border.
- Keep the ⚠️ estimate disclaimer on every output that shows estimated sales or
  revenue.

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **No products at or below the threshold:** say the category has no products at
  or below that rating and suggest raising the threshold (for example to `4.5`).
  This is a valid result, not an error — keep it friendly.
- **Category not found or ambiguous:** ask the user to confirm the exact category
  or to provide its category identifier.
- **Market data temporarily unavailable:** retry once quietly; if it is still
  down, say market data is temporarily unavailable and offer to retry. Never paste
  internal error text, HTTP codes, or field names to the seller.
- **Empty cells:** show `—`; never guess or fabricate a value.
