---
name: category-opportunity-index
description: >
  Reports the JoomPulse opportunity index (low, medium, or high) for one
  Mercado Livre (Brasil) category, alongside that category's current monthly
  market stats — estimated GMV, estimated sales, number of active sellers,
  number of active listings, and average ticket — then writes a plain-language
  read on how attractive the category is to enter. Use it when a seller wants a
  one-shot market snapshot for a category they name. Triggers include: "is this
  category worth entering", "show the opportunity index for this category",
  "how big is this market", and the pt-BR equivalents "qual o índice de
  oportunidade", "vale a pena entrar nessa categoria", "tamanho de mercado da
  categoria". Sales and revenue are JoomPulse estimates, not real transactions.
  For ranking the sellers in a category, use the top-sellers-in-category skill; for
  trending search terms, use the top-keywords-in-my-category skill; for comparing
  category aggregates against a user-supplied previous snapshot, use the
  category-monitor skill.
---

# Category Opportunity Index

This skill answers a single question for **one** Mercado Livre (Brasil)
category: is it worth entering? Given a category named in free text, it reads
that category's **opportunity index** (low, medium, or high) and its current
monthly market indicators — estimated GMV, estimated sales, active sellers,
active listings, and average ticket — then writes a short pt-BR summary that
interprets the opportunity level together with how concentrated the market is
(monopolization) and which way it is growing.

This is a point-in-time snapshot, not a tracker. To rank the sellers inside a
category, use the top-sellers-in-category skill. For the trending search terms
shoppers use in a category, use the top-keywords-in-my-category skill. To compare
a category's aggregates against a user-supplied previous snapshot, use the
category-monitor skill. This skill answers "how attractive is this category right
now?" for a category the user names.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user names the category to evaluate (free text is fine).
- The available JoomPulse tools can resolve a category name to a category and
  return that category's current monthly market indicators plus its recent
  monthly history.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can report a category's opportunity index.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **Sales and revenue are JoomPulse estimates** derived from historical listing
  data — not real transactions. The seller, listing, and average-ticket counts
  shown here are estimates too. Disclose this in every output.
- **Read-only.** The skill never writes or modifies anything.
- **Language:** detect the seller's language and respond in it. Default to
  pt-BR.
- **Keep the workflow invisible.** The seller wants the answer, not a play-by-
  play. If one approach does not return data, switch to another quietly; only if
  every approach fails do you say one short, friendly sentence. Never fill gaps
  from general knowledge, and never fabricate a number — show `—` when a value
  is missing.

## Workflow

### Step 1 — Resolve the category

1. If the user did not name a category, ask which one to evaluate
   (for example *"Para qual categoria você quer o Índice de Oportunidade?"*).
2. Use JoomPulse to match the free text to a category, retrieving candidate
   categories with their name, depth level, and opportunity index for the
   current month.
3. Pick the best match. If several plausible categories come back, list the top
   candidates (name and level) and ask the user to choose — do not silently
   guess between unrelated categories. If nothing matches, say the category was
   not found and ask for a broader or rephrased term.

### Step 2 — Get the current monthly indicators

For the chosen category, use JoomPulse to obtain its **latest month's** market
indicators:

- Opportunity index (low / medium / high).
- Estimated monthly GMV and estimated monthly sales.
- Number of active sellers and number of active listings.
- Average ticket.
- Context for the summary: the monopolization level (the top seller's share of
  orders, expressed 0–100%), the month-over-month growth direction, and any
  seasonality signal.

All indicators are monthly values. Use the always-positive monthly totals for
market size, never a month-over-month delta — never label a change figure as a
total or as "revenue".

### Step 3 — Get ~12 months of history for the trend line

Use JoomPulse to retrieve the category's recent monthly history (estimated GMV
and estimated sales per month) for roughly the last 12 months. Order the months
oldest to newest. If fewer than about six months of history come back (a new or
sparse category), treat history as unavailable and skip the trend line — show
the cards only.

### Step 4 — Build the report (pt-BR)

1. Lead with the **opportunity index**, prominently: 🟢 alto / 🟡 médio / 🔴
   baixo (show `—` if it is missing), noting the category name and level.
