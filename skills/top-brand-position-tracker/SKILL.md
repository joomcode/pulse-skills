---
name: top-brand-position-tracker
description: >
  Ranks the brands within one Mercado Livre (Brasil) category by estimated weekly
  revenue and tracks how each brand's position in that ranking changes between
  periods, using JoomPulse data. Each run builds today's brand-ranking table for
  the category and offers it as a downloadable table; to see how positions moved,
  the user sends a brand table from a previous period and the skill shows each
  brand's position movement (rose, fell, new, or out). The baseline is whatever
  table the user supplies — there is no hidden session memory. Use it when a seller
  wants to know who the top brands in a category are, which brands are rising or
  falling, or to monitor brand share over time. Triggers include: "top brands in
  this category", "which brands are growing", "brand ranking", "track brand
  positions", and the pt-BR equivalents "principais marcas da categoria", "ranking
  de marcas", "quais marcas estão crescendo", "acompanhar posição das marcas".
  Mercado Livre (Brasil) only; sales and revenue are JoomPulse estimates, not real
  transactions. For ranking sellers (shops) rather than brands, use the
  seller-ranking skills; for category-level market size and opportunity, use the
  category opportunity skill.
---

# Top brand position tracker

This skill ranks the **brands** inside one Mercado Livre (Brasil) category by
estimated weekly revenue and **tracks how each brand's position in that ranking
moves over time**. It aggregates each brand's active listings into a leaderboard.

Each run builds **today's brand-ranking table** for the category and offers it as
a **downloadable table**. To see how positions moved, the user **supplies a brand
table from a previous period** (the one this skill produced before); the skill
matches brands by name and shows each brand's position movement. **The baseline is
whatever table the user provides — there is no hidden session memory and nothing
is stored server-side.** A standalone run is the ranking only: no movement column
and no legend.

This is different from ranking sellers or sizing a category. To rank **sellers
(shops)** in a category, or to track how a seller leaderboard moves over time, use
the seller-ranking skills. To report a category's market size and opportunity
(estimated GMV, sales, number of sellers, average ticket), use the category
opportunity skill. This skill answers **"which brands lead this category, and how
did their positions move since a previous table?"**

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user provides the category to analyze — a category name, a category
  identifier, or a JoomPulse category link.
- For a period comparison, the user supplies a previous brand table that this skill
  produced for the same category (pasted or uploaded). Without it, the skill
  produces a standalone ranking.
- The available JoomPulse tools can look up the active listings in a category
  along with their estimated weekly sales and revenue, review counts, and prices.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can rank brands and track their positions.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **Sales and revenue are JoomPulse estimates** derived from historical listing
  data — not real transactions. Disclose this in every output. By contrast,
  **review count is real Mercado Livre history** — say so, it is a strength of the
  report.
- **Read-only.** The skill never signs in as the seller and never modifies
  anything; it does not store the ranking — the user keeps the downloadable table
  and brings it back next period.
- **The baseline is user-supplied.** Never claim a position change without a
  previous table to compare against, and never infer or fabricate one from memory.
- **Language:** respond in pt-BR by default. If the seller clearly writes in
  another language, mirror it; otherwise pt-BR.
- **Keep the workflow invisible.** The seller wants the ranking, not a play-by-
  play. If one approach does not return data, switch to another quietly; only if
  every approach fails do you say one short, friendly sentence.

## Workflow

### Step 1 — Resolve the category, gather listings, aggregate brands

1. **Ask the seller for the category** if it was not given — a category name, a
   category identifier, or a JoomPulse category link. If only a name is given,
   resolve it to the matching current category (and its depth level) with
   JoomPulse, and confirm the match with the seller if it is ambiguous.
2. **Use JoomPulse to fetch every active listing in the category**, with each
   listing's brand, estimated weekly sales and revenue, review count, and price.
   For a large category, broaden coverage in passes rather than silently capping —
   and if coverage is partial, say it was broad rather than presenting it as
   complete.
3. **Group the listings by brand and aggregate per brand.** Before grouping,
   **normalize brand names** — trim and unify casing, fold obvious variants and
   spellings of the same brand together, and standardize generic placeholders (for
   example "Outro" / "Sem marca") — so one brand is not split across rows. Use this
   same canonical form again when matching brands across periods. Drop listings
   with no brand; if unbranded listings are material, mention how many had no brand
   rather than letting an unnamed bucket top the ranking. For each brand compute:
   - **GMV estimado (semana)** — total estimated weekly revenue across the brand's
     listings.
   - **Vendas est. (semana)** — total estimated weekly sales across the listings.
   - **Anúncios** — number of active listings for the brand.
   - **Avaliações** — total review count (real history).
   - **Preço médio** — average listing price (optional supporting column).
4. **Rank the brands by estimated weekly revenue, descending,** to assign each
   brand its position (1 = top). If the seller asks to rank by units sold instead,
   rank by estimated weekly sales and say so. Keep roughly the top 20–30 brands
   for the table.

### Step 2 — Present today's ranking and offer it for download

Render today's brand-ranking table (head it with the category name and the date).
This table is the deliverable — and **offer it as a downloadable file (`.csv` /
`.xlsx`)** so the user can save it and bring it back next period as the baseline.
On a standalone ranking there is **no movement column and no legend** — just the
ranking.

### Step 3 — Offer comparison, and compare if a previous table is supplied

Invite the user to send a previous brand table for the same category to compare
positions. **If they provide one**, match brands by canonical name (see Step 1)
and for each brand compare its previous position with its current one:

