---
name: new-growing-products-in-category
description: >
  Finds new, already-selling product listings inside one Mercado Livre (Brasil)
  category on JoomPulse — recent listings (by default under about 30 days on air)
  that are well rated (rating above 3) and have real traction (more than about 30
  estimated sales in the last month), all thresholds overridable — and returns
  them as a product table with a JoomPulse link per listing. Use it when a seller
  wants fresh, promising entrants in a niche. Triggers include: "new products in
  category", "what's launching and already selling", "recent best-sellers in
  <category>", and the pt-BR equivalents "produtos novos na categoria", "novos
  anúncios que já vendem", "lançamentos em alta em <categoria>". Mercado Livre
  (Brasil) only; sales and revenue are JoomPulse estimates, not real transactions,
  while price, rating, and review count are real history. For weak-rated but
  well-selling products to beat, use the high-demand low-quality skill; for
  whole-catalog expansion, use the gap-analysis skill; for tracking one product
  over time, use the product change-monitor skill.
---

# New & Growing Products in a Category

This skill surfaces **newly launched listings that are already selling well**
inside one Mercado Livre (Brasil) category, using JoomPulse market data. The
seller picks a category; the skill returns the recent, well-rated,
traction-having listings as a product table, each row linking to its JoomPulse
page so the seller can dig deeper.

This is a discovery snapshot, not a tracker and not a whole-catalog audit. For
products that sell well but are poorly rated — gaps you can enter with a better
offer — use the high-demand low-quality skill. To decide which new products to
add across a whole catalog, use the gap-analysis skill. To follow how one product
moves over time, use the product change-monitor skill. This skill answers "which
fresh entrants in this niche are already getting traction right now?"

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user provides a category, either by name or by its category identifier.
- The available JoomPulse tools can look up the active listings in a category and
  resolve a category name to its identifier.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can find new growing products in a category.

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

### Step 1 — Capture the category and confirm the thresholds

1. Ask the user for the **category** — a name or a category identifier.
2. The skill keeps three filters, each with a **default the user may override**:
   - **recently listed** — under about 30 days on air;
   - **well rated** — rating above 3;
   - **real traction** — more than about 30 estimated sales in the last month.
3. Echo back what you captured (the category plus the three thresholds in use) so
   the user can adjust before you run, then remember those inputs for the rest of
   the run.
4. If the user gave a category **name**, resolve it to its identifier first with
   JoomPulse, matching the current category list. If the name is ambiguous, list
   the candidate categories with their level and ask which one. If the user
   already gave an identifier, skip resolution.

### Step 2 — Find the new, already-selling listings

1. Use JoomPulse to retrieve the **active listings** in that category, with the
   fields each row needs: name, seller, listing type, seller medal, free shipping
   and Mercado Envios Full flags, price, estimated weekly sales and revenue,
   estimated monthly sales, rating, review count, and how long the listing has
   been on air. Pull a generous set of listings so the filters have room to work.
2. **Apply the three filters** to the retrieved listings: keep only those that
   are recently listed (under the day-on-air threshold), well rated (above the
   rating threshold), and have real traction (above the monthly-sales threshold).
3. **Sort the survivors strongest-first** by estimated monthly sales, breaking
   ties by estimated weekly revenue, so the most promising fresh entrants are on
   top.

## Output

Respond in the seller's language. Present the result with no commentary about how
it was produced. Use plain markdown so it renders cleanly in any client.

Lead with a short intro line naming the category and the three thresholds
actually applied.

**Product table** — one row per surviving listing, in this order:

- Listing identifier (the Mercado Livre code), linked to its JoomPulse page
- Name
- Seller
- Price
- Estimated sales (weekly)
- Estimated revenue (weekly)
- Rating
- Reviews
- Time on air (days)
- Free shipping (Sim/Não)
- Mercado Envios Full (Sim/Não)
- Listing type
- Seller medal

Empty field → `—`; never guess or fabricate. Below the table, list the Mercado
Livre codes explicitly, each as a clickable JoomPulse link, so they are easy to
copy. You may translate the column headers into the seller's language.

**Disclaimer (every report):**

> ⚠️ Sales and revenue are JoomPulse **estimates** based on historical listing
> data — they are **not** actual transactions. Price, rating, and reviews are
> real Mercado Livre history. / Vendas e receita são **estimativas** do JoomPulse
> com base no histórico de anúncios — **não são transações reais**. Preço,
> classificação e avaliações são histórico real do Mercado Livre.

## Visualization

When the client can render inline visuals, present metric cards and, when the
data supports it, a bar chart above the markdown table; otherwise present a
short markdown cards block (or a tiny two-column Métrica | Valor table) plus
text. **The product table always renders as markdown**, never inside a widget —
it is the main deliverable.

- **Summary cards** over the surviving listings:
  - **Produtos novos encontrados** — how many listings survived the filters.
  - **Vendas/mês (mediana est.)** — median of the estimated monthly sales.
  - **Ticket médio** — average price across the survivors.
  - **Idade média (dias no ar)** — average time on air.
- **Top-N bar (optional)** — the strongest new products by estimated monthly
  sales. Label each bar with a short product name (truncate long ones) plus its
  Mercado Livre code. **Render this chart only when the data supports it** — skip
  it when fewer than four listings survive; the cards and table are enough.

This is a discovery list, not a week-over-week tracker, so it has **no change or
"Variação" column and no 🟢/🔴/🆕 legend** — those belong only to trackers that
compare runs. Use a neutral color ramp for the bar (no semantic coloring). If you
ever show seller medals as colored chips, use the standard palette: platina =
purple, ouro = amber, prata = blue, sem medalha = white with a thin border.

**Formatting (both surfaces):** round numbers and use pt-BR formatting — prices
and revenue as `R$` with `.` thousands and `,` decimals (e.g. `R$ 1.234,50`);
counts as integers with `.` thousands; rating to one decimal (e.g. `4,6`); time
on air as whole days. Empty field → `—`. The estimate disclaimer is mandatory on
every output.

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **No listings survive the filters:** say that no new listings currently match
  these thresholds in this category, and offer to relax them (for example, a
  larger day-on-air window or a lower monthly-sales floor). Keep it in pt-BR.
- **Category not found or ambiguous name:** list the candidate categories (name
  and level) and ask the user to pick one.
- **Empty fields:** show `—` for any value that is missing; never assume "no" for
  an unknown logistics flag and never fabricate a number.
- **Market data temporarily unavailable:** retry once quietly; if it is still
  down, say market data is temporarily unavailable and to try again shortly.
  Never paste internal error text, HTTP codes, or field names to the seller.
