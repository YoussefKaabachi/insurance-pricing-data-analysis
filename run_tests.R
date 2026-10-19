# Startet alle Unit Tests des Projekts.
if (!requireNamespace("testthat", quietly = TRUE)) {
  stop("Das Paket testthat fehlt. Bitte einmal ausführen: install.packages('testthat')")
}

testthat::test_file("tests/test_pricing_functions.R")
