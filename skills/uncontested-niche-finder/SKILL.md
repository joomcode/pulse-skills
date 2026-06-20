---
name: uncontested-niche-finder
description: >
  Finds low-competition niche products on Mercado Livre (Brasil) — active
  listings in deep sub-categories (deeper than the third level) of a chosen
  category that have no platinum sellers, surfaced via JoomPulse. Use it when a
  seller wants uncontested niches, gaps without strong incumbents, or to know
  where they can enter without fighting a dominant platinum seller. Triggers in
  English include: "uncontested niche", "low-competition products", "categories
  without platinum sellers", "find a niche to enter". Triggers in pt-BR include:
  "nicho sem concorrência", "produtos sem vendedor platinum", "nicho pouco
  disputado", "onde entrar sem briga", "subcategorias sem platinum". It returns
  one table of niche products, each with a competition signal (number of sellers)
  and a JoomPulse link. Sales and revenue are JoomPulse estimates, not real
  transactions; price, rating, and reviews are real history. For whole-assortment
  expansion, use the gap-analysis skill; for one product and its competitors, use
  the single-product analysis skill; for fast-growing deep categories rather than
  products, use the growing-leaf-category skill.
---

# Uncontested Niche Finder

This skill finds products in **deep sub-categories** of a chosen Mercado Livre
(Brasil) category — sub-categories deeper than the third level — that have **no
platinum sellers** among their listings. These are low-competition niches a
seller can enter without fighting a dominant incumbent. Given a category by name
or identifier, it surfaces the active listings in those deep niches, drops any
listing held by a platinum seller, and ranks what remains by estimated traction
so the strongest uncontested opportunities surface first.

This is different from broad assortment work. To decide which new products to add
across a whole catalog, use the gap-analysis skill. To size up one product and
the products that compete with it, use the single-product analysis skill. To find
the fast-growing deep **categories** under a category (rather than the products
inside them), use the growing-leaf-category skill. This skill answers "where can
I enter without facing a platinum seller?" for a category the seller names.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user provides one category, as a name or a category identifier.
- The available JoomPulse tools can resolve a category, walk its deep
  sub-categories, and list the active product listings within them.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can find uncontested niches.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **Sales and revenue are JoomPulse estimates** derived from historical listing
  data — not real transactions. Disclose this in every output. By contrast,
  **price, rating, and review count are real Mercado Livre history** — say so, it
  is a strength of the report.
- **Read-only.** The skill does not sign in as the seller or modify any listing.
- **Language:** detect the seller's language and respond in it. Default to pt-BR.
- **Keep the workflow invisible.** The seller wants the niches, not a play-by-
  play. If one approach does not return data, switch to another quietly; only if
  every approach fails do you say one short, friendly sentence. Never fill gaps
  from general knowledge.

## Workflow

### Step 1 — Resolve the category and find its deep sub-levels

1. **Ask the user for a category** (a name or a category identifier). If given a
   name, use JoomPulse to resolve it to a category, matching on the category
   name. If several categories match, briefly list the candidates (name and
   level) and ask which one is meant.
2. **Find every sub-category deeper than the third level** that sits under the
   chosen category. Use JoomPulse to walk down the category tree from the chosen
   branch and collect the descendant categories below the third level. Keep that
   set of deep category identifiers for the next step.
3. If the chosen category is itself at or above the third level and has no
   descendants below it, tell the user there are no deep sub-levels for it and
   offer to run on a broader category.

### Step 2 — Pull the niche listings and exclude platinum sellers

1. Use JoomPulse to list the **active product listings** in those deep
   sub-categories. For each listing collect: name, category, seller, listing
   type, seller medal, logistics (frete grátis), price, estimated **weekly**
   sales and revenue, rating, review count, time on air, and — where available —
   how many sellers compete on the listing.
2. **Drop every listing held by a platinum seller.** Keep listings whose seller
   medal is gold, silver, none, or empty — these are the uncontested niches.
3. Keep the listings that are real, funded niches — those with estimated sales
   above zero — and rank them so the strongest uncontested opportunities lead
   (by estimated weekly revenue by default). If nothing has estimated sales, fall
   back to listing the active non-platinum listings and say so.
