#!/usr/bin/env Rscript
# File: R/R/commons.R
# Author: Rose (Pritika) Dasgupta
# Description:
#   Base-R utilities for biomedical/clinical data work:
#     - Column-name cleaning
#     - One-/two-way categorical tables
#     - Numeric summaries (overall & by group)
#     - Common tests (chisq, fisher, wilcoxon, kruskal, anova)
#     - Image saving (PNG/TIFF), model diagnostics, CSV writing
#     - Weighted quartiles; approx. weighted Wilcoxon
#     - Optional ODBC connection; optional lmer fit
#
# Style:
#   - Names: snake_case; functions are verbs. (Advanced R style)
#   - Layout: 2-space indent, <- assignment, ~80 char lines. (Google R Style Guide)

# clean_colnames --------------------------------------------------------------

#' Clean a vector of column names into snake_case using underscores.
#'
#' Args:
#'   names (character): The original column names.
#'
#' Returns:
#'   character vector of cleaned names.
clean_colnames <- function(names) {
  nm <- gsub(' |-|/|\\(|\\)|>|:|=|;|,|__|\\&|\\[|\\]|\\.|\\?|\\"|#|\\+|@|\\*',
             "_", names, perl = TRUE)
  nm <- gsub("_+", "_", nm, perl = TRUE)
  nm <- gsub("_$", "", nm, perl = TRUE)
  tolower(nm)
}

# save_png / save_tiff --------------------------------------------------------

#' Save a base plot or printable object to PNG.
#'
#' Args:
#'   path (character): Output path (e.g., "plots/fig.png").
#'   draw (function or object): A function that draws or a printable object.
#'   width_px (integer): Width in pixels. Default 1630.
#'   height_px (integer): Height in pixels. Default 980.
#'
#' Returns:
#'   TRUE (invisibly) on success.
save_png <- function(path, draw, width_px = 1630, height_px = 980) {
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  grDevices::png(path, width = width_px, height = height_px)
  on.exit(grDevices::dev.off(), add = TRUE)
  if (is.function(draw)) draw() else print(draw)
  invisible(TRUE)
}

#' Save a base plot or printable object to TIFF.
save_tiff <- function(path, draw, width_px = 1630, height_px = 980,
                      compression = "lzw", res = NA_integer_) {
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  grDevices::tiff(path, width = width_px, height = height_px, units = "px",
                  compression = compression, res = res)
  on.exit(grDevices::dev.off(), add = TRUE)
  if (is.function(draw)) draw() else print(draw)
  invisible(TRUE)
}

# tabulate_oneway / tabulate_by_group ----------------------------------------

#' Tabulate a single categorical variable among rows where `strata` is non-NA.
#'
#' Args:
#'   var (character): Column name to tabulate.
#'   strata (character): Column restricting rows (keep non-NA only).
#'   data (data.frame): Input data.
#'
#' Returns:
#'   data.frame with: n, level, proportion, label, var, strata, denom.
tabulate_oneway <- function(var, strata, data) {
  if (!all(c(var, strata) %in% names(data))) {
    stop("tabulate_oneway: variables not found in data.")
  }
  keep <- !is.na(data[[strata]])
  x <- data[[var]][keep]
  x <- x[!is.na(x)]
  tbl <- table(x)
  prp <- prop.table(tbl)

  n <- as.integer(tbl)
  level <- names(tbl)
  proportion <- as.numeric(prp)
  label <- sprintf("%s (%.1f%%)",
                   format(n, big.mark = ",", trim = TRUE),
                   100 * proportion)
  denom <- sum(n)

  data.frame(
    n = n, level = level, proportion = proportion, label = label,
    var = var, strata = strata, denom = denom,
    stringsAsFactors = FALSE
  )
}

#' Two-way counts & row-wise proportions by grouping variable.
#'
#' Args:
#'   var (character): Response categorical column.
#'   group (character): Grouping column.
#'   data (data.frame): Input data.
#'
#' Returns:
#'   data.frame with: grp, n, level, proportion, label, var, grp_col, denom.
tabulate_by_group <- function(var, group, data) {
  if (!all(c(var, group) %in% names(data))) {
    stop("tabulate_by_group: variables not found in data.")
  }
  tbl <- table(data[[group]], data[[var]])
  prp <- prop.table(tbl, 1)

  df_n <- as.data.frame(tbl, stringsAsFactors = FALSE)
  names(df_n) <- c("grp", "level", "n")
  df_p <- as.data.frame(prp, stringsAsFactors = FALSE)
  names(df_p) <- c("grp", "level", "proportion")

  out <- merge(df_n, df_p, by = c("grp", "level"), all = TRUE)
  out$label <- sprintf("%s (%.0f%%)",
                       format(out$n, big.mark = ",", trim = TRUE),
                       100 * out$proportion)
  out$var <- var
  out$grp_col <- group
  out$denom <- sum(out$n)
  out[, c("grp", "n", "level", "proportion", "label",
          "var", "grp_col", "denom")]
}

