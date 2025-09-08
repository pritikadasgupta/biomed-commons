# Security Policy (GitHub)

This repository operates in biomedical, clinical, and insurance domains. Privacy, confidentiality, and credential hygiene are top priorities.

This page summarizes how to **report** issues via GitHub’s Security tab and points to the full policy in [`SECURITY.md`](../SECURITY.md).

---

## Report a vulnerability or privacy/credential issue

- **Prefer private reports.** Use GitHub’s **Private vulnerability reporting** on the **Security** tab if available, or email the maintainer:
  - **pritika.dasgupta@gmail.com** (private inbox). Please provide links/commit SHAs; do **not** paste PHI/PII or secrets.

- For **PHI/PII** or **credential** exposure, **do not** open a public issue. See the root [`SECURITY.md`](../SECURITY.md) for immediate containment steps, small‑cell suppression rules, and token rotation checklist.

---

## Scope (what counts as a security issue)

- PHI/PII exposure or re‑identification risk (including small cells < 5)
- Secrets/credentials (API keys, tokens, passwords, endpoints)
- Unsafe examples that could lead to privacy breaches
- CI/build secrets or access misconfigurations

---

## Relationship to the Code of Conduct

Our **Code of Conduct** (Contributor Covenant v3.0) governs behavior in all project spaces and reinforces safety, dignity, and equity. Security/privacy reporting is in addition to those standards.
