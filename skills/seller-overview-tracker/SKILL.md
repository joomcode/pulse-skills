---
name: seller-overview-tracker
description: >
  Weekly snapshot tracker for one Mercado Livre (Brasil) seller, set up once by a
  store link or seller identifier, that reports what changed for that seller since
  the previous run — estimated monthly revenue and sales, listing count, sales
  trend, reputation, seller medal, categories covered, and cancellation rate.
  Powered by JoomPulse; sales and revenue are estimates, not real transactions.
  Use it when a user wants ongoing weekly monitoring of one specific tracked
  seller and "what changed since last week". Triggers include: "track this
  seller", "monitor this store weekly", "what changed for this seller", and the
  pt-BR equivalents "monitorar este vendedor", "acompanhar esta loja", "o que
  mudou nesse vendedor essa semana". For ranking many sellers in a category at one
  point in time, use the category seller-ranking skill; for tracking a category's
  top-100 movers week over week, use the category top-100 change-tracker skill;
  for analyzing a single product, use the single-product analysis skill. Mercado
  Livre (Brasil) only.
---

# Seller Overview Tracker (weekly)

This skill pulls a weekly snapshot of **one** tracked Mercado Livre (Brasil)
seller and reports **what changed since the previous run**. The seller is fixed
at setup — by a store link or a seller identifier — and never re-asked. Each run
is its own chat: the previous run's recorded table is the baseline, and this run
compares against it field by field.

It answers "how is this one seller doing, and what moved this week?" — estimated
monthly revenue and sales, listing count, sales trend, reputation, seller medal,
categories covered, and cancellation rate. It is different from ranking work: to
rank many sellers in a category at a single point in time, use the category
seller-ranking skill; to track a category's top-100 movers week over week, use
the category top-100 change-tracker skill; to analyze one product, use the
single-product analysis skill. This skill follows **one** seller over time.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user provides, at setup, one seller as a Mercado Livre store link or a
  seller identifier. This identifier is fixed for all future runs.
- The available JoomPulse tools can look up that seller's current market snapshot.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can monitor a seller.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **One seller per skill instance.** The tracked seller is resolved once at setup
  and never re-asked in chat.
- **Sales and revenue are JoomPulse estimates** — estimated monthly revenue,
  estimated monthly sales, average ticket, and average price are not real
  transactions. Disclose this in every output. By contrast, the rolling 60-day
  and 365-day sales counts, the sales trend, and the cancellation rate are real
  Mercado Livre data.
- **Read-only.** The skill does not sign in as the seller or modify any listing.
- **Language:** respond in pt-BR by default; mirror another language only if the
  user clearly uses it.
- **Keep the workflow invisible.** The user wants the answer, not a play-by-play.
  If one approach does not return data, retry quietly; only if it still fails do
  you say one short, friendly sentence.

## Workflow

### Step 1 — Resolve the seller and pull the snapshot

1. Use the fixed seller identifier from setup. If setup gave a store link,
   resolve it to the seller identifier once; that identifier is then fixed.
2. Use JoomPulse to pull the current snapshot for that one seller: store name,
   estimated monthly revenue, estimated monthly sales, sales trend, cancellation
   rate, listing count, rolling 60-day and 365-day sales, the categories covered,
   seller medal, reputation, average ticket and average price, and location.
3. If the seller is not found, say so plainly and stop — invent nothing.

### Step 2 — Build the snapshot table

1. Lay out the snapshot fields as a table. If any field comes back empty, show
   `—`; never substitute a guess.
2. Add the JoomPulse seller dashboard link for that seller.

### Step 3 — Compare against the previous run

- **First run** (no previous run output exists): present the table as the
  starting baseline, state that monitoring has begun, and that future runs will
  report changes. Do **not** report any "changes", "trends versus last week", or
  diffs of any kind.
- **Subsequent runs:** read the previous run's recorded table and compare field by
  field for the same seller. Report a change only when it crosses a threshold:
  - any revenue, sales, or listing-count metric moved **at least 5%**, or
  - reputation, seller medal, or the set of categories changed at all, or
  - the cancellation rate moved **at least 1 percentage point**.
  - Smaller moves are not listed. If nothing crossed a threshold, close with
    **"sem mudanças relevantes"**.
- Never report a change you cannot show as `old value → new value`, both taken
  from real run outputs. A diff requires both an old and a new value for the same
  seller — no old value means no diff.

### Step 4 — Restate the baseline

Always end by restating the **full current table** — it is the next run's
baseline. If this week's pull failed or returned empty, say data is temporarily
unavailable and **keep the previous baseline**; do not overwrite it.

## Output

Respond in pt-BR by default. Present the result with no commentary about how it
was produced. Structure:

