# Contributing

Thank you for considering a contribution! This repository aims to provide
clean, tested, and reproducible utilities across **R**, **Python**, **SAS**, and
**Julia** for biomedical and clinical data science.

> **Important:** No PHI/PII. Synthetic data only in the repository.
See `docs/governance/data_privacy.md`.

## Ways to contribute

- File an issue (bug report, feature request, parity request across languages)
- Open a pull request (PR) with code, docs, tests, or examples
- Improve style and linting configurations

## Development workflow

1. Fork the repo and create a feature branch:
   ```bash
   git checkout -b feat/<short-description>
   ```

2. Implement changes with **tests** and **docs**.
    
3. Run linters and tests locally.
    
4. Open a PR to `master` with a clear description and checklist.
    

## Commit messages

Use **Conventional Commits**:

- `feat: ...` new feature
    
- `fix: ...` bug fix
    
- `docs: ...` docs or comments
    
- `refactor: ...` refactor without behavior change
    
- `test: ...` tests only
    
- `chore: ...` build, tooling, CI, or non‑code tasks
    

## Style & linting

Follow the language‑specific style docs:

- `docs/style/R_STYLE.md` — R layout (Google R Style Guide) + naming (snake_case per Advanced R)
    
- `docs/style/PYTHON_STYLE.md`
    
- `docs/style/JULIA_STYLE.md`
    
- `docs/style/SAS_STYLE.md`
    

## Testing

- **R**: `testthat::test_dir("R/tests/testthat")`
    
- **Python**: `pytest -q`
    
- **Julia**: `Pkg.activate("julia"); Pkg.test()`
    
- **SAS**: Place macro tests under `sas/tests/` (or drive via SASPy)
    

## PR checklist

-  My change includes tests and passes locally
    
-  I followed the style guide for the language(s) I touched
    
-  I updated or added relevant documentation
    
-  I did **not** include any PHI/PII or real patient data
    
-  I added or updated examples where useful
    

## Legal

- By contributing, you agree your contributions are provided under the project’s  
    license (MIT). See `LICENSE`.
    
- Please adhere to the project’s `CODE_OF_CONDUCT.md`.
