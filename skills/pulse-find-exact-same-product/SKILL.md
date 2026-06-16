---
name: pulse-find-exact-same-product
description: >
  Finds product listings that appear to represent the same real-world product as a
  reference item. Use this skill when a user wants to find duplicate listings,
  match a product across listings, identify identical products by title or URL,
  compare product photos against marketplace listings, or find the same product
  on Mercado Livre.
---

# Find Exact Same Product

This skill helps find listings that appear to represent the same real-world
product as a reference product.

"The same product" means the candidate listing matches the reference item's
identity: brand, model, variant, color, size, capacity, pack count, bundle
contents, and other defining attributes visible from the provided product data.
Formatting, casing, punctuation, and translation differences are acceptable when
the underlying product is clearly the same.

## Prerequisites

- JoomPulse MCP access is configured for the current agent environment.
- The user provides a product title, product URL, product identifier, or product
  image.
- The available JoomPulse tools can search marketplace listings and return
  enough product data to compare candidates.

If JoomPulse MCP access is unavailable, stop and explain that the skill requires
JoomPulse MCP setup before it can search or compare products.

## Workflow

1. Resolve the reference product.
   - If the user provides a title, use it directly as the reference.
   - If the user provides a product URL or identifier, fetch the available
     product details first.
   - If the user provides an image, use the available image-based product search
     workflow to generate candidate listings.

2. Search for candidate listings.
   - Use JoomPulse product search tools to find plausible candidates.
   - Treat search results as candidate generation, not final truth.
   - Prefer a compact candidate set first, then broaden only when recall is
     clearly too low.

3. Enrich candidates.
   - Fetch product attributes, title, seller/listing metadata, images, and links
     when available.
   - Keep enough source data to explain why a candidate was accepted or rejected.

4. Decide exact matches.
   - Accept a candidate only when the defining attributes match the reference.
   - Reject candidates when brand, model, size, color, capacity, pack count,
     bundle contents, or other defining attributes differ.
   - If data is insufficient for a confident match, do not mark it as exact.
   - Do not rely on title similarity alone when important attributes are missing
     or ambiguous.

5. Return results.
   - List confirmed matches with product links when available.
   - Include a short rationale for each accepted match.
   - If there are no confident matches, say so clearly and summarize what was
     checked.
   - When useful, include rejected near-matches separately with the key reason
     they were rejected.

## Output Format

Use a concise table when there are multiple candidates:

| Result | Product | Link | Why it matches |
| --- | --- | --- | --- |
| Match | Product title | Product URL | Same brand, model, size, and variant |

For a single match, a short paragraph with the product link and rationale is
enough.

## Notes

- Prefer precision over recall. A smaller list of confident matches is better
  than a broad list of uncertain candidates.
- Do not expose raw private data, internal identifiers, or implementation
  details in the final answer.
- If the user asks for bulk matching, process items one by one and make
  uncertainty explicit for each item.
