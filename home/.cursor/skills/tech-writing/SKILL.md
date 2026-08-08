---
name: tech-writing
description: Apply Kyle's writing style to engineering prose. Use when drafting or editing READMEs, design docs, doc comments, PR descriptions, error messages, or any documentation — or when asked to improve the tone, clarity, or voice of technical writing.
---

# Tech Writing

The register is Grant's *Personal Memoirs*: direct, matter-of-fact, declarative. Short sentences carry the load. Adjectives are rare and earn their place. The prose reports rather than performs — when tempted to dramatize a point, prefer the plainer construction; if the point is real, the plain construction lands harder. This file is written in the style it demands; when unsure, sound like this file.

## Principles

- **Brevity.** When two phrasings convey the same thing, take the shorter. When two paragraphs make the same point, keep the cleaner one and cut the other.
- **Concrete over abstract.** A specific example carries a principle better than the principle carries itself. Show the command, the error, the code — then state the rule it illustrates, if the rule still needs stating.
- **Short words are best, and old words when short are best of all.** Reach first for the plain word. Latinate vocabulary is reserved for precise technical terms that carry meaning the short word cannot — and there, gloss the term on first use. *Utilize* is not better than *use*. *Instantiate* is rarely better than *create*, unless refering to a precise term of a programming language.
- **Argument over assertion.** Don't claim a thing is true; show how it follows. The reader should be able to reconstruct the case — why this design, why not the alternative — without leaning on the author's authority. Build the case as a demonstration in Lincoln's Euclid-inspired manner — premises first, each step from the last; when a disagreement traces to a rejected premise, say so plainly.
- **Own the conclusion.** Hedges like "perhaps," "it could be argued," and "should probably" are a tell that the thinking isn't finished. Either commit, or say plainly that the question is unresolved and why.
- **No scaffolding.** No "as discussed above," no "this deserves its own doc," no residue from the conversation that produced the text. The reader sees the building, not the crane.
- **Every paragraph does work.** Each paragraph must change what the reader knows or can do. If it could be cut without changing either, cut it.

## Applying to common forms

- **READMEs and guides:** lead with what the thing is and the command that uses it. Prerequisites and caveats come after the happy path, not before.
- **Design docs:** state the decision first, then the argument for it, then the alternatives and why they lost. A design doc that hides its conclusion until the end wastes every reader who only needed the conclusion.
- **Doc comments:** explain intent and constraints, not what the code does. Concise above all.
- **PR descriptions and commit messages:** the "why" is the payload; the diff already shows the "what."
- **Error messages:** `failed to load config ~/.config/foo.toml: missing key "endpoint" — add it or set FOO_ENDPOINT`. What failed, the values involved, and the remedy — as that one does.

## When editing

Quote the original and the proposed sentence side by side, with a short reason pointing to a principle above. Prefer surgical cuts and reorderings over wholesale rewrites. Like so:

> *"It should probably be noted that this function can potentially block for a relatively long time."*
> *"This function blocks — up to 30s on a cold cache."*
> — cuts three hedges; names the value.
