---
name: seller-overview-tracker
description: >
  Snapshot tracker for one Mercado Livre (Brasil) seller via JoomPulse — estimated monthly
  revenue and sales, listing count, sales trend, reputation, seller medal, categories covered,
  and cancellation rate. Each run builds today's snapshot table and offers it for download; to
  see what changed, the user sends the seller's table from a previous period and the skill
  shows the metric-by-metric difference (old → new). The baseline is whatever table the user
  supplies — no hidden session memory. Use it to track one specific seller over time.
  Triggers: "track this seller", "monitor this store", "what changed for this seller",
  "compare this seller with last period", and the pt-BR "monitorar este vendedor", "acompanhar
  esta loja", "o que mudou nesse vendedor". Sales and revenue are JoomPulse estimates, not
  real transactions. To rank many sellers in a category and track how that ranking moves, use
  the top-sellers-in-category skill. Mercado Livre (Brasil) only.
---

# Seller Overview Tracker

This skill tracks **one Mercado Livre (Brasil) seller over time** — its estimated
monthly revenue and sales, listing count, sales trend, reputation, seller medal,
the categories it covers, and its cancellation rate.

Each run builds **today's snapshot table** for the seller and offers it as a
**downloadable table**. To see what changed, the user **supplies the seller's table
from a previous period** (the one this skill produced before); the skill compares
the two and shows the difference per metric. **The baseline is whatever table the
user provides — there is no hidden session memory and nothing is stored
server-side.** The seller is identified by a store link or a seller identifier.

It is different from ranking work: to rank many sellers in a category and track how
that ranking moves, use the top-sellers-in-category skill; to analyze one product, use
the single-product analysis skill. This skill follows **one** seller.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user provides one seller as a Mercado Livre store link or a seller identifier.
- For a period comparison, the user supplies a previous table that this skill
  produced for the same seller (pasted or uploaded). Without it, the skill produces
  a standalone snapshot.
- The available JoomPulse tools can look up that seller's current market snapshot.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can monitor a seller.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **Sales and revenue are JoomPulse estimates** — estimated monthly revenue,
  estimated monthly sales, average ticket, and average price are not real
  transactions. Disclose this in every output. By contrast, the rolling 60-day
  and 365-day sales counts, the sales trend, and the cancellation rate are real
  Mercado Livre data.
- **Read-only.** The skill never signs in as the seller or modifies a listing; it
  does not store the snapshot — the user keeps the downloadable table and brings it
  back next period.
- **Language:** respond in pt-BR by default; mirror another language only if the
  user clearly uses it.
- **The baseline is user-supplied.** Never claim a change without a previous table
  to compare against, and never infer or fabricate one from memory.
- **Keep the workflow invisible.** The user wants the answer, not a play-by-play.
  If one approach does not return data, retry quietly; only if it still fails do
  you say one short, friendly sentence.

## Workflow

### Step 1 — Resolve the seller and pull today's snapshot

1. Resolve the seller from the store link or seller identifier the user provided.
   If given a store link, resolve it to the seller once.
2. Use JoomPulse to pull the current snapshot for that one seller: store name,
   estimated monthly revenue, estimated monthly sales, sales trend, cancellation
   rate, listing count, rolling 60-day and 365-day sales, the categories covered,
   seller medal, reputation, average ticket and average price, and location.
3. If the seller is not found, say so plainly and stop — invent nothing.

### Step 2 — Present today's snapshot and offer it for download

Lay out the snapshot fields as a table, headed with the store name and the date.
This table is the deliverable — and **offer it as a downloadable file (`.csv` /
`.xlsx`)** so the user can save it and bring it back next period as the baseline.
If any field comes back empty, show `—`; never substitute a guess. Add the JoomPulse
seller dashboard link. On a standalone snapshot there is **no change column and no
color-dot legend** — just field and current value.

### Step 3 — Offer comparison, and compare if a previous table is supplied

Invite the user to send a previous table for the same seller to compare periods.
**If they provide one**, parse its values, align by field to today's snapshot, and
render a comparison table with the difference per field. A difference **requires
both an old and a new value** for the same field — if a field is missing or
unreadable in the supplied table, show `—`, never a fabricated trend. If no previous
table is supplied, the snapshot stands on its own and the user is told to save it
for next time.

## Output

Respond in pt-BR by default. Present the result with no commentary about how it was
produced.

**Snapshot (always):** a markdown table `| Campo | Valor atual |` for the rows
below, plus a downloadable `.csv` / `.xlsx` of the same data.

