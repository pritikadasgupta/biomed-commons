# R Style Guide (Project)

This project uses a **hybrid** that’s simple and consistent:

- **Naming:** `snake_case` for functions and variables; functions are **verbs**  
  (from Advanced R style guidance).
- **Layout & Syntax:** **Google’s R Style Guide** for indentation, spacing,
  80‑char lines, `<-` assignment, braces, ordering, and function docs. 

## Summary

- **Files** end in `.R`; meaningful names.
- **Indentation**: 2 spaces; no tabs.
- **Line length**: ~80 characters.
- **Assignment**: use `<-`, not `=`.
- **Braces**: open on same line; close on their own line.
- **Spaces**: around binary operators; after commas; no spaces inside `()` or `[]`.
- **Order**: (1) Copyright, (2) Author, (3) File description,
  (4) `source()`/`library()`, (5) function defs, (6) executed statements.
- **Docs**: Use `#` comments with `Args:` and `Returns:` sections for functions.
- **Naming**: `clean_colnames()`, `tabulate_by_group()`, `summarize_numeric_overall()`.
  Avoid name collisions with base R.

See: Google’s R Style (layout & syntax) and Advanced R (naming). 