# numeric summaries -----------------------------------------------------------

.base_favstats <- function(v) {
  v <- v[is.finite(v)]
  n <- length(v)
  if (n == 0L) {
    return(data.frame(min = NA_real_, Q1 = NA_real_, median = NA_real_,
                      Q3 = NA_real_, mean = NA_real_, sd = NA_real_, n = 0L,
                      missing = NA_integer_, stringsAsFactors = FALSE))
  }
  qs <- stats::quantile(v, probs = c(0.25, 0.5, 0.75), names = FALSE, type = 7)
  data.frame(
    min = min(v), Q1 = qs[1], median = qs[2], Q3 = qs[3],
    mean = mean(v), sd = stats::sd(v), n = n, missing = NA_integer_,
    stringsAsFactors = FALSE
  )
}

#' Overall numeric summary for `var`, restricted to non-NA `strata`.
summarize_numeric_overall <- function(var, strata, data) {
  if (!all(c(var, strata) %in% names(data))) {
    stop("summarize_numeric_overall: variables not found in data.")
  }
  keep <- !is.na(data[[strata]])
  v_all <- data[[var]][keep]
  v_clean <- v_all[is.finite(v_all)]
  missing <- sum(!is.finite(v_all))
  row <- .base_favstats(v_clean)
  row$missing <- missing
  row$grp <- "total"
  row$var <- var
  row$strata <- strata
  row$marginal_mean_sd <- sprintf("%.2f (%.2f)", row$mean, row$sd)
  row$marginal_med_iqr <- sprintf("%.2f (%.2f - %.2f)",
                                  row$median, row$Q1, row$Q3)
  row
}

#' Grouped numeric summary for `var` by `group`.
summarize_numeric_by_group <- function(var, group, data) {
  if (!all(c(var, group) %in% names(data))) {
    stop("summarize_numeric_by_group: variables not found in data.")
  }
  g <- data[[group]]
  v <- data[[var]]
  levs <- sort(unique(g[!is.na(g)]))
  res <- lapply(levs, function(L) {
    vL <- v[g == L]
    row <- .base_favstats(vL)
    row$grp <- as.character(L)
    row
  })
  out <- do.call(rbind, res)
  out$var <- var
  out$grp_col <- group
  out$mean_sd <- sprintf("%.1f (%.1f)", out$mean, out$sd)
  out$med_iqr <- sprintf("%.1f (%.1f - %.1f)", out$median, out$Q1, out$Q3)
  out[, c("grp", names(.base_favstats(1)), "var", "grp_col", "mean_sd", "med_iqr")]
}

# tests: chisq, fisher, wilcoxon, kruskal, anova -----------------------------

chisq_test_counts <- function(data) {
  req <- c("level", "grp", "n")
  if (!all(req %in% names(data))) {
    stop("chisq_test_counts: data must have level, grp, n.")
  }
  mat <- xtabs(n ~ level + grp, data = data)
  cs <- stats::chisq.test(mat, correct = FALSE)
  data.frame(
    statistic = unname(cs$statistic),
    df = unname(cs$parameter),
    p_value = cs$p.value,
    method = "chisq",
    stringsAsFactors = FALSE
  )
}

fisher_test_safe <- function(mat) {
  res <- try(stats::fisher.test(mat), silent = TRUE)
  if (inherits(res, "try-error")) {
    res <- stats::fisher.test(mat, simulate.p.value = TRUE)
  }
  res
}

fisher_test_counts <- function(data) {
  req <- c("level", "grp", "n")
  if (!all(req %in% names(data))) {
    stop("fisher_test_counts: data must have level, grp, n.")
  }
  mat <- xtabs(n ~ level + grp, data = data)
  res <- fisher_test_safe(mat)
  data.frame(
    p_value = res$p.value,
    method = "fisher",
    stringsAsFactors = FALSE
  )
}

anova_by_group <- function(response, group, data) {
  if (!all(c(response, group) %in% names(data))) {
    stop("anova_by_group: variables not found in data.")
  }
  fm <- stats::as.formula(paste0(response, " ~ as.factor(", group, ")"))
  fit <- stats::lm(fm, data = data)
  a <- stats::anova(fit)
  pval <- a[1, "Pr(>F)"]
  data.frame(var = response, grp_col = group, p_value = pval,
             method = "anova", stringsAsFactors = FALSE)
}

wilcoxon_safe <- function(formula, data) {
  res <- try(stats::wilcox.test(formula, paired = FALSE,
                                conf.int = TRUE, exact = FALSE, data = data),
             silent = TRUE)
  if (inherits(res, "try-error")) {
    res <- stats::wilcox.test(formula, paired = FALSE,
                              conf.int = TRUE, exact = TRUE, data = data)
  }
  res
}

