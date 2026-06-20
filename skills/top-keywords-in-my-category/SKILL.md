---
name: top-keywords-in-my-category
description: >
  Lists the top trending search keywords for one Mercado Livre (Brasil) category
  — the real Mercado Livre search-trends ranking of what shoppers look for — with
  each keyword's rank and how many products compete for it. Use it when a seller
  wants to know what people search in their niche, which terms to put in titles
  and ads, or where demand is concentrated. Triggers include: "top keywords in my
  category", "trending search terms", "what do people search for", "best keywords
  for my listings", and the pt-BR equivalents "palavras-chave mais buscadas",
  "termos em alta na categoria", "o que as pessoas pesquisam", "melhores
  palavras-chave para meus anúncios". The keywords and ranks are real search-trend
  data, not estimates. For category market size and opportunity, use the
  opportunity-index skill; for ranking the sellers in a category, use the
  top-sellers skill.
---

# Top Keywords In My Category

This skill returns the **top trending search keywords** for one Mercado Livre
(Brasil) category — the ranked list of terms shoppers are actually searching,
each with its position and how many products already compete for it. It tells a
seller what to put in titles and ads and where demand is concentrated.

Unlike most JoomPulse skills, the data here is **real search-trend data, not an
estimate**. For a category's market size and opportunity index, use the
opportunity-index skill. For the sellers ranked inside a category, use the
top-sellers skill.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user names a category (free text is fine).
- The available JoomPulse tools can resolve a category and return its trending
  search keywords with each keyword's rank and competing-product count.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can list a category's keywords.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **Real data, not an estimate.** The keywords, ranks, and competing-product
  counts come from Mercado Livre search trends — say so; do not add the sales
  estimate disclaimer that other skills use.
- **Read-only.** The skill never writes or modifies anything.
- **Language:** detect the seller's language and respond in it. Default to pt-BR.
- **Keep the workflow invisible.** Show `—` for any missing value; never fabricate.

## Workflow

### Step 1 — Resolve the category

Ask for a category if none was given, then use JoomPulse to match the free text to
a category, disambiguating with the seller when several plausible matches return.

### Step 2 — Get the trending keywords

Use JoomPulse to retrieve the category's trending search keywords, each with its
rank and its competing-product count. Sort by rank, best position first.

## Output

Respond in the seller's language (default pt-BR). The keywords always render as a
markdown table, sorted by position:

| Posição | Palavra-chave | Produtos (oferta) |
|--:|---|--:|

- **Posição** — the keyword's rank in the category's search trends.
- **Produtos (oferta)** — how many products compete for that keyword.

Close with a short, optional takeaway (use the top terms in titles and ads; a high
competing-product count means a crowded term, a low one a more open opportunity).

This is **real Mercado Livre search-trend data, not an estimate** — state that
once, in place of the estimate disclaimer.

## Visualization

When the client can render inline visuals, present metric cards and a chart;
otherwise fall back to the markdown table plus text cards. Never block on visuals.
The keywords table always renders as markdown, on every surface.

When inline visuals are available:

- **Three cards:** number of keywords, the number-one term, and the least-disputed
  term (the one with the fewest competing products among the top).
- **A horizontal bar** of the top ~15 keywords (in rank order) showing the
  competing-product count per term, so the most-searched terms and how crowded
  each is are visible at a glance. Optionally flag low-competition (opportunity)
  terms. Render the chart only when there are enough keywords (skip under about
  five).

Presentation rules: render a chart only when the data supports it; any column with
movement uses a word header, never a bare "Δ".

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **No keywords for the category:** say plainly that no trending terms were found
  and suggest a broader or adjacent category.
- **Data temporarily unavailable:** retry once quietly; if it is still down, say
  the data is temporarily unavailable and to try again. Never paste internal error
  text, HTTP codes, or field names to the seller.