- rose N places → rose by N
- fell N places → fell by N
- same position → unchanged
- not in the previous table → new
- in the previous table but absent now → list it below the table as *"saiu do
  ranking"* — do not fabricate a position for it.

A position change **requires both a previous and a current position** for the same
brand — never invent a trend. If no previous table is supplied, the ranking stands
on its own (no movement column) and the user is told to save it for next time.

## Output

Respond in the seller's language (pt-BR by default), with no commentary about how
the result was produced. Use plain markdown so it renders cleanly in any client.

There is **one canonical brand-ranking table**, used everywhere (in the response
text and mirrored by the downloadable file). One row per brand, sorted by current
position, with these columns:

- **Posição** — current rank (1, 2, 3 …).
- **Variação** — *(comparison only)* how the brand's position moved versus the
  supplied previous table. **Omit this column entirely on a standalone ranking** —
  with no previous table there is no movement to show.
- **Marca** — the brand.
- **GMV estimado (semana)** — the brand's estimated weekly revenue (estimate).
- **Vendas est. (semana)** — the brand's estimated weekly sales (estimate).
- **Anúncios** — listing count for the brand.
- **Avaliações** — total review count (real history).
- **Preço médio** — average listing price, or `—` if unavailable.

So a **standalone ranking** has the columns `Posição | Marca | GMV estimado
(semana) | Vendas est. (semana) | Anúncios | Avaliações | Preço médio`; a
**comparison** adds the `Variação` column right after `Posição`.

In the `Variação` cell (comparison only), mark each brand:

- 🟢 **subiu no ranking**
- 🔴 **caiu no ranking**
- 🆕 **novo** (não estava no ranking anterior)
- = **sem mudança**

The change column header is the **word `Variação`** — never a bare delta symbol.

Below the table, include the category's **JoomPulse link**. On a comparison, state
the period being compared (for example *"Comparado com a tabela de 12/06"*). On a
standalone ranking, invite the user to save the table and send it back next period
to see how positions moved.

**Disclaimer (every report):**

> ⚠️ **Vendas e receita são estimativas** do JoomPulse com base no histórico de
> anúncios — não são transações reais. **Avaliações são histórico real** do
> Mercado Livre.

## Visualization

Layer a visual summary on top of the markdown table — never instead of it. The
visuals summarize; the **ranked table is always the deliverable**. Pick the path
by surface and never block waiting for a visual.

**When the client can render inline visuals,** present metric cards plus the bar
chart:

- **Three cards:**
  - **Marcas ativas** — the number of named brands in the ranking.
  - **Líder** — the #1 brand's name and its **share %** of total estimated weekly
    revenue across the ranked brands.
  - **Maior alta** — the brand that climbed the most and how many positions it
    rose. **Only with a comparison** (a previous table supplied); on a standalone
    ranking, drop this card or replace it with a neutral one — for example **GMV
    total estimado (semana)** of the ranked brands — never fabricate a rise.
- **Horizontal bar chart:** the top ~10 brands by **GMV estimado (semana)**,
  descending. Use a neutral single-hue ramp — this bar ranks size, it does not
  signal good or bad, so no semantic green/red.

**Otherwise (a terminal or any client without inline visuals),** present the same
three cards as a short text block (label and value per line) and let the markdown
table itself carry the ranking. Do not attempt a visual widget; never block
waiting for one.

**Tables always render as markdown,** on every surface — the ranked table lives in
the response text, never inside a rendered visual.

### Ranked table (always markdown, both surfaces)

The ranked table is the **one canonical brand-ranking table defined in Output** —
the same columns, in pt-BR, on every surface. It lives in the response text, never
inside a rendered visual.

- **Standalone ranking:** columns `Posição | Marca | GMV estimado (semana) |
  Vendas est. (semana) | Anúncios | Avaliações | Preço médio` — **no `Variação`
  column and no legend** (with no symbols in the table a legend only adds noise).
- **Comparison (a previous table supplied):** add the `Variação` column right after
  `Posição`. The change column header is the **word `Variação`** — never a bare
  delta symbol. Cell markers:
  - 🟢 **subiu no ranking**
  - 🔴 **caiu no ranking**
  - 🆕 **novo** (não estava no ranking anterior)
  - = **sem mudança**
- **Show the marker legend (🟢 / 🔴 / 🆕 / =) only in the comparison**, where those
  markers actually appear — never on a standalone ranking.

Render the bar chart only when the data supports it; if there are too few brands
to be meaningful, skip the chart and keep the table.

**Formatting (both surfaces):** round numbers and format in pt-BR — revenue as
`R$ 1,2 mi` / `R$ 850 mil` / `R$ 4.300`; counts with `.` as the thousands
separator (`1.250`). Keep the ⚠️ estimate disclaimer on every output.

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **No category given or an ambiguous name:** ask for the category (name,
  identifier, or JoomPulse link) before going further.
- **No active listings or no brands in the category:** say no brand data is
  available for this category right now, and offer to try a different or broader
  category.
- **Mostly unbranded listings:** rank only the named brands, and mention how many
  listings had no brand rather than letting an unnamed bucket dominate the top.
- **Market data temporarily unavailable:** retry once quietly; if it is still
  down, say market data is temporarily unavailable and suggest re-running. Never
  paste internal error text, HTTP codes, or field names to the seller.
- **No previous table supplied:** render today's ranking only (no movement column,
  no legend) and invite the user to save it for next time.
- **Supplied table is for a different category, malformed, or unreadable:** say so
  plainly and fall back to the standalone ranking; do not force a misaligned
  comparison.
- **Never silently limit coverage** — if the category is large and only part of it
  was scanned, say the coverage was broad rather than presenting it as complete.
