---
name: top-sellers-in-category
description: >
  Ranks the top sellers in one Mercado Livre (Brasil) category by estimated
  average monthly revenue — a single point-in-time leaderboard, no week-over-week diffs —
  using JoomPulse. For each seller it shows estimated average sales and revenue,
  completed sales over the last 365 days, cancellation rate, sales trend, brands,
  product distribution (all and with sales), international shipping, and classic
  and premium listing counts, with a JoomPulse link per seller. Use it when a
  seller wants to know who the biggest stores in a category are. Triggers include:
  "top sellers in this category", "biggest stores in a category", "rank sellers by
  revenue", and the pt-BR equivalents "principais vendedores da categoria",
  "maiores lojas da categoria", "ranking de vendedores por receita", "quem mais
  vende nessa categoria". Sales and revenue are JoomPulse estimates, not real
  transactions. To track how that ranking moves week over week, use the
  category-top-100 change tracker; to monitor one seller over time, use the
  seller-overview tracker.
---

# Top Sellers In Category

This skill returns the **top sellers in one Mercado Livre (Brasil) category**,
ranked by estimated average monthly revenue — a single snapshot, with no
week-over-week movement. For each seller it shows estimated average monthly sales
and revenue, completed sales over the last 365 days, cancellation rate, sales
trend, brands, how their
products split between all listings and listings with sales, international
shipping, and classic versus premium listing counts.

This is a point-in-time leaderboard. To track how the ranking rises and falls week
over week, use the category-top-100 change tracker. To monitor a single named
seller over time, use the seller-overview tracker. To rank brands rather than
sellers, use the brand-position tracker.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user names a category (free text is fine).
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
- **Read-only.** The skill never writes or modifies anything.
- **Language:** detect the seller's language and respond in it. Default to pt-BR.
- **Keep the workflow invisible.** Show `—` for any missing value; never fabricate.

## Workflow

### Step 1 — Resolve the category and find its sellers

Ask for a category if none was given, then use JoomPulse to match the free text to
a category and find the sellers active in it.

### Step 2 — Rank by estimated average monthly revenue

Rank the sellers by **estimated average monthly revenue**, highest first. Keep a
sensible top (for example top 50, offer more on request), and treat the count as a
cap — show fewer if fewer exist.

## Output

Respond in the seller's language (default pt-BR). The leaderboard always renders as
a markdown table:

| Vendedor | Vendas méd. (mês) | Receita média (mês) | Vendas 365d | Cancel rate | Sales trend | Marcas | Produtos (todos) | Produtos (com venda) | Envio internacional | Classic | Premium |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|

- The **Vendedor** name links to the seller's JoomPulse page.

**Disclaimer (every report):**

> ⚠️ Vendas e receita são estimativas do JoomPulse com base no histórico de
> anúncios — não são transações reais. Taxa de cancelamento e vendas dos últimos
> 365 dias são dados reais do Mercado Livre.

## Visualization

When the client can render inline visuals, present metric cards and charts;
otherwise fall back to the markdown table plus text cards. Never block on visuals.
The seller table always renders as markdown, on every surface, and the ⚠️
disclaimer always stays in the text.

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
the data supports it; any movement column uses a word header, never a bare "Δ".

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **Small sample:** if only a few sellers come back, say so rather than implying it
  is the whole category.
- **Market data temporarily unavailable:** retry once quietly; if it is still
  down, say market data is temporarily unavailable and to try again. Never paste
  internal error text, HTTP codes, or field names to the seller.
- **Never silently limit coverage** — state the top cap you used.
