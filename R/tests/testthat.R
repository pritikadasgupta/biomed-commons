#!/usr/bin/env Rscript
# File: R/tests/testthat.R
# Author: Rose (Pritika) Dasgupta
# Description:
#
# Style:
#   - Names: snake_case; functions are verbs. (Advanced R style)
#   - Layout: 2-space indent, <- assignment, ~80 char lines. (Google R Style Guide)

library(testthat)

test_check <- function() {
  testthat::test_dir("R/tests/testthat")
}

test_check()