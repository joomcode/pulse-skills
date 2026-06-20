---
name: category-top-100-change-tracker
description: >
  Weekly change tracker for the top ~100 sellers in one Mercado Livre (Brasil)
  category, ranked by estimated average revenue, that adds a per-seller
  week-over-week movement column (rank rose or fell, plus the most notable metric
  change). Powered by JoomPulse. Use it when a seller wants ongoing weekly
  monitoring of a category's top-100 leaderboard and its movers. Triggers include:
  "track top sellers in this category", "weekly seller ranking changes", "who
  moved up or down in this category", "category top 100 movers", and the pt-BR
  equivalents "acompanhar os principais vendedores da categoria", "ranking semanal
  de vendedores", "quem subiu ou caiu na categoria", "top 100 da categoria essa
  semana". Sales and revenue are JoomPulse estimates, not real transactions. For a
  single point-in-time leaderboard with no diffs, use the top-sellers skill; to
  monitor one seller over time, use the seller-overview tracker.
---

# Category Top-100 Change Tracker

This skill builds the **top ~100 sellers in a Mercado Livre (Brasil) category**
(ranked by estimated average revenue) and reports **what changed for each since
the last run** — how far each seller's rank rose or fell, plus the most notable
change in their key numbers. It is the weekly twin of the top-sellers skill: the
same leaderboard, plus movement.

Each run is its own session, and the previous run's recorded table is the
baseline. For a one-shot leaderboard with no movement, use the top-sellers skill.
To monitor a single named seller over time, use the seller-overview tracker. It
pairs well with a weekly schedule.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user names a category (free text is fine), set once at setup.
- The available JoomPulse tools can find the sellers active in a category and
  return each seller's profile, so a ranked table can be built and compared run to
  run.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can track the leaderboard.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **Sales and revenue are JoomPulse estimates** derived from historical listing
  data — not real transactions. Cancellation rate and last-365-day completed sales
  are real history. Disclose the estimate caveat in every output.
- **Read-only.** The skill never writes or modifies anything.
- **Language:** detect the seller's language and respond in it. Default to pt-BR.
- **Run-to-run comparison.** There is no minute-by-minute history; movement is
  measured between this run and the previous run's recorded table.

## Workflow

1. Resolve the category and build the ranked top-100 by estimated average revenue
   (same fields as the top-sellers skill).
2. **First run** (no previous output): present the ranked table as the starting
   baseline, state that monitoring has begun, and report no movement.
3. **Subsequent runs:** read the previous run's recorded table and, per seller,
   compute the rank movement (rose N, fell N, unchanged, or new to the top), and
   flag the single most notable metric change as `antigo → novo` (for example when
   estimated revenue or sales moved by roughly 10% or more, cancellation rate
   moved about a point, or sales trend flipped sign). A change requires both an old
   and a new value for the same seller — no previous entry means "new", never a
   fabricated trend.
4. **Always end by restating the full current ranked table** — it is the next
   run's baseline. On an empty or failed run, say so and keep the previous baseline.

## Output

Respond in the seller's language (default pt-BR).

- A one-line verdict (first run: monitoring started; later: the biggest mover or
  "sem mudanças relevantes").
- **Destaques da semana** (subsequent runs only): two short lists — biggest risers
  🟢 and biggest fallers 🔴 (seller + positions moved).
- **The ranked table** (always markdown), same seller columns as the top-sellers
  skill plus a **Variação** column: 🟢 ↑N (subiu N posições) / 🔴 ↓N (caiu N
  posições) / 🆕 novo / = igual. The seller name links to its JoomPulse page.
- On the **first run**, omit the Variação column and the Destaques lists entirely
  and label the table as the baseline.

**Disclaimer (every report):**

> ⚠️ Vendas e receita são estimativas do JoomPulse com base no histórico de
> anúncios — não são transações reais. Taxa de cancelamento e vendas dos últimos
> 365 dias são dados reais do Mercado Livre.

## Visualization

When the client can render inline visuals, present a small set of summary cards
above the table; otherwise show the same as text. There is no medal bar here (that
belongs to the top-sellers skill). The ranked table and the Destaques lists always
render as markdown in the response text, on every surface, and the ⚠️ disclaimer
always stays in the text.

When inline visuals are available, show up to four cards: number of sellers
tracked, biggest riser of the week (seller + positions), biggest faller of the
week, and number of new entrants. On the first run, show only the count of sellers
tracked.

Presentation rules: the change column uses a word header ("Variação"), never a
bare "Δ" symbol. Show the 🟢/🔴/🆕 marker legend **only on runs where those
markers actually appear** in the table — never on the first or baseline run.

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **First run / no baseline:** ranked snapshot only, no movement column, no legend.
- **Seller left the top-100:** note it in a short "saíram do top 100" line rather
  than dropping it silently.
- **Empty or failed run:** say the data is temporarily unavailable, keep the
  previous baseline intact, do not overwrite it. Never paste internal error text,
  HTTP codes, or field names to the seller.
