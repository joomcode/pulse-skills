---
name: top-sellers-in-category
description: >
  Ranks the top sellers in one Mercado Livre (Brasil) category by estimated
  average monthly revenue, using JoomPulse, and returns a downloadable leaderboard
  — for each seller: estimated average monthly sales and revenue, completed sales
  over the last 365 days, cancellation rate, sales trend, brands, product
  distribution (all and with sales), international shipping, and classic and
  premium listing counts, with a JoomPulse link per seller. It can also track how
  the ranking moved: supply a previous-period leaderboard this skill produced for
  the same category and it shows each seller's movement (rose / fell / new) plus
  the biggest movers. Use it to see who the biggest stores in a category are and
  how that ranking is shifting. Triggers include: "top sellers in this category",
  "biggest stores in a category", "rank sellers by revenue", "who moved up or down
  in this category", "track top sellers", and the pt-BR equivalents "principais
  vendedores da categoria", "maiores lojas da categoria", "ranking de vendedores
  por receita", "quem subiu ou caiu na categoria", "quem mais vende nessa
  categoria". Sales and revenue are JoomPulse estimates, not real transactions. To
  monitor one seller over time, use the seller-overview tracker; to rank brands
  rather than sellers, use the brand-position tracker.
---

# Top Sellers In Category

This skill returns the **top sellers in one Mercado Livre (Brasil) category**,
ranked by estimated average monthly revenue. For each seller it shows estimated
average monthly sales and revenue, completed sales over the last 365 days,
cancellation rate, sales trend, brands, how their products split between all
listings and listings with sales, international shipping, and classic versus
premium listing counts.

By default it produces **today's leaderboard** as a downloadable table. It can
also show **how the ranking moved over time**: if you supply a previous-period
leaderboard that this skill produced for the same category, it compares the two
and reports each seller's movement (rose / fell / new) plus the biggest movers.
**The baseline is the table you supply — there is no hidden session memory.**

To monitor a single named seller over time, use the seller-overview tracker. To
rank brands rather than sellers, use the brand-position tracker.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user names a category (free text is fine).
- For a period comparison, the user supplies a previous leaderboard that this
  skill produced for the same category (pasted or uploaded). Without it, the skill
  produces a standalone leaderboard.
- The available JoomPulse tools can find the sellers active in a category and
  return each seller's profile (estimated average monthly sales and revenue,
  last-365-day completed sales, cancellation rate, sales trend, brands, listing
  distribution, international shipping, classic and premium listing counts).
  Seller medal — used to color the chart — and reputation are read when available.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can rank a category's sellers.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **Sales and revenue are JoomPulse estimates** derived from historical listing
  data — not real transactions. Cancellation rate and last-365-day completed sales
  are real history. Disclose the estimate caveat in every output.
- **Read-only.** The skill never writes or modifies anything; it does not store the
  leaderboard — the user keeps the downloadable table and brings it back next period.
- **Language:** detect the seller's language and respond in it. Default to pt-BR.
- **The baseline is user-supplied.** Never claim a movement without a previous
  leaderboard to compare against, and never infer or fabricate one from memory.

## Workflow

### Step 1 — Resolve the category and find its sellers

Ask for a category if none was given, then use JoomPulse to match the free text to
a category and find the sellers active in it.

### Step 2 — Rank by estimated average monthly revenue

Rank the sellers by **estimated average monthly revenue**, highest first. Keep a
sensible top (default about 50, up to about 100 on request), and treat the count
as a cap — show fewer if fewer exist.

### Step 3 — Present today's leaderboard and offer it for download

Render the leaderboard for **today** (head it with the category name and the date).
This table is the deliverable — and **offer it as a downloadable file (`.csv` /
`.xlsx`)** so the user can save it and bring it back next period as the baseline.
On a standalone leaderboard there is **no movement column and no legend**.

### Step 4 — Offer comparison, and compare if a previous leaderboard is supplied

Invite the user to send a previous leaderboard for the same category to compare
periods. **If they provide one**, align by seller and report:

- a **Variação** column per seller: 🟢 subiu N / 🔴 caiu N / 🆕 novo / = igual, and
  note sellers that **left** the top in a short "saíram do top" line;
- a short **Destaques** block — biggest risers 🟢 and biggest fallers 🔴.

A movement **requires both an old and a new position/value** for the same seller —
no previous entry means "novo", never a fabricated trend. Show the 🟢/🔴 legend
**only** in the comparison (where the markers actually appear), never on a plain
leaderboard. The change column header is a word ("Variação"), never a bare "Δ".

## Output

Respond in the seller's language (default pt-BR).

**Leaderboard (always):** a markdown table, plus a downloadable `.csv` / `.xlsx`:

| Vendedor | Vendas méd. (mês) | Receita média (mês) | Vendas 365d | Cancel rate | Sales trend | Marcas | Produtos (todos) | Produtos (com venda) | Envio internacional | Classic | Premium |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|

- The **Vendedor** name links to the seller's JoomPulse page.

**Comparison (only when a previous leaderboard is supplied):** the same table plus
a **Variação** column, and a **Destaques** block (maiores altas / maiores quedas).

**Disclaimer (every report):**

> ⚠️ Vendas e receita são estimativas do JoomPulse com base no histórico de
> anúncios — não são transações reais. Taxa de cancelamento e vendas dos últimos
> 365 dias são dados reais do Mercado Livre.

## Visualization

When the client can render inline visuals, present metric cards and charts;
otherwise fall back to the markdown table plus text cards. Never block on visuals.
The leaderboard (and the comparison, when present) always renders as markdown in
the response text, the downloadable file mirrors it, and the ⚠️ disclaimer always
stays in the text.

When inline visuals are available:

- **Four cards:** number of sellers in the category (and how many have sales), the
  leader's share of the shortlist's revenue, the average monthly revenue across
  the top, and the average ticket.
- **A horizontal bar** of the top ~10 sellers by estimated average monthly revenue,
  **colored by seller medal** — platina = purple, ouro = amber, prata = blue, sem
  medalha = white with a thin border (white needs the border to stay visible on a
  light background). Include a small legend mapping color to medal. When one seller
  dwarfs the rest, you may show that leader as a separate highlighted figure and
  chart the remaining leaders so the medal colors stay readable.
- **A small "registered versus with sales" comparison** for sellers and for
  products, to show how much of the supply actually converts.

Presentation rules: use the medal palette consistently; render a chart only when
the data supports it; the movement/Variação column uses a word header, never a bare
"Δ", and its 🟢/🔴 legend appears only when a comparison is shown.

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **No previous leaderboard supplied:** render today's leaderboard only (no
  movement column, no legend) and invite the user to save it for next time.
- **Supplied table is for a different category, malformed, or unreadable:** say so
  plainly and fall back to the leaderboard only; do not force a misaligned comparison.
- **Small sample:** if only a few sellers come back, say so rather than implying it
  is the whole category.
- **Market data temporarily unavailable:** retry once quietly; if it is still
  down, say market data is temporarily unavailable and to try again. Never paste
  internal error text, HTTP codes, or field names to the seller.
- **Never silently limit coverage** — state the top cap you used.
