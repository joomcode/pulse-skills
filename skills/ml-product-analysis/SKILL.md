---
name: ml-product-analysis
description: >
  Analyzes one Mercado Livre product and its competitors. Use this skill when a
  user wants to size up a single product or the products that compete with it —
  by a Mercado Livre link, a JoomPulse link, a photo, or a row of data. It
  returns a product card for the subject plus a ranked table of comparable
  products, each with price, estimated monthly sales and revenue, logistics, and
  catalog / buy-box status. Triggers include: "analyze this product", "how much
  does this sell", "find similar products", "find competing products", and the
  pt-BR equivalents "analisar este produto", "quanto vende esse produto",
  "produtos parecidos", "produtos concorrentes", "análise por foto", "análise por
  link". For "what new products should I add to my store" across a whole catalog,
  use the assortment gap-analysis skill instead — this skill analyzes a single
  product the seller already has in hand.
---

# Mercado Livre Single-Product Analysis

This skill analyzes **one** Mercado Livre (Brasil) product and the products that
compete with it. Given a single product — by a Mercado Livre link, a JoomPulse
link, a photo, or a row of data — it identifies the product, finds comparable
listings, and returns a product card for the subject plus a ranked table of
analogs. For each product it shows price, estimated monthly sales and revenue,
logistics, and catalog / buy-box status.

This is different from whole-catalog assortment analysis. If the user wants to
know which new products to add to their store, hand off to the gap-analysis
skill. This skill works on a single product the seller already has in hand.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user provides one product as a Mercado Livre link, a JoomPulse link, a
  product photo, or a row of data (a `.csv` / `.xlsx` file, a pasted table, or
  typed fields).
- The available JoomPulse tools can look up product market data and search for
  comparable listings.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can analyze a product or find competitors.

## Scope

- **Mercado Livre (Brasil) only.** Other marketplaces are out of scope.
- **Sales and revenue are JoomPulse estimates** derived from historical listing
  data — not real transactions. Disclose this in every output.
- **Prices are Mercado Livre prices only.** Do not surface sourcing prices,
  margins, or profit figures.
- **Read-only.** The skill does not sign in as the seller or modify any listing.
- **Language:** detect the seller's language and respond in it. Default to
  pt-BR.
- **Keep the workflow invisible.** The seller wants the answer, not a play-by-
  play. Do the analysis quietly and present only the result. If one approach to
  finding the product or its competitors does not work, switch to another
  silently; only if every approach fails do you say one short, friendly sentence.

## Input Router

Resolve the input to a single normalized subject product, then find analogs. The
first matching rule wins:

1. **A photo** → Photo route.
2. **A `.csv` / `.xlsx` file, a pasted table, or typed fields** → Tabular route.
3. **A Mercado Livre link** → MLB route.
4. **A JoomPulse product link** → JoomPulse route.
5. **A JoomPulse store link** → this is a whole store, not one product. Ask for a
   specific product link or a product title; whole-store analysis belongs to the
   gap-analysis skill.
6. **Any other link** (a different marketplace, a generic web page) → do not
   scrape it. Explain that only Mercado Livre and JoomPulse links can be resolved
   directly, and ask the seller to paste the product name or upload a photo →
   Keyword route.
7. **Plain text** (a product name or keywords) → Keyword route.

Every route converges on one normalized subject product plus a set of candidate
analogs.

### MLB route

1. Extract the product identifier from the link, noting whether it is a catalog
   product or an individual listing.
2. Look up the canonical title, category, and attributes for that identifier
   when available. If the lookup is unavailable for that listing, continue with
   the JoomPulse market data instead.
3. Fetch JoomPulse market data for the subject. For a catalog product, several
   competing listings may come back; pick the representative one (the strongest
   seller / buy-box winner) for the card and read competition from the number of
   buy-box sellers and total sellers.
4. Build the subject from that data, then find analogs.

### JoomPulse route

Look up the product directly in JoomPulse by its identifier, optionally enriching
the title and attributes from the canonical product lookup, then find analogs.

### Photo route

Image-based matching is primary; visual inspection is the fallback. Always tell
the seller the results are **visually similar — not a guaranteed exact match.**

1. Use the available JoomPulse image-based product search to find similar
   listings from the photo.