2. Show the monthly indicators table (see Output).
3. Write a 2–4 sentence **resumo** that interprets the opportunity index
   together with monopolization and growth:
   - What the level means — high implies good room for new sellers; low implies
     little relative upside.
   - **Monopolization** — high concentration (roughly above half) means the
     market is dominated by a few sellers and is harder to break into; low means
     demand is spread out and more accessible.
   - **Growth** — rising means the category is expanding; falling means it is
     contracting.
   - Optionally note seasonality if relevant.
   - End on a practical takeaway: worth entering / enter with caution / not very
     attractive right now.
4. Add the mandatory disclaimer, and optionally the JoomPulse category dashboard
   link.

## Output

Respond in the seller's language, default pt-BR, with no commentary about how the
report was produced. The indicators table always renders as markdown so it shows
cleanly in any client.

**Opportunity badge** — a heading line, for example:

> **Índice de Oportunidade: ALTO** 🟢 (categoria: <nome>, nível L<level>)

**Monthly indicators table:**

| Indicador | Valor (mensal) |
|---|---|
| GMV Estimado (Mensal) | R$ … |
| Vendas Estimadas (Mensal) | … |
| Vendedores Ativos | … |
| Anúncios Ativos | … |
| Ticket Médio | R$ … |

Format money as `R$` with pt-BR conventions (comma decimal, dot thousands, for
example `R$ 1,2 mi`, `8.400`, `R$ 49,90`) and round large values sensibly. Empty
cells show `—`.

**Resumo** — the 2–4 sentence interpretation described in the workflow.

**Disclaimer (every report):**

> ⚠️ GMV, vendas, vendedores e anúncios são estimativas do JoomPulse com base no
> histórico de anúncios — não são transações reais. / GMV, sales, sellers, and
> listings are JoomPulse estimates based on historical listing data — not actual
> transactions.

Optionally add the JoomPulse category dashboard link.

## Visualization

When the client can render inline visuals, present the opportunity badge,
metric cards, and the appropriate charts; otherwise fall back to a markdown
table plus text cards. Never block on visuals — if the rich-visual path is
unavailable for any reason, render the markdown fallback. The monthly indicators
table always renders as markdown in the response text, on every surface, and the
⚠️ estimate disclaimer always stays in the text.

When inline visuals are available, present in one panel:

- **Opportunity badge** at the top: Alta 🟢 / Média 🟡 / Baixa 🔴 (show `—` if
  missing).
- **Five metric cards:** estimated monthly GMV, estimated monthly sales, active
  sellers, active listings, and average ticket — pt-BR formatted, money with
  `R$`. These match the five rows of the monthly indicators table.
- **12-month trend line** of estimated monthly GMV (one point per month, x = mês,
  y = GMV; optionally a second series for estimated sales). Render this chart
  only when the data supports it — skip it entirely when there are fewer than
  about six months of history, leaving just the cards. Optionally add a small
  growth-% chip from the month-over-month change.
- **Monopolization bar:** a 0–100% horizontal bar; note that a **low** value is
  the favorable end (demand spread across many sellers).
- **Seasonality chip:** a pill only, no bar — "Não sazonal" when the category is
  not seasonal, or "Sazonal · pico {mês}" naming the peak month.

Presentation rules: use the medal palette consistently if medals appear anywhere
(platina = purple, ouro = amber, prata = blue, sem medalha = white with a thin
border). Any change or difference column uses a word as its header ("Variação",
or "Era | Agora"), never a bare "Δ" symbol. Show a 🟢/🔴/🆕 legend only on a run
where those symbols actually appear — never on a first or baseline run. Render a
chart only when the underlying data supports it, and skip it otherwise.

On a text-only surface, render the same information as markdown and text: the
badge as a heading line, the five metrics as the indicators table or text cards,
the trend as one short line describing the ~12-month direction (only when there
are at least about six months of history), the monopolization as a text
percentage (for example `Monopolização: 38% (baixa — bom)`), and the seasonality
as a text chip line.

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **Ambiguous category:** list the candidate categories and ask the user to
  choose. Do not guess between unrelated categories.
- **No current data / empty result:** say you could not find current data for
  that category and suggest a broader or different term. Never fabricate numbers.
- **Opportunity index missing:** show `—` for the badge and base the summary on
  monopolization and growth instead.
- **Sparse history:** when fewer than about six months of history exist, omit the
  trend line and report the snapshot only.
- **Market data temporarily unavailable:** retry once quietly; if it is still
  down, say market data is temporarily unavailable and to try again. Never paste
  internal error text, HTTP codes, or field names to the seller.
- **Missing values:** show `—` for any empty indicator rather than guessing.
