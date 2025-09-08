# Security Policy

This project operates in biomedical, clinical, and health insurance contexts. Our top priorities are **privacy**, **confidentiality**, and **credential hygiene**. This policy covers security issues related to code, data, and secrets in this repository and its discussions.

This policy complements our Code of Conduct (Contributor Covenant v3.0). 

---

## Report a security/privacy issue

- **Do not** open a public GitHub issue for privacy or credential exposures.
- **Email the maintainer privately:** pritika.dasgupta@gmail.com  
  Include a minimal description and links/commit SHAs; do **not** include sensitive data in the email body. 

For **code vulnerabilities** (not involving PHI/PII), you may alternatively use GitHub *Security Advisories* (Private vulnerability reporting). When in doubt, email first.

---

## Scope

We treat the following as **security** incidents:

- Privacy breaches (PHI/PII exposure; linkable or re‑identifiable aggregates)
- Credential/secret leakage (API keys, tokens, passwords, endpoints)
- Unsafe sample data or examples that could mislead users into unsafe practices
- Build/CI secrets or access misconfigurations

---

## Immediate actions for suspected PHI/PII exposure

1. **Containment**
   - Remove offending content from the repo (force‑push if needed after history rewrite).
   - Temporarily lock the PR/issue/discussion containing sensitive content.
2. **History cleanup**
   - Rewrite history to purge the data (`git filter-repo` or BFG Repo‑Cleaner).
   - Force‑push and invalidate any forks/caches where feasible; coordinate with maintainers.
3. **Replacement**
   - Substitute with **synthetic** or properly aggregated data and document the change.
4. **Notification**
   - Email the maintainer with commit SHAs/links and a short description (no PHI/PII in the email). 
5. **Follow‑up**
   - Add a brief post‑incident note (redacted) summarizing scope and prevention steps.

> **Small‑cell suppression:** Never publish or commit tables/figures with cells `< 5` or rare linkable combinations. Avoid free‑text that could re‑identify individuals. Prefer synthetic data in all examples.

---

## Immediate actions for credential/secret exposure

1. **Revoke/rotate immediately** (see checklist below).  
2. **Purge the secret from git history** (`git filter-repo`/BFG) and force‑push.  
3. **Invalidate artifacts** (cached notebooks, built docs, CI logs) that may contain the secret.  
4. **Audit** access logs and recent CI runs for misuse.  
5. **Notify** the maintainer privately with pointers to the commit/PR and what was rotated. 

### Token & credential rotation checklist

- Revoke the exposed key/token; generate a new one with **least privilege**.
- Update secrets in:
  - GitHub Actions → Repository/Org *Secrets and variables* (and any ENV stores)
  - Local `.env` files (never commit these)
  - Third‑party services (cloud providers, package registries, data vendors)
- Rotate adjacent credentials (DB users, service accounts) if they might be related.
- Search the repo (and open PRs/issues) for **other occurrences** of the same secret.
- Add/verify **secret‑scanning** and pre‑commit hooks (e.g., gitleaks) to prevent recurrence.
- Document the rotation (without pasting any secrets).

---

## Data handling rules (repository)

- **No PHI/PII** in code, data, examples, or discussions. Use **synthetic** or fully de‑identified aggregates.
- Apply **small‑cell suppression** and remove free‑text that could re‑identify individuals.
- Do not commit:
  - `.env` files, raw exports from clinical systems, or unvetted logs
  - API keys, passwords, tokens, or private endpoints
- Prefer environment variables and secret stores; add patterns to `.gitignore`.

---

## Coordinated disclosure (code vulnerabilities)

For non‑privacy code vulnerabilities:
- Provide steps to reproduce with **synthetic** inputs only.
- We’ll coordinate a fix and publish a patched release and note (crediting reporters who wish to be named).

---

## Questions

If you are unsure whether something is a security/privacy issue, **email first**:  
**pritika.dasgupta@gmail.com** (private, single‑maintainer inbox). 
