# Data Privacy & Protection

**No PHI/PII in the repository.** Only synthetic data or fully de-identified
aggregates are permitted.

## Definitions (non-legal)

- **PHI/PII**: Any data that could identify an individual (alone or combined).
- **De-identified**: Risk of re-identification is sufficiently mitigated for
  public release (e.g., HIPAA Safe Harbor–style removal).

## Rules for this repository

1. **Synthetic data only** in `data/` and `use-cases/`.  
   - Generate from statistical summaries or parametric models.
2. **No row-level real patient data** of any kind.
3. **Small cell suppression**: Do not publish counts `< 5` in any example or doc.
4. **Dates**: If needed, jitter or offset by a fixed unknown number of days.
5. **Free text**: Do not include raw clinical notes.
6. **Keys/IDs**: Use random or hashed IDs with salts that are **not** committed.

## Review & compliance

- PRs that add or modify data will be reviewed for privacy compliance.
- If in doubt, open an issue before committing any data samples.

## Disclaimer

This document is informational and not legal advice. Consult your local IRB,
privacy office, or legal counsel for specific guidance.