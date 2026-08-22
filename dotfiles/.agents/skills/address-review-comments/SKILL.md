---
name: address-review-comments
description: 'Address REVIEW: comments left in the code during review — find them, fix the code, delete the ones actually resolved, and report. Use when the user says "address my review comments", "address reviews", "REVIEW comments", "resolve my reviews", "I left you review comments", or invokes /review.'
---

# Address REVIEW: comments

A `REVIEW:` comment in the source is an objection from a senior reviewer, addressed to you. Fix the
code, remove the comments you actually resolved, report on all of them.

## 1. Find them

```sh
rg -n --no-heading '\bREVIEW:'
```

If there are no hits, say so and stop — do not go hunting for other things to fix.

## 2. Address each one

- The comment sits on the line **above** the code it refers to.
- A `(L12-20)` prefix means it covers that whole span. Those numbers are from when the comment was
  written, so locate the span by its **content**, not by the numbers.
- A comment may run over several lines — read the whole block before acting.
- Read enough surrounding code to understand *why* the reviewer objected. Comments are often terse
  ("wrong", "N+1?", "why not the existing helper?") and expect you to work out the rest. Ask only
  if the comment is genuinely ambiguous and guessing wrong would be expensive.

## 3. Delete only what you resolved

A comment still in the file means "open", so remove the block — every line of it — when and only
when the code now satisfies it.

- Cannot fix it → leave the comment, explain in the report.
- Disagree with it → leave the comment, argue your case in the report. Never silently comply with a
  change you think is wrong, and never silently ignore one either.
- Needs a decision only the user can make → leave the comment, ask in the report.

Never touch `TODO:`, `FIX:`, `HACK:`, `NOTE:` or any other keyword — those are not yours. Do not
reformat or "improve" code beyond what a comment actually asked for.

## 4. Report

| File:line | Comment | What changed |
|---|---|---|
| `src/foo.ts:42` | N+1 on the members query | Batched into one `findAll` with `populate: ['user']` |

Then, if anything is still open:

**Unresolved**

- `src/bar.ts:88` — "extract this into a service" — *disagree*: one caller, no state; extracting
  adds a file without removing complexity. Left as is, comment kept.
- `src/baz.ts:12` — "which currency here?" — *needs a decision*: settlement or booking currency?

Every comment found in step 1 appears exactly once, in one of the two sections. No exceptions.
