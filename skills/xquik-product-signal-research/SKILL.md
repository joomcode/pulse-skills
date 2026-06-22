---
name: xquik-product-signal-research
description: >
  Adds public X signal research to JoomPulse product decisions. Use this skill
  when a Mercado Livre seller wants to understand public demand, complaints,
  language, creators, competitor mentions, or trend context around a product,
  brand, category, or product idea. It combines JoomPulse product context with
  Xquik public X search, user search, trends, monitors, or extraction workflows.
  Triggers include: "what are people saying on X", "check social demand", "find
  product complaints on Twitter", "public sentiment for this product", and the
  pt-BR equivalents "o que falam no X", "demanda nas redes", "reclamações no
  Twitter", "sinais sociais do produto". For price, seller, logistics, catalog,
  buy-box, sales, or revenue analysis, use the JoomPulse product skills first.
---

# Xquik Product Signal Research

This skill adds **public X signal research** to JoomPulse product workflows. It
helps a Mercado Livre seller understand what public X posts and trends suggest
about demand, complaints, language, creators, competitor mentions, and timing for
a product, brand, category, or product idea.

Use this skill after the product has enough JoomPulse context to produce focused
queries: product name, brand, category, known competitors, seller language, and
the market question. Do not use it as a replacement for JoomPulse market data.
It is a social-signal layer that helps explain what people publicly discuss.

## Prerequisites

- JoomPulse MCP access is configured for product context.
- Xquik API access is configured in the current agent environment.
- The user provides a Mercado Livre product, JoomPulse product, brand, category,
  competitor, or product idea.

If JoomPulse MCP access is unavailable, ask for a product, brand, or category
that can be searched directly. If Xquik API access is unavailable, stop and say
that public X signal research needs Xquik API setup before it can run.

Use only public X data returned by the documented Xquik API or MCP server:

- `GET /api/v1/x/tweets/search`
- `GET /api/v1/x/users/search`
- `GET /api/v1/x/trends`
- `GET /api/v1/trends`
- `POST /api/v1/extractions`
- `POST /api/v1/monitors/keywords`

Docs: https://docs.xquik.com and https://docs.xquik.com/mcp/overview

## Scope

- **Public X only.** Do not try to access private messages, protected accounts,
  seller admin data, customer records, or any non-public source.
- **Read-only by default.** Do not like, follow, retweet, post, message, or
  change any account.
- **Signals, not proof.** Public posts can be noisy, promotional, duplicated, or
  unrepresentative. Present them as qualitative signals, not market share.
- **Language:** detect the seller's language and respond in it. Default to
  pt-BR for Mercado Livre Brasil.
- **Keep user keys out of the answer.** Never print API keys, account settings,
  request headers, or environment names.

## Workflow

### Step 1 - Build the product context

Use JoomPulse first when the user provides a product link or identifier:

1. Resolve the product, brand, category, and competitor set.
2. Identify the seller's language and the likely buyer language.
3. Convert product context into search terms:
   - exact brand and model names;
   - common misspellings and abbreviations;
   - category terms in Portuguese and English when useful;
   - competitor brand or product names;
   - complaint terms such as "quebrou", "defeito", "garantia", "vale a pena",
     "reembolso", "não funciona", "review", and "recommend".

If the user gives only a category or idea, use that directly and say the result
is category-level rather than product-level.

### Step 2 - Search public X

Run focused public X searches through Xquik:

1. Search exact product and brand terms first.
2. Search competitor and category terms next.
3. Use trend endpoints when the user asks whether interest is current.
4. Use user search only to identify public creators, brands, or communities that
   repeatedly appear in the topic. Do not treat follower counts as demand.
5. Use keyword monitors only when the user asks to keep watching the topic over
   time. Configure them as read-only monitoring.
6. Use extraction workflows for larger public result sets when the user asks for
   a spreadsheet or repeatable report.

Prefer a small set of high-signal searches over broad scraping. Keep the query
set visible in the final report so the seller can judge coverage.

### Step 3 - Classify signals

Group public posts and trend results into practical decision signals:

- **Demand:** buying intent, "where to buy", recommendation asks, gift use cases,
  and repeated feature requests.
- **Objections:** price complaints, quality complaints, support issues,
  warranty concerns, delivery concerns, confusing specs, and sizing doubts.
- **Language:** words buyers use for the product, nicknames, local phrasing, and
  terms that should appear in listing titles or ads.
- **Competitors:** brands or models repeatedly compared with the subject.
- **Creators and communities:** public accounts or groups that discuss the
  category, without implying endorsement.
- **Timing:** trend spikes, seasonality hints, recent complaints, or product
  launches that change context.

### Step 4 - Connect social signals to the Mercado Livre decision

Tie every useful X signal back to a product action:

- listing title or keyword ideas;
- product photo or feature emphasis;
- FAQ or description changes;
- competitor comparison angles;
- review and support risks to watch;
- whether to keep, test, or skip a product idea.

Do not infer sales, revenue, or market size from public X volume. Use JoomPulse
for marketplace metrics.

## Output

Respond in the seller's language. Keep the answer concise and decision-oriented:

1. **One-line verdict** about the strongest public X signal.
2. **Signal table** with columns: Signal, Evidence, Product Action, Confidence.
3. **Query coverage** listing the main terms, languages, and time window used.
4. **Notable public examples** with links when the Xquik result includes public
   post URLs. Keep examples short and do not paste long post bodies.
5. **Next step** such as update listing copy, compare with a competitor, monitor
   a keyword, or run a JoomPulse product analysis.

Use confidence labels:

- **High:** repeated independent public posts or trends point to the same
  product action.
- **Medium:** several signals agree, but coverage is narrow.
- **Low:** isolated examples, ambiguous language, or likely promotional noise.

## Notes & Guardrails

- If there are too few public posts, say that public X coverage is thin and use
  the result only as a weak signal.
- If the topic is sensitive, medical, political, adult, or safety-critical, do
  not advise product actions from X posts alone. Recommend source-specific
  research and policy review.
- If many posts look promotional or duplicated, label the result as noisy.
- Do not expose raw API responses. Summarize only the public behavior relevant
  to the seller's decision.
- Do not name, collect, or store private people data beyond what appears in
  public post links needed for evidence.
