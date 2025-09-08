# Julia Style Guide (Project)

- **Formatting**: `JuliaFormatter.jl`
- **Modules**: `PascalCase` module names; functions/variables in `snake_case`
- **Types**: `PascalCase` for type names
- **Tests**: `Test` stdlib

## Summary

- **Imports**: be explicit; avoid global state in modules.
- **Functions**: small, composable; prefer multiple dispatch over flags.
- **Naming**: `clean_colnames`, `tabulate_oneway`, `tabulate_by_group`.
- **Performance**: avoid type instabilities; use `@code_warntype`.
- **Docs**: use triple-string docstrings with argument types when helpful.
- **Testing**: `julia --project=julia -e 'using Pkg; Pkg.test()'`.

## Example

```julia
"""
    tabulate_oneway(var::AbstractString, strata::AbstractString, df::DataFrame)

Tabulate a single categorical variable among rows where `strata` is non-missing.
"""
````