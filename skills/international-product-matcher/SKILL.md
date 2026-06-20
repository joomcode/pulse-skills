---
name: international-product-matcher
description: >
  Finds fast-growing international (imported) products inside a Mercado Livre
  (Brasil) category and matches each one to a JoomPro product so the seller can
  source and import it. Every row gets an import action plus a JoomPro link and a
  JoomPulse link, alongside price, estimated weekly sales and revenue, rating,
  reviews, time on air, shipping, listing type and seller medal. Use it when a
  seller wants imported winners in a category AND a concrete way to buy them on
  JoomPro. Triggers include: "find international products and match them to
  JoomPro", "imported winners I can source", "match these to JoomPro with an
  import button", and the pt-BR equivalents "produtos internacionais para importar
  na JoomPro", "achar internacionais e casar com a JoomPro", "produtos importados
  com botão importar". Sales and revenue are JoomPulse estimates, not real
  transactions. For international products with only a general JoomPro link, use
  the single-category international skill; for an all-categories sweep, use the
  all-categories international skill.
---

# International Product Matcher

This skill takes one Mercado Livre (Brasil) category, finds the **fast-growing
international (imported) products** in it, and **matches each to a JoomPro
product** so the seller can source and import it. It is the action-oriented
member of the international trio: every item gets an import action and a JoomPro
link, not just market data.

For international products with only a general JoomPro search link, use the
single-category international skill. For a marketwide sweep across all categories,
use the all-categories international skill.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user names a category (free text is fine).
- The available JoomPulse tools can return active international listings in a
  category with their market data; JoomPro is searched separately, by product
  title, for the matching source item.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can find and match international products.

## Scope

- **Mercado Livre (Brasil) only** for the marketplace side; JoomPro for sourcing.
- **Sales and revenue are JoomPulse estimates** derived from historical listing
  data — not real transactions. Price, rating, and reviews are real history.
  Disclose the estimate caveat in every output.
- **Read-only.** The skill never writes or modifies anything; the import action is
  just a link the seller can open.
- **Language:** detect the seller's language and respond in it. Default to pt-BR.
- **Keep the workflow invisible.** Show `—` for any missing value; never fabricate.

## Workflow

### Step 1 — Resolve the category

Ask for a category if none was given, then use JoomPulse to match the free text to
a category, disambiguating with the seller when needed.

### Step 2 — Find fast-growing international products

Use JoomPulse to get the active **international (imported)** listings in the
category and keep the fast-growing shortlist, **stating the rule you used**
(for example, recent items with strong estimated weekly sales, or the top items
by estimated weekly revenue).

### Step 3 — Match each to JoomPro

For each shortlisted item, search JoomPro by the product title to find the
matching source product, and build a per-item JoomPro link. When no confident
match is found, fall back to a general JoomPro search link — never invent a
specific product reference.

## Output

Respond in the seller's language (default pt-BR). This skill is action-oriented:
there is **no chart**. The deliverable is a markdown product table:

| MLB | Nome | Vendedor | Preço | Vendas (semana) | Receita (semana) | Classificação | Avaliações | Tempo no ar | Frete grátis | Mercado Envios Full | Tipo de anúncio | Medalha | Importar | JoomPro |
|---|---|---|--:|--:|--:|--:|--:|--:|:--:|:--:|---|---|:--:|:--:|

- **MLB** links to the item's JoomPulse page.
- **Importar** is the per-item JoomPro link (the source product), or a general
  JoomPro search link when no confident match exists.
- **JoomPro** repeats the JoomPro link for clarity.

**Disclaimer (every report):**

> ⚠️ Vendas e receita são estimativas do JoomPulse com base no histórico de
> anúncios — não são transações reais. Preço, classificação e avaliações são
> histórico real do Mercado Livre.

## Visualization

This skill's value is the matched list and the import action, so it does **not**
render a chart — a chart here would be filler. When the client can render inline
visuals, you may show three summary cards (number of products matched to JoomPro,
total estimated weekly sales, average ticket) above the table; otherwise show the
same as text. The product table always renders as markdown, on every surface, and
the ⚠️ disclaimer always stays in the text.

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **No JoomPro match for an item:** show `—` for the source product and offer a
  general JoomPro search link; never fabricate a specific product reference.
- **Few international items:** if the category has thin imported supply, say so
  honestly rather than padding the list.
- **Market data temporarily unavailable:** retry once quietly; if it is still
  down, say market data is temporarily unavailable and to try again. Never paste
  internal error text, HTTP codes, or field names to the seller.
