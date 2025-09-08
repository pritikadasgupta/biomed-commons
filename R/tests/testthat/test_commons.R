#!/usr/bin/env Rscript
# File: R/tests/testthat/test_commons.R
# Author: Rose (Pritika) Dasgupta
# Description:
#
# Style:
#   - Names: snake_case; functions are verbs. (Advanced R style)
#   - Layout: 2-space indent, <- assignment, ~80 char lines. (Google R Style Guide)

source("R/R/commons.R")

test_that("clean_colnames works", {
  x <- c("A b", "C/D", "end_")
  y <- clean_colnames(x)
  expect_equal(y, c("a_b","c_d","end"))
})

test_that("tabulate_by_group works", {
  df <- data.frame(g = c("A","A","B","B","B","A","B"),
                   v = c("x","y","x","x","y","x","y"))
  out <- tabulate_by_group(var = "v", group = "g", data = df)
  expect_true(all(c("grp","level","n","proportion") %in% names(out)))
})

test_that("chisq_test_counts runs", {
  df <- data.frame(level = c("Yes","No","Yes","No"),
                   grp = c("T","T","C","C"),
                   n = c(30, 20, 10, 40))
  cs <- chisq_test_counts(df)
  expect_true(is.finite(cs$p_value))
})
