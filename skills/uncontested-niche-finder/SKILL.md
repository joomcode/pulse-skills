---
name: uncontested-niche-finder
description: >
  Finds low-competition niche products on Mercado Livre (Brasil) — active listings in deep
  sub-categories (deeper than the third level) of a chosen category that have no platinum
  seller at all, surfaced via JoomPulse. Use it when a seller wants uncontested niches, gaps
  without strong incumbents, or where to enter without fighting a dominant platinum seller.
  Triggers (EN): "uncontested niche", "low-competition products", "categories without platinum
  sellers", "find a niche to enter"; (pt-BR): "nicho sem concorrência", "produtos sem vendedor
  platinum", "nicho pouco disputado", "subcategorias sem platinum". It returns one table of
  niche products, each with a competition signal (number of sellers) and a JoomPulse link.
  Sales and revenue are JoomPulse estimates, not real transactions; price, rating, and reviews
  are real history. For one product and its competitors use the ml-product-analysis skill; for
  fast-growing deep categories rather than products use the growing-leaf-category-tracker
  skill.
---

# Uncontested Niche Finder

This skill finds products in **deep sub-categories** of a chosen Mercado Livre
(Brasil) category — sub-categories deeper than the third level — that have **no
platinum seller at all** among their listings. These are genuinely
platinum-free niches a seller can enter without fighting a dominant incumbent.
Given a category by name or identifier, it surfaces the active listings in those
deep niches, and ranks them by estimated traction so the strongest uncontested
opportunities surface first.

A truly uncontested niche is a **whole deep sub-category with zero platinum
sellers** — not merely the non-platinum listings inside a sub-category that
still has platinum sellers elsewhere. Dropping individual platinum-held listings
is not enough: if any platinum seller is active in the sub-category, that niche
is contested, so the skill keeps only the deep sub-categories that have no
platinum seller present. If keeping only platinum-free sub-categories would leave
too few results, the skill may also show non-platinum listings from sub-
categories that still have platinum sellers — but it labels those plainly as
**non-platinum listings (platinum sellers still present in the category)** and
does not call them uncontested.

This is different from broad assortment work. To size up one product and the
products that compete with it, use the ml-product-analysis skill. To find the
fast-growing deep **categories** under a category (rather than the products inside
them), use the growing-leaf-category-tracker skill. This skill answers "where can
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

### Step 2 — Keep only the platinum-free deep sub-categories

1. Use JoomPulse to list the **active product listings** in those deep
   sub-categories. For each listing collect: name, category, seller, listing
   type, seller medal, logistics (frete grátis), price, estimated **weekly**
   sales and revenue, rating, review count, time on air, and — where available —
   how many sellers compete on the listing.
2. **Decide which deep sub-categories are genuinely uncontested.** A deep sub-
   category is uncontested only when it has **no platinum seller at all** among
   its listings. Group the listings by their deep sub-category, check each group
   for any platinum seller, and **keep only the sub-categories with zero platinum
   sellers.** Do not merely drop the platinum-held listings from a sub-category
   that still has platinum sellers — that sub-category is contested and its other
   listings are not uncontested.
3. From the platinum-free sub-categories, keep the listings that are real, funded
   niches — those with estimated sales above zero — and rank them so the
   strongest uncontested opportunities lead (by estimated weekly revenue by
   default). If nothing has estimated sales, fall back to listing the active
   listings in the platinum-free sub-categories and say so. These are the
   **uncontested niches.**
4. **If keeping only platinum-free sub-categories leaves too few results**, you
   may additionally include the non-platinum listings from sub-categories that
   still have platinum sellers — but present them in a clearly separate, labelled
   group, **"non-platinum listings (platinum sellers still present in the
   category)"**, and do **not** call them uncontested. Always lead with the
   genuinely platinum-free niches.
5. If every deep sub-category has at least one platinum seller (none are
   platinum-free), report that the deep sub-categories are already contested by
   platinum sellers, suggest a sibling category, and — if helpful — offer the
   non-platinum listings under the labelled non-uncontested group described
   above.

## Output

Respond in the seller's language. Present the result with no commentary about how
it was produced. The product table always renders as markdown so it reads
cleanly in any client.

**Niche table** — one row per uncontested niche product (from the platinum-free
deep sub-categories), with these columns:

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
- Seller medal — gold, silver, or no medal (never platinum; uncontested rows
  come only from platinum-free sub-categories per Step 2)
- A JoomPulse link for the product

Put the JoomPulse link on the product identifier in each row. When a cell is
empty, show `—` rather than guessing. Below the table, briefly state what
"uncontested niche" means here: sub-categories deeper than the third level that
have **no platinum seller at all** among their listings. You may translate the
column headers into the seller's language.

**If you also include the fallback group** (non-platinum listings from sub-
categories that still have platinum sellers, used only when the platinum-free set
is too small), put it in a clearly separate, labelled section titled
**"non-platinum listings (platinum sellers still present in the category)"**.
Use the same columns, but do **not** call these rows uncontested — be explicit
that platinum sellers are still active in those sub-categories.

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
- **No platinum-free sub-categories:** if every deep sub-category has at least
  one platinum seller, report that the deep sub-categories are already contested
  by platinum sellers and suggest a sibling category. You may still offer the
  non-platinum listings, but only under the labelled "non-platinum listings
  (platinum sellers still present in the category)" group — never as uncontested.
- **Too few platinum-free niches:** if the genuinely platinum-free sub-categories
  yield too few results, you may add the non-platinum listings from sub-
  categories that still have platinum sellers, in the separate labelled group
  above — always lead with the platinum-free niches and never relabel the
  fallback group as uncontested.
- **No funded listings:** if no listing has estimated sales, list the active
  listings in the platinum-free sub-categories instead and say the niche has
  little measured traction.
- **Unknown flags:** when a logistics flag such as frete grátis is unknown, show
  it as unknown — do not assume "no".
- **Many deep sub-categories:** when the deep category set is large, gather the
  listings in batches and merge the results before ranking.
- **Market data temporarily unavailable:** retry once quietly; if it is still
  down, say market data is temporarily unavailable. Never paste internal error
  text, HTTP codes, or field names to the seller.
- **Never silently limit coverage** — if you cover only some of the deep
  sub-categories, say so.
