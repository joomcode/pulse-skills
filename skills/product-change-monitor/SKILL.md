---
name: product-change-monitor
description: >
  Monitors how one or a few Mercado Livre products or listings changed over a
  period — by default week over week. Use it when a user wants to track how a
  named product changes over time, given a Mercado Livre link, a JoomPulse link,
  a Mercado Livre listing identifier, or a catalog product identifier. It returns
  a change table: per product the current value and the difference versus about a
  week ago for price, rating, and review count, plus the current estimated weekly
  sales and revenue, logistics, listing type, seller medal, and time on air, with
  a JoomPulse link per product. Triggers include: "monitor this product", "track
  price changes", "what changed this week", "did the price drop", and the pt-BR
  equivalents "monitorar este produto", "acompanhar este anúncio", "o preço caiu",
  "variação de avaliações". Sales and revenue are JoomPulse estimates, not real
  transactions; price, rating, and reviews are real history. For point-in-time
  product and competitor analysis, use the single-product analysis skill.
---

# Mercado Livre Product Change Monitor

This skill shows how **one** Mercado Livre (Brasil) product — or a few of them —
**changed over a period**, by default the last week. Given a product by a Mercado
Livre link, a JoomPulse link, a Mercado Livre listing identifier, or a catalog
product identifier, it reports for each product the current value **and the
change versus about a week ago** for the metrics that have real history (price,
rating, review count), plus the current snapshot for estimated weekly sales and
revenue, logistics, listing type, seller medal, and how long the listing has been
on air. The result is a change table with a JoomPulse link per product, plus a
downloadable spreadsheet.

This is different from a single point-in-time analysis. To size up a product and
find the products that compete with it, use the single-product analysis skill. To
decide which new products to add across a whole catalog, use the gap-analysis
skill. This skill answers "how did this product move over time?" for a product
the user names.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user provides one product (or a small set) as a Mercado Livre link, a
  JoomPulse link, a Mercado Livre listing identifier, or a catalog product
  identifier.
- The available JoomPulse tools can look up a product's current market data and
  its daily price and reviews history.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can monitor a product's changes.

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

### Step 1 — Identify the product(s)

Resolve the input to one or more Mercado Livre listings:

1. From a Mercado Livre link, a JoomPulse link, or a pasted identifier, determine
   whether you have an individual **listing** or a **catalog product**.
2. For a catalog product, expand it to the competing listings for that product,
   pick the representative one (the strongest seller / buy-box winner) for the
   row, and note the buy-box competition (how many sellers compete).
3. Confirm the listing is active. If there is no market data for it, see Notes &
   Guardrails.
4. A JoomPulse store link is a whole store, not one product — ask for a specific
   product link or identifier (whole-store work belongs to the gap-analysis
   skill). Any other marketplace link cannot be resolved directly — ask for a
   Mercado Livre or JoomPulse link or identifier.

### Step 2 — Collect current state and history, then compare

1. **Current snapshot** (from JoomPulse): product name, category, seller, listing
   type, seller medal, logistics (Mercado Envios Full / free shipping), how long
   the listing has been on air, and the estimated **weekly** sales and revenue.
2. **Real daily history** (from JoomPulse): price, rating, and review count over
   roughly the last month, so a baseline a week back is reachable.
3. **Compare current versus about a week ago**, following this rule:
   - The **current point** is the latest observation available on or before today.
   - The **baseline** is the observation about seven days earlier.
   - If there is no observation exactly seven days back, use the **nearest earlier
     observation within tolerance** (roughly up to two weeks back in total) and
     **state which date was actually used** — never silently substitute it.
   - If no comparable earlier observation exists within tolerance, show the
     current value only and say the period comparison is not available for that
     metric. Do not invent a baseline.
4. Estimated sales and revenue are already **weekly** figures, so present them as
   the current week's value; they carry no period-over-period difference.

## Output

Respond in the seller's language. Present the result with no commentary about how
it was produced. Use plain markdown so it renders cleanly in any client.

**Change table** — one row per monitored product, with these columns:

- Product / listing identifier
- Name
- Category
- Seller
- Price (current value, with the change folded into the cell — for example the
  percentage change versus the baseline)
- Estimated sales (weekly)
- Estimated revenue (weekly)
- Rating (current value, with the **real numeric difference** versus the baseline
  in the cell — for example `+0.2`, `-0.3`, or `0` when unchanged)
- Reviews (current count, with the absolute growth versus the baseline in the
  cell — for example `+832`)
- Time on air
- Free shipping
- Mercado Envios Full
- Listing type
- Seller medal
- A JoomPulse link for the product

Do **not** put a delta symbol or "(Δ)" in any column header — it confuses sellers;
the change belongs inside the cell. Below the table, state the period actually
compared (for example "today versus seven days ago") and surface any baseline
date that was not exactly the target, so the comparison is transparent. You may
translate the column headers into the seller's language.

**Disclaimer (every report):**

> ⚠️ Sales and revenue are JoomPulse **estimates** based on historical listing
> data — they are **not** actual transactions. Price, rating, and reviews are
> real Mercado Livre history. / Vendas e receita são **estimativas** do JoomPulse
> com base no histórico de anúncios — **não são transações reais**. Preço,
> classificação e avaliações são histórico real do Mercado Livre.

**Download** — offer a downloadable spreadsheet (`.xlsx` plus `.csv`) of the
change table.

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **Product not tracked in JoomPulse / no sales:** JoomPulse tracks products that
  have sales, so a product may not be tracked. Say so and offer to try a different
  link or identifier; you cannot build a history for an untracked product.
- **New listing or too little history:** if there is less than about a week of
  data, show the current snapshot and explain that the period comparison is not
  available yet; suggest re-running in a few days to start a trend.
- **Catalog product:** the daily history is per listing, so resolve a catalog
  product to its listing(s) first; if several sellers compete, monitor the
  representative listing and mention the buy-box competition.
- **Unknown flags:** when a logistics flag (such as Mercado Envios Full) is
  unknown, show it as unknown — do not assume "no".
- **Market data temporarily unavailable:** retry once quietly; if it is still
  down, say market data is temporarily unavailable. Never paste internal error
  text, HTTP codes, or field names to the seller.
- **Never silently limit coverage** — if you monitor only some of several
  listings, say so.
