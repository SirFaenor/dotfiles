---
name: feedback-exploratory-dialogue
description: User prefers exploratory architectural dialogue and quantified complexity tradeoffs before any code or implementation plan
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 73711513-e0fb-4f68-88f9-b6557ac27cb2
---

For architectural decisions, user opens with "confrontiamo le idee" and explicitly asks complexity questions ("quanto più complesso sarebbe...") before any code is written. Responds well to pushback on their own framing when it is justified.

**Why:** During the Atmosphera kickoff (2026-05-22), user proposed a fully generic CMS platform but explicitly invited a complexity assessment. They accepted the recommendation *against* the generic path once given quantified tradeoffs (~5-10× dev time, specific pain points) and a real discriminating question (self-service SaaS vs agency white-label). They explicitly said "Eventualmente chiedi dettagli. Poi ti farò io delle domande" — signaling: read briefing first, ask clarifications, then wait to be driven.

**How to apply:**
- When a briefing/spec doc is referenced, read it first, summarize understanding, ask targeted clarifying questions, then stop and wait
- Quantify complexity tradeoffs with concrete multipliers and named pain points — not vague "it depends"
- Push back on the user's framing when warranted; they invite it
- Surface the *one* discriminating question that forces the architectural choice (e.g. "self-service or agency?") rather than listing every option
- Do NOT jump to implementation plans, code, or file edits during exploratory discussion — wait for an explicit go-ahead
- Respond in Italian when the user writes in Italian

Related: [[project-atmosphera]]
