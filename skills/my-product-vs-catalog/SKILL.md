---
name: my-product-vs-catalog
description: >
  Compares the seller's own Mercado Livre listing against every other seller of
  the same catalog product — the buy-box competition — and says where they win,
  lose, and what to fix first. Use it when a seller asks why they don't win the
  buy-box, why they don't sell despite the same product, or how they rank inside a
  catalog, given a Mercado Livre or JoomPulse link or a listing or catalog product
  identifier. It scores each parameter — price, free shipping, Full, listing type,
  reviews, rating, seller reputation, official store — as Melhor, Na média, Pior, or
  Criticamente pior, and returns a verdict, a comparison table, prioritized actions,
  and a spreadsheet, with an optional weekly monitor. Triggers include "why don't I
  win the buy-box" and the pt-BR "por que não ganho o buy-box". Mercado Livre
  (Brasil) only; sales and revenue are JoomPulse estimates, not real transactions.
  For a product and its competitors, use the single-product analysis skill; for one
  over time, the change-monitor skill.
---

# Mercado Livre — My Product vs. Catalog (Buy-Box Competitiveness)

This skill compares the seller's **own** Mercado Livre (Brasil) listing against
**every other seller offering the same catalog product** — the sellers competing
for the same buy-box — and tells the seller, in pt-BR, where they win, where they
lose, and **what to fix first** to win the buy-box and convert more.

Given a product by a Mercado Livre link, a JoomPulse link, a Mercado Livre listing
identifier, or a catalog product identifier, it identifies the seller's listing and
the catalog it belongs to, gathers the full set of competing listings, and produces
a short verdict, a comparison table, a prioritized list of improvements, and a
downloadable spreadsheet.

This is different from the sibling skills. To size up a single product and find the
products that compete with it, use the single-product analysis skill. To track how
one product moves over time, use the change-monitor skill. **This** skill answers
"how do I stack up against the other sellers of the exact same product, and what
should I change to win?"

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The seller provides their product as a Mercado Livre link, a JoomPulse link, a
  Mercado Livre listing identifier, or a catalog product identifier.
- The available JoomPulse tools can look up a listing's current market data, the
  set of competing listings for the same catalog product, and the buy-box winner's
  attributes.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can compare a listing against its catalog.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **It compares within one catalog product.** The comparison is the seller versus
  the other sellers of the same catalog product (the same buy-box), not a search
  for similar products.
- **Sales and revenue are JoomPulse estimates** derived from historical listing
  data — not real transactions. Disclose this in every output. Price, rating,
  review count, logistics, and seller attributes are real Mercado Livre data — say
  so, it is a strength of the report.
- **Read-only.** The skill does not sign in as the seller or modify any listing.
- **Language:** detect the seller's language and respond in it. Default to pt-BR.
- **Keep the workflow invisible.** The seller wants the answer, not a play-by-play.
  If one lookup returns nothing, switch approaches quietly; only if everything fails
  do you say one short, friendly sentence.

## How It Works

1. **Identify the product.** Resolve the link or identifier to the seller's listing
   and the catalog product it belongs to. If the input is a catalog product (rather
   than a single listing), ask the seller which listing is theirs, since the whole
   point is to compare *their* listing against the rest. The catalog product is the
   key that groups competing sellers.
2. **Gather the catalog.** Collect every active competing listing for that catalog
   product, plus the buy-box winner's attributes and the catalog's overall totals,
   so there is a clear "catalog leader" to benchmark against.
3. **Compare and classify.** For each parameter, compare the seller's value to the
   catalog median, the best/cheapest competitor, and the buy-box winner, and label
   it (see Status levels below).
4. **Prioritize.** Sort the gaps by how much they cost: buy-box and conversion
   levers first, quick wins ahead of slow ones — which naturally yields the order
   price → logistics → photos → reviews/reputation.

## Parameters Compared

- **Price** — versus the catalog median, the cheapest competitor, and the buy-box
  price.
- **Free shipping (frete grátis)** — whether the seller offers it and how common it
  is among competitors and the buy-box winner.
- **Mercado Envios Full** — same, since Full strongly influences exposure and the
  buy-box.
- **Listing type** — Premium / Clássico / Grátis tier, versus the catalog.
- **Reviews and rating** — note that on catalog products these are shared across all
  sellers of the same product, so they usually do not differentiate competitors; the
  skill says so instead of treating a shared number as an advantage.
- **Photos** — best-effort count versus the strongest listings.
- **Seller reputation and medal** — versus the buy-box winner and the catalog.
- **Official store** — whether the seller or the buy-box winner is an official store
  (shown when relevant).

## Status Levels

Each parameter gets one status, with a colour marker so it reads at a glance:

- 🟢 **Melhor** — better than most of the catalog; keep it.
- 🟡 **Na média** — on par with the catalog, i.e. level with most sellers (not merely
  an arithmetic average).
- 🟠 **Pior** — clearly behind the catalog.
- 🔴 **Criticamente pior** — behind on a buy-box or conversion lever (price, free
  shipping, Full) where the gap is large — this is what most directly costs the sale.
- **—** — not compared (no data available, or a catalog-shared metric like reviews).

## Output

Respond in pt-BR, leading with the verdict:

1. **Veredito** — two to four sentences: where the seller wins, where they lose,
   their buy-box position, and the single top priority.
2. **Comparison table** — one row per parameter: `Parâmetro`, `Meu produto`,
   `Catálogo / Concorrentes`, `Status`, `O que fazer`.
3. **Improvement priorities** — a numbered list, ordered by impact: what matters most
   for competitiveness first, then quick wins, then the long-term levers.
4. **Competitors (optional)** — a short table of competing listings, cheapest first,
   flagging the buy-box winner.
5. **Disclaimer** — sales and revenue are JoomPulse estimates, not real transactions;
   price, rating, reviews, logistics, and seller data are real Mercado Livre data.
6. **Downloads** — offer the comparison as a downloadable spreadsheet.

## Weekly Monitoring

If the seller wants ongoing tracking, offer to set up a weekly monitor through the
scheduling skill. Each week it repeats the comparison for the same catalog product
and reports, in pt-BR: what changed, where the seller improved or worsened, which
catalog member overtook them (took the buy-box or newly undercut their price), and
the current top actions. On the first run there is no baseline yet — deliver the
normal analysis and note that the trend starts the following week.

## Edge Cases

- **The input is a catalog product, not a single listing:** ask which listing is the
  seller's before comparing.
- **The product is not part of a catalog:** there is no shared buy-box to compete in;
  say so and offer the single-product analysis skill instead.
- **The seller is the only seller:** there is nothing to compare — report the buy-box
  status and say they are currently alone on this product.
- **A very large catalog:** when there are more competitors than can be fetched at
  once, the medians and shares are based on a sample — say so — while the buy-box
  leader's attributes remain exact.
- **A listing is not tracked by JoomPulse:** the index covers products with sales;
  say it isn't tracked and offer to try another listing or link.
- **A parameter has no data:** show it as "dado indisponível" rather than dropping it,
  so the seller can see every parameter was checked.