The snapshot / comparison table carries these rows (pt-BR labels):

- Nome da loja
- Receita média mensal (estimada)
- Vendas médias mensais (estimadas)
- Tendência de vendas
- Taxa de cancelamento
- Anúncios
- Vendas (60 dias)
- Vendas (365 dias)
- Categorias
- Medalha (platina / ouro / prata / sem medalha)
- Reputação (5 verde, a melhor … 1 vermelho, a pior)
- Ticket médio / preço médio
- Localização (cidade, estado, país)
- Link JoomPulse do vendedor

**Comparison (only when a previous table is supplied):** a markdown table
`| Campo | Era | Agora |`. Put the change (figure, percentage, or percentage point)
inside the **Agora** cell, prefixed with a semantic color dot:

- 🟢 **good:** revenue up, sales up, listings up, medal improved, reputation
  improved, cancellation rate **down**.
- 🔴 **bad:** revenue down, sales down, listings down, medal worse, reputation
  worse, cancellation rate **up**.
- The **cancellation rate is inverted** — down = 🟢, up = 🔴.
- **Categorias** moving is neutral context — show the change with **no color dot**.

Column headers are words (`Campo | Era | Agora`), never a bare "Δ" symbol. Show the
color-dot legend (🟢/🔴) **only** in the comparison table, where the dots actually
appear — never on a plain snapshot.

Close with a short **Principais insights** section: with a comparison, interpret
what moved; on a standalone snapshot, frame it as the starting picture with no trend
claims.

**Disclaimer (every report):**

> ⚠️ Receita e vendas são estimativas do JoomPulse com base no histórico de
> anúncios — não são transações reais. / Revenue and sales are JoomPulse estimates
> based on historical listing data — not actual transactions.

Keep it concise — no methodology, no internal jargon, and do not explain these rules
to the user.

## Visualization

Surface-aware. **Never block on visuals** — if anything fails, fall back to the
markdown rendering below. The snapshot table (and the comparison table, when
present) always render as markdown in the response text, and the downloadable file
mirrors what is shown.

- **When the client can render inline visuals**, present **metric cards** for the
  key current metrics — for example estimated monthly revenue, estimated monthly
  sales, listings, cancellation rate, and medal / reputation. With a comparison, you
  may annotate each card with its `era → agora` change.
- **Otherwise** (plain terminal, no visual support), output the same information as a
  markdown table plus a short text summary. Same numbers, no visual.
- **Round all displayed numbers** and use **pt-BR number and currency formatting**
  (for example `R$ 1,38 mi`, `7.900`, `+1,3 p.p.`) everywhere — cards and table.
- Use a consistent medal palette: platina = purple, ouro = amber, prata = blue, sem
  medalha = white with a thin border (white needs the border to stay visible on a
  light background).
- **No synthesized trend line from a single snapshot** (there is no server-side
  history). Only if the user supplies several past-period tables may you plot a
  simple line across those periods.

Example comparison table (only when a previous table is supplied):

| Campo | Era | Agora |
|---|---|---|
| Receita mensal (est.) | R$ 1,20 mi | 🟢 R$ 1,38 mi · ↑ +15% |
| Vendas/mês (est.) | 8.400 | 🔴 7.900 · ↓ −6% |
| Medalha | Ouro | 🟢 Platina · ↑ |
| Reputação | 4 verde-claro | 🟢 5 verde · ↑ |
| Taxa de cancelamento | 2,1% | 🔴 3,4% · ↑ +1,3 p.p. |
| Categorias | 12 | 14 · +2 |

Presentation rules: column headers are words, never a bare "Δ" symbol; show the
color-dot legend only when those dots appear (the comparison table); render a chart
only when the data supports it.

## Notes & Guardrails

The user should never see a system or stack error — only a friendly next step.
Translate any failure into one short, friendly sentence, and retry once quietly on a
transient hiccup.

- **Seller not found:** state it plainly, stop, and invent nothing.
- **No previous table supplied:** render today's snapshot only (no change column, no
  legend) and invite the user to save it for next time.
- **Supplied table is for a different seller, malformed, or unreadable:** say so
  plainly and fall back to the snapshot only; do not force a misaligned comparison.
- **Empty or failed pull:** say the data is temporarily unavailable and to try
  again. Never paste internal error text, HTTP codes, or field names to the user.
- **A single field empty but the seller is found:** show `—` for that field and keep
  the rest.
