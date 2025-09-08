# SAS Style Guide (Project)

- **Case**: SAS is case-insensitive; we use `snake_case` for readability.
- **Macros**: `%snake_case` names; describe parameters in comments.
- **Indentation**: 2 spaces; align continuation lines.
- **Line length**: ~80 characters.
- **Datasets**: `snake_case` table and variable names.
- **Comments**: `* ... ;` for block comments; `/* ... */` acceptable; be consistent.
- **Logs**: avoid `NOTE:`/`WARNING:` explosions; check logs into CI artifacts.

## Data steps and procs

- Prefer explicit variable lists over `drop=_all_`/`keep=_all_`.
- Validate merges with row count checks before/after.
- Use formats for category labels; avoid magic numbers.

## Testing

- Place macro tests under `sas/tests/`.
- Provide `%assert_equal()`, `%assert_true()` macro helpers for simple checks.