2. If image search is unavailable or returns nothing, inspect the photo yourself:
   note the product type, brand and model if legible, color, material, and key
   attributes. Turn that into search keywords and run the Keyword route. Label
   the subject card as the best visual match, not an exact match.

### Tabular route

Normalize the rows into product records (handle pt-BR column headers and
`R$ 1.234,56`-style prices). For each row: if it carries a Mercado Livre
identifier, use the MLB route; otherwise its title drives the Keyword route. One
row yields one subject. For several rows, analyze each — cap at a small number
and say so when you do.

### Keyword route

Build a clean search query from the title or photo description, plus a broadened
fallback query.

## Finding Analogs

Both the keyword and photo paths feed the same analog pipeline:

1. **Search for candidates.** Use JoomPulse semantic product search to find
   listings similar to the subject, keeping the closest matches. Query in pt-BR
   first and English second. If recall is too low, retry once with the broadened
   query. For the photo route, the image-search results play this role.
2. **Augment when recall is thin.** Optionally widen the candidate set using
   category and keyword search, or constrain to the subject's predicted category.
3. **Merge and drop the subject.** Deduplicate the candidate identifiers and
   remove the subject itself.
4. **Validate and fetch market data.** Look up the candidates in JoomPulse to
   confirm they are active listings and to fetch price, sales, revenue,
   logistics, and catalog / buy-box fields.
5. **Rank.** Score each candidate by a blend of similarity to the subject,
   demand (estimated revenue), and how crowded the listing is, then sort by that
   score. Drop candidates with no sales. Present a single ranked list — do not
   split analogs into thematic sub-tables.

## Output

Respond in the seller's language. The visible reply contains only the result, in
this order, with no commentary about how it was produced:

1. An optional one-line framing sentence.
2. The subject product card.
3. The ranked analogs table.
4. The disclaimer.
5. The download offer.

Use plain markdown so it renders cleanly in any client.

**Subject card** — product name and image, category and brand, current price and
historic minimum price, estimated monthly sales and revenue, logistics (Mercado
Envios Full / free shipping / international), catalog / buy-box status (whether it
is in the catalog, the number of buy-box sellers and the buy-box price, and the
total number of sellers), and links to the product on Mercado Livre and on
JoomPulse. On the photo route, label the card as the best visual match, not an
exact match.

**Analogs table** — one row per comparable product, each with links to Mercado
Livre and JoomPulse, the product name, price (current and historic minimum),
estimated monthly sales and revenue, logistics, and catalog / buy-box status.
Keep both the Mercado Livre link and the JoomPulse link for every product. You
may translate the column headers and card labels into the seller's language.

**Disclaimer (every report):**

> ⚠️ Sales and revenue are JoomPulse **estimates** based on historical listing
> data — they are **not** actual transactions. / Vendas e receita são
> **estimativas** do JoomPulse com base no histórico de anúncios — **não são
> transações reais**.

**Download** — offer a downloadable spreadsheet (`.xlsx` plus `.csv`) of the
subject and analogs, with separate Mercado Livre and JoomPulse link columns so
the seller can see the source of every product's data.

## Notes & Guardrails

The seller should never see a system or stack error — only a friendly next step.

- **Subject not tracked in JoomPulse / no sales:** JoomPulse tracks products that
  have sales, so a product may not be tracked. Say so, show whatever canonical
  product facts are available, and still surface analogs by category or keywords.
- **Valid product, no market data:** show the canonical product facts and note
  that there is no JoomPulse estimate; draw analogs from the predicted category.
- **Photo:** image search first; if it is unavailable or empty, switch silently
  to visual inspection plus keywords. Always label results as similar, not exact;
  if the match is ambiguous, show the top candidates and ask the seller to
  confirm.
- **Search returns nothing:** an empty result for a niche or non-pt-BR query is
  normal — retry once with an English or broadened query, then move on. If search
  is temporarily unavailable, say so briefly and rely on the other data.
- **Market data temporarily unavailable:** retry once quietly; if it is still
  down, say market data is temporarily unavailable. Never paste internal error
  text, HTTP codes, or field names to the seller.
- **Never silently limit coverage** — if you analyze only some rows or some
  candidates, say so.
- **Prefer precision over recall.** A shorter list of confident analogs is better
  than a long list of weak ones.
