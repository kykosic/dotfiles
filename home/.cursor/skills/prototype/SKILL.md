---
name: prototype
description: Write example code of someone using a library or tool that does not yet exist, to explore the user experience before deciding what to build. Use when the user asks for a "prototype" of a library, framework, or API — e.g. "write a prototype for a new training framework in pure Rust." The code does not need to compile and the backing library is not implemented.
---

# Prototype

Start with the user experience and work backwards to the technology. When asked for a prototype of X — a Rust library being the common case — write the code a *user* of X would write, against an API that does not exist yet. The point is to see what the library feels like in the caller's hands, derive what the backend must provide, and judge whether building it is worthwhile.

## Rules

- **The code does not need to compile.** There is no `Cargo.toml`, no implementation, no stubs of the backing library. Do not scaffold a crate. The prototype is a design document that happens to be written in code.
- **Write a real task, not a tour.** For "a training framework in pure Rust," write an actual training loop — data loading, model definition, optimizer step, checkpointing — the way a real user would. Do not showcase every imagined API; showcase the one workflow that matters.
- **Optimize for ergonomics on the page.** Every line is a claim about how the library should feel. The target is clap- or serde-level ergonomics: the caller's code should read like the problem, not like the library. Comments may flag deliberate design choices ("builder here so config stays optional") but should not narrate the code.

## Output location

Put the prototype wherever the working context suggests — a scratch or experiments directory if the repo has one, otherwise alongside the relevant design notes. Ask only if there is no obvious home.