4. If the deep sub-categories exist but every listing in them is held by a
   platinum seller, report that the niche is already contested by platinum
   sellers and suggest a sibling category.

## Output

Respond in the seller's language. Present the result with no commentary about how
it was produced. The product table always renders as markdown so it reads
cleanly in any client.

**Niche table** — one row per uncontested niche product, with these columns:

- Product / listing identifier (rendered as a JoomPulse link for the product)
- Name
- Category
- Seller
- Price
- Estimated sales (weekly)
- Estimated revenue (weekly)
- **Number of sellers** — the competition signal, so "uncontested" is legible
  (show `—` when it is not available)
- Rating
- Reviews
- Time on air
- Free shipping (frete grátis)
- Listing type
- Seller medal — gold, silver, or no medal (never platinum; platinum listings
  are excluded in Step 2)
- A JoomPulse link for the product

Put the JoomPulse link on the product identifier in each row. When a cell is
empty, show `—` rather than guessing. Below the table, briefly state what
"uncontested niche" means here: sub-categories deeper than the third level, with
**no platinum seller** among the listed products. You may translate the column
headers into the seller's language.

**Disclaimer (every report):**

> ⚠️ Sales and revenue are JoomPulse **estimates** based on historical listing
> data — they are **not** actual transactions. Price, rating, and reviews are
> real Mercado Livre history. / Vendas e receita são **estimativas** do JoomPulse
> com base no histórico de anúncios — **não são transações reais**. Preço,
> classificação e avaliações são histórico real do Mercado Livre.

## Visualization

When the client can render inline visuals, present metric cards and, when the
data supports it, the appropriate chart; otherwise present a short text version
of the cards. **The product table always renders as markdown** — never inside a
widget — so the competition signal stays legible. Render a chart only when the
data supports it, and skip it otherwise.

**Cards** — three summary cards:

- **Produtos encontrados** — the count of uncontested niche rows in the table
  (non-platinum, in deep sub-categories).
- **Subnichos cobertos** — the count of distinct deep sub-categories actually
  represented in the results.
- **Ticket médio** — the average price across the listed rows, in pt-BR currency
  formatting (for example `R$ 1.234`).

**Chart** — a horizontal bar of the top niche products by estimated weekly
revenue, strongest uncontested niches first, each bar labelled with a short
product name. **Skip the bar entirely when there are fewer than four products** —
show only the cards and the table.

Apply the standard medal palette wherever a seller medal is shown: platina =
purple, ouro = amber, prata = blue, sem medalha = white with a thin border. (In
this skill platinum listings are excluded, so platina should not appear.) When a
change or difference column is present, its header is a word (for example
"Variação" or an "Era | Agora" pair), never a bare delta symbol. Show a
🟢/🔴/🆕 legend only on a run where those symbols actually appear.

**Otherwise (no inline visuals)**: render the three cards as a short text block,
one line each, and — only when there are four or more products — a tiny text list
of the top niches by estimated weekly revenue. **Never block on visuals**; if
inline rendering is unavailable or fails, fall straight through to the markdown
output. Round numbers and use pt-BR formatting (for example `R$ 1.234`, `1.234
vendas`).

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **No deep sub-categories:** if the chosen category has no sub-levels deeper
  than the third level, say so and offer to run on a broader category.
- **All listings are platinum:** if every listing in the deep sub-categories is
  held by a platinum seller, report that the niche is already contested by
  platinum sellers and suggest a sibling category.
- **No funded listings:** if no listing has estimated sales, list the active
  non-platinum listings instead and say the niche has little measured traction.
- **Unknown flags:** when a logistics flag such as frete grátis is unknown, show
  it as unknown — do not assume "no".
- **Many deep sub-categories:** when the deep category set is large, gather the
  listings in batches and merge the results before ranking.
- **Market data temporarily unavailable:** retry once quietly; if it is still
  down, say market data is temporarily unavailable. Never paste internal error
  text, HTTP codes, or field names to the seller.
- **Never silently limit coverage** — if you cover only some of the deep
  sub-categories, say so.