1. **One-line verdict** — first run: "monitoramento iniciado"; later runs: the
   single most important change, or "sem mudanças".
2. **Changes** as `campo: antigo → novo` lines (subsequent runs only).
3. **The full current table** (the next run's baseline), with the JoomPulse
   seller link.

The snapshot / change table carries these rows (pt-BR labels):

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

End with the estimate disclaimer (every report):

> ⚠️ Receita e vendas são estimativas JoomPulse, não transações reais. /
> Sales and revenue are JoomPulse **estimates**, not real transactions.

Keep it concise — no methodology, no internal jargon, and do not explain these
rules to the user.

## Visualization

Surface-aware. **Never block on visuals** — if anything fails, fall back to the
markdown rendering below.

- **When the client can render inline visuals**, present **metric cards plus the
  appropriate chart** (the trend line, when it qualifies — see below).
- **Otherwise** (plain terminal, no visual support), output the same information
  as a markdown table plus a short text summary. Same numbers, no visual.
- **Tables always render as markdown in the response text**, even on surfaces that
  support visuals. Inline visuals carry only cards and charts; the change table
  and the snapshot table are always markdown.
- **Round all displayed numbers** and use **pt-BR number and currency formatting**
  (for example `R$ 1,38 mi`, `7.900`, `+1,3 p.p.`) everywhere — cards, charts, and
  table.

### Verdict

One-line verdict on top, as in **Output**: first run → "monitoramento iniciado";
later → the single most important change, or "sem mudanças".

### Change table (markdown, always)

Show **only the parameters that crossed a threshold** (metrics ≥5%, cancellation
rate ≥1 percentage point, reputation / medal / categories any change). Columns:

`Parâmetro | Era | Agora`

- Put the **dynamics (↑/↓ with the % or p.p.)** inside the **Agora** cell.
- Start the **Agora** cell with a **semantic color dot**:
  - 🟢 **good:** revenue up, sales up, listings up, medal improved, reputation
    improved, cancellation rate **down**.
  - 🔴 **bad:** revenue down, sales down, listings down, medal worse, reputation
    worse, cancellation rate **up**.
  - The **cancellation rate is inverted** — down = 🟢, up = 🔴.
  - **Categories:** show the change but with **no color dot** (neutral).
- Column headers are words (`Parâmetro | Era | Agora`) — never the bare `Δ`
  symbol. **Show the 🟢/🔴 (and 🆕) color-dot legend only on runs where those dots
  actually appear in the table — never on the first / baseline run.**

Example (subsequent run):

| Parâmetro | Era | Agora |
|---|---|---|
| Receita mensal (est.) | R$ 1,20 mi | 🟢 R$ 1,38 mi · ↑ +15% |
| Vendas/mês (est.) | 8.400 | 🔴 7.900 · ↓ −6% |
| Medalha | Ouro | 🟢 Platina · ↑ |
| Reputação | 4 verde-claro | 🟢 5 verde · ↑ |
| Taxa de cancelamento | 2,1% | 🔴 3,4% · ↑ +1,3 p.p. |
| Categorias | 12 | 14 · +2 |

### First run (baseline — no "Era")

The change table collapses to a **2-column snapshot** `Parâmetro | Valor atual`,
marked as the starting baseline. No diffs, no color dots, no legend, no chart.

### Trend line (revenue / sales by week)

- **Renders only at three or more accumulated runs.** The seller snapshot has no
  built-in time history (it reflects the current state), so a seller trend can be
  built **only** run-to-run from recorded past outputs.
- **Fewer than three runs → no chart**, table only.
- On surfaces that support visuals with three or more runs, render the trend
  (revenue and / or sales by week) as a line chart; on terminal surfaces,
  summarize the trend in text.

### Cards (visual surfaces)

Render the key current metrics as metric cards — for example estimated monthly
revenue, estimated monthly sales, listings, cancellation rate, and
medal / reputation — rounded and pt-BR-formatted. Use a consistent medal palette:
platina = purple, ouro = amber, prata = blue, sem medalha = white with a thin
border.

Always keep the mandatory disclaimer in the response: `⚠️ Receita e vendas são
estimativas JoomPulse, não transações reais.`

## Notes & Guardrails

The user should never see a system or stack error — only a friendly next step.
Translate any failure into one short, friendly sentence, and retry once quietly
on a transient hiccup.

- **Seller not found:** state it plainly, stop, and invent nothing.
- **Empty or failed pull:** say the data is temporarily unavailable, keep the
  previous baseline intact, and do not overwrite it.
- **First run with no baseline:** snapshot only, zero diffs.
- **A single field empty but the seller is found:** show `—` for that field and
  keep the rest.
- **Never paste system or error text** — no internal error text, HTTP codes, or
  field names. The user sees only the answer and, if needed, one friendly next
  step.
