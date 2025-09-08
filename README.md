# biomed-commons

These are common data manipulation and cleaning utilities for biomedical 
and clinical data science in **R**, **Python**, **SAS**, and **Julia**, 
plus vetted, reproducible **use cases** drawn from my research and professional work.

**Author:** Rose (Pritika) Dasgupta  
**License:** MIT (see `LICENSE`)  
**Cite:** See `CITATION.cff`

## What’s inside

- **R**: Minimal‑dependency, base‑R implementations for clinical tables,
  numeric summaries, common tests (χ², Fisher, Wilcoxon, Kruskal, ANOVA),
  file IO helpers, and plotting/diagnostics.
- **Python / Julia / SAS**: Matching function names & behavior for parity
  across languages (incrementally added).
- **Use cases (synthetic data only)** reflecting my work:
  - Gait & falls risk (accelerometry, older adults)
  - Reproductive health prediction (cohort pipelines, survival/trajectories)
  - Pelvic pain comorbidity (EHR + claims)
  - GWAS / exome‑chip summaries (QC, Manhattan, QQ)
  These align with the projects and experience in my CV/Resume. 

> **Note on authorship:** This repository is authored by **Rose (Pritika)
> Dasgupta**. Earlier internal scripts and ideas from colleagues informed
> my thinking, but the code here is written by me. Please cite this repo
> (see `CITATION.cff`).

## Quickstart

### R

```r
# load functions
source("R/R/commons.R")

# example: clean column names, tabulate categorical
df <- data.frame(Sex = c("F","M","F",NA), Group = c("A","A",NA,"B"))
clean <- clean_colnames(names(df))
names(df) <- clean

tab <- tabulate_by_group(var = "sex", group = "group", data = df)
print(tab)
```

Run tests:

```bash
Rscript -e 'install.packages("testthat", repos="https://cloud.r-project.org")'
Rscript -e 'testthat::test_dir("R/tests/testthat")'
```

### Python

```bash
python -m venv .venv && source .venv/bin/activate
pip install pytest
pytest -q
```

### Julia

```julia
using Pkg
Pkg.activate("julia")
Pkg.instantiate()
Pkg.test()
```

### SAS


## Style

- **R naming:** snake_case for variables and functions, verbs for functions.  
    (Advanced R Style—naming & organization).
    
- **R layout:** two‑space indents, `<-` for assignment, ~80 char lines,  
    function docs with `Args:` / `Returns:`. (Google R Style Guide).
    

## Contributing

- Open an issue for enhancements or parity requests across languages.
    
- No PHI (Protected Health Information) or PII (Personally Identifiable Information)
- Only **synthetic data only** in the repository.


## Citation

Please cite this repository if it informs your work. See `CITATION.cff`.