wilcoxon_by_group <- function(response, group, data) {
  if (!all(c(response, group) %in% names(data))) {
    stop("wilcoxon_by_group: variables not found in data.")
  }
  fm <- stats::as.formula(paste0(response, " ~ as.factor(", group, ")"))
  res <- wilcoxon_safe(fm, data)
  data.frame(var = response, grp_col = group, p_value = unname(res$p.value),
             method = "wilcoxon", stringsAsFactors = FALSE)
}

kruskal_by_group <- function(response, group, data) {
  if (!all(c(response, group) %in% names(data))) {
    stop("kruskal_by_group: variables not found in data.")
  }
  fm <- stats::as.formula(paste0(response, " ~ as.factor(", group, ")"))
  res <- stats::kruskal.test(fm, data = data)
  data.frame(var = response, grp_col = group, p_value = unname(res$p.value),
             method = "kruskal", stringsAsFactors = FALSE)
}

# diagnostics, csv, weighted summaries ----------------------------------------

save_model_diagnostics <- function(model, index, dir_path) {
  dir.create(dir_path, recursive = TRUE, showWarnings = FALSE)
  out_path <- file.path(dir_path, paste0(index, ".png"))
  grDevices::png(out_path, width = 1630, height = 980)
  oldpar <- graphics::par(no.readonly = TRUE)
  on.exit({
    graphics::par(oldpar)
    grDevices::dev.off()
  }, add = TRUE)
  graphics::par(mfrow = c(2, 2))
  plot(model)
  paste0("Diagnostics saved: ", out_path)
}

write_csv_named <- function(obj_name, index, path) {
  obj <- get(obj_name, envir = parent.frame())
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  utils::write.csv(obj, file = file.path(path, paste0(index, ".csv")),
                   row.names = FALSE, na = "")
  invisible(TRUE)
}

.weighted_quantile <- function(x, w, probs = c(0.25, 0.5, 0.75)) {
  ok <- is.finite(x) & is.finite(w) & w > 0
  x <- x[ok]; w <- w[ok]
  if (!length(x)) return(rep(NA_real_, length(probs)))
  o <- order(x)
  x <- x[o]; w <- w[o]
  w <- w / sum(w)
  cw <- cumsum(w)
  sapply(probs, function(p) {
    stats::approx(x = cw, y = x, xout = p, method = "linear",
                  ties = "ordered", rule = 2)$y
  })
}

weighted_quartiles <- function(var, weight, data) {
  if (!all(c(var, weight) %in% names(data))) {
    stop("weighted_quartiles: variables not found in data.")
  }
  x <- data[[var]]
  w <- data[[weight]]
  q <- .weighted_quantile(x, w, probs = c(0.25, 0.5, 0.75))
  data.frame(summary_stat = c("0.25", "0.5", "0.75"),
             value = q, stringsAsFactors = FALSE)
}

weighted_wilcoxon_approx <- function(var, group, weight, data) {
  req <- c(var, group, weight)
  if (!all(req %in% names(data))) {
    stop("weighted_wilcoxon_approx: variables not found in data.")
  }
  x <- data[[var]]
  g <- factor(data[[group]])
  w <- data[[weight]]
  ok <- is.finite(x) & is.finite(w) & !is.na(g) & w > 0
  x <- x[ok]; g <- factor(g[ok]); w <- w[ok]
  if (nlevels(g) != 2L) stop("weighted_wilcoxon_approx: need 2 groups.")
  target_total <- 4000
  scale <- target_total / sum(w)
  nrep <- pmax(1L, as.integer(round(w * scale)))
  x_rep <- rep(x, nrep)
  g_rep <- factor(rep(as.character(g), nrep))
  res <- stats::wilcox.test(x_rep ~ g_rep, paired = FALSE,
                            exact = FALSE, conf.int = FALSE)
  data.frame(method = "approx_weighted_wilcoxon_replication",
             p_value = unname(res$p.value),
             statistic = unname(res$statistic),
             stringsAsFactors = FALSE)
}

# Optional: ODBC and lmer -----------------------------------------------------

# open_odbc_connection <- function(schema) {
#   if (!requireNamespace("RODBC", quietly = TRUE)) {
#     stop("open_odbc_connection requires RODBC.")
#   }
#   conn <- NULL
#   if (schema %in% c("ORG")) {
#     conn <- RODBC::odbcDriverConnect(
#       # WRITE THIS LATER
#     )
#   }
#   conn
# }

fit_lmer <- function(formula_in, data, weights_col = NULL) {
  if (!requireNamespace("lmerTest", quietly = TRUE)) {
    stop("fit_lmer requires lmerTest.")
  }
  wts <- if (!is.null(weights_col)) data[[weights_col]] else NULL
  lmerTest::lmer(stats::as.formula(formula_in), data = data, weights = wts)
}