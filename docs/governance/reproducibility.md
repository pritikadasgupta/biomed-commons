# Reproducibility

This repository aims for **deterministic, documented** results where possible.

## General practices

- Set **random seeds** in all languages (document the value).
- Save exact **environment metadata**:
  - OS, language version, package versions
  - Hardware if relevant to performance claims
- Keep **data provenance**: how synthetic data are generated.
- Record **command lines** (Makefile, scripts, or README snippets).
- Prefer **small, fast tests** for CI; heavier examples optional/skip on CI.

## Language-specific guidelines

### R

- Use base-R implementations by default (already in `R/R/commons.R`).
- Record session info with `sessionInfo()` in vignettes.
- Optional: pin dependencies via `renv` for complex examples.

### Python

- Use a virtual environment: `python -m venv .venv`.
- Pin dependencies in `requirements.txt` or `pyproject.toml`.
- Record `pip freeze > artifacts/pip-freeze.txt` in CI for reference.

### Julia

- Commit `Project.toml` and **do not** commit `Manifest.toml` unless you need
  exact reproducibility; for published results, include the manifest.
- Use `Pkg.status()` in reports to record versions.

### SAS

- Indicate SAS version in logs.
- Save logs as CI artifacts when possible.

## File integrity

- For larger artifacts, store checksums (e.g., `sha256sum`) in `artifacts/`.
- Consider Git LFS for binary outputs if they become necessary.

## CI expectations

- R: `testthat` tests must pass.
- Python: `pytest` must pass; optional coverage target ≥ 80%.
- Julia: `Pkg.test()` passes.
- SAS: macro tests or SASPy-driven tests pass.