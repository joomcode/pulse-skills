---
name: top-brand-position-tracker
description: >
  Ranks the brands within one Mercado Livre (Brasil) category and tracks how each
  brand's position in that ranking changes week over week, using JoomPulse data.
  It builds a brand leaderboard by ranking brands in a category by estimated
  weekly sales and revenue, aggregated across their active listings, then on later
  runs compares each brand's rank to the previous run (rose, fell, new, or
  unchanged). Use it when a seller wants to know who the top brands in a category
  are, which brands are rising or falling, or to monitor brand share over time.
  Triggers include: "top brands in this category", "which brands are growing",
  "brand ranking", "track brand positions", and the pt-BR equivalents "principais
  marcas da categoria", "ranking de marcas", "quais marcas estão crescendo",
  "acompanhar posição das marcas". Mercado Livre (Brasil) only; sales and revenue
  are JoomPulse estimates, not real transactions. For ranking sellers (shops)
  rather than brands, use the seller-ranking skills; for category-level market
  size and opportunity, use the category opportunity skill.
---

# Top brand position tracker

This skill ranks the **brands** inside one Mercado Livre (Brasil) category and
**tracks how each brand's position in that ranking moves week over week**. It
ranks brands in a category by estimated weekly sales and revenue, aggregated
across their active listings, to build a leaderboard. On the **first run** this
ranking is the baseline; on **later runs** it shows how each brand rose or fell in
the table compared with the previous run.

This is different from ranking sellers or sizing a category. To rank **sellers
(shops)** in a category, or to track how a seller leaderboard moves week over
week, use the seller-ranking skills. To report a category's market size and
opportunity (estimated GMV, sales, number of sellers, average ticket), use the
category opportunity skill. This skill answers **"which brands lead this category,
and how did their positions move this week?"**

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user provides the category to analyze — a category name, a category
  identifier, or a JoomPulse category link.
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
  anything.
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
3. **Group the listings by brand and aggregate per brand.** Drop listings with no
   brand; if unbranded listings are material, mention how many had no brand rather
   than letting an unnamed bucket top the ranking. For each brand compute:
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

### Step 2 — Add the week-over-week position change

This is a weekly tracker: each run is its own conversation and compares with the
previous run's recorded brand table as the baseline.

- **First run (no previous brand table):** present the ranking as the **baseline**.
  State that brand monitoring for this category has begun and that there are no
  position changes yet.
- **Later runs:** read the previous run's recorded brand table, match brands by
  name, and for each brand compare its previous position with its current one:
  - rose N places → rose by N
  - fell N places → fell by N
  - same position → unchanged
  - not in the previous table → new
  - in the previous table but absent now → list it below the table as *"saiu do
    ranking"* — do not fabricate a position for it.
  A position change requires both a previous and a current position for the same
  brand — never invent a trend.

Always end by restating the full current brand table — it becomes the next run's
baseline. Keep the previous baseline intact if a run returns no data; do not
overwrite it with an empty table.

## Output

Respond in the seller's language (pt-BR by default), with no commentary about how
the result was produced. Use plain markdown so it renders cleanly in any client.

**Brand ranking table** — one row per brand, sorted by current position, with
these columns:

- **Posição** — current rank (1, 2, 3 …).
- **Movimento** — rose / fell / unchanged / new per the rule above (all unchanged
  or new on the first run).
- **Marca** — the brand.
- **GMV estimado (semana)** — the brand's estimated weekly revenue (estimate).
- **Vendas est. (semana)** — the brand's estimated weekly sales (estimate).
- **Anúncios** — listing count for the brand.
- **Avaliações** — total review count (real history).
- **Preço médio** — average listing price, or `—` if unavailable.

Below the table, include the category's **JoomPulse link** and state the period
being compared (for example *"Comparado com a execução de 12/06"*) or, on the
first run, *"Primeira execução — linha de base registrada; sem variações ainda."*

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
  - **Maior alta da semana** — the brand that climbed the most and how many
    positions it rose. On the **first run** (no week-over-week change yet), drop
    this card or replace it with a neutral one — for example **GMV total estimado
    (semana)** of the ranked brands — never fabricate a rise.
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

A compact ranked view, sorted by current position:

`| Pos. | Marca | GMV (semana) | Vendas (semana) | Listings | Variação |`

- The change column header is the **word `Variação`** — never a bare delta symbol.
  Cell markers:
  - 🟢 **subiu no ranking**
  - 🔴 **caiu no ranking**
  - 🆕 **novo** (não estava no ranking anterior)
  - = **sem mudança**
- **Show the marker legend (🟢 / 🔴 / 🆕 / =) only on runs where those markers
  actually appear** in the table — that is, later runs. **Never print the legend on
  the first/baseline run**: with no symbols in the table it only adds noise.
- **First run:** omit the `Variação` column entirely and label the table as the
  **baseline** (linha de base) — no diffs yet, no legend.

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
  down, say market data is temporarily unavailable, keep the previous baseline
  intact, and suggest re-running. Never paste internal error text, HTTP codes, or
  field names to the seller.
- **First run vs. no previous table found:** treat it as a first run — baseline
  only, no diffs.
- **Never silently limit coverage** — if the category is large and only part of it
  was scanned, say the coverage was broad rather than presenting it as complete.
