# Python Style Guide (Project)

- **PEP 8** + **ruff** + **black** (line length 88 by default)
- **Docstrings**: Google- or NumPy‑style
- **Typing**: use type hints for public functions
- **Tests**: `pytest`

## Summary

- **Naming**: `snake_case` for functions/variables, `PascalCase` for classes,
  `UPPER_SNAKE` for constants.
- **Imports**: standard lib, third‑party, local — in that order; no wildcard imports.
- **Formatting**: run `black .` and `ruff --fix .`.
- **Type hints**: annotate parameters and return types.
- **Errors**: raise the most specific exception; avoid bare `except:`.
- **Logging**: use `logging` (no print statements in library code).
- **Tests**: place under `python/tests/`; prefer small, pure unit tests.

## Example

```python
def tabulate_by_group(var: str, group: str, df: "pd.DataFrame") -> "pd.DataFrame":
    """Two-way counts & row-wise proportions by grouping variable."""
    sub = df[[var, group]].dropna()
    counts = sub.groupby([group, var]).size().rename("n").reset_index()
    denom = counts["n"].sum()
    props = (
        counts.groupby(group)["n"].apply(lambda x: x / x.sum()).rename("proportion")
    )
    out = counts.merge(props, left_on=group, right_index=True)
    out["label"] = out["n"].map("{:,}".format) + " (" + (100 * out["proportion"]).round(0).astype(int).astype(str) + "%)"
    out["var"] = var
    out["grp_col"] = group
    out["denom"] = denom
    return out
```