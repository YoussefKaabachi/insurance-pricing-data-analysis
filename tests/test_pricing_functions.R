# Unit Tests für die Funktionen im Ordner R/.
library(testthat)

# testthat startet diese Datei im Ordner tests/. Deshalb gehen wir zuerst
# eine Ebene nach oben. Der zweite Pfad erlaubt auch das direkte Ausführen
# aus dem Projektordner.
function_file <- file.path("..", "R", "pricing_functions.R")
if (!file.exists(function_file)) {
  function_file <- file.path("R", "pricing_functions.R")
}
source(function_file)

test_that("Die durchschnittliche Prämie wird korrekt berechnet", {
  expect_equal(calculate_average_premium(c(100, 200, 300)), 200)
})

test_that("Fehlende Prämien werden ignoriert", {
  expect_equal(calculate_average_premium(c(100, NA, 300)), 200)
})

test_that("Text statt Zahlen erzeugt eine Fehlermeldung", {
  expect_error(calculate_average_premium(c("100", "200")), "müssen numerisch")
})

test_that("Die Risikokennzahl wird korrekt berechnet", {
  expect_equal(calculate_risk_score("high", 2), 5)
  expect_equal(calculate_risk_score("low", 0), 1)
})

test_that("Eine ungültige Risikostufe erzeugt eine Fehlermeldung", {
  expect_error(calculate_risk_score("very_high", 1), "muss low")
})

test_that("Die Datenprüfung akzeptiert gültige Beispieldaten", {
  valid_data <- data.frame(
    contract_id = "C100", industry = "IT-Beratung", region = "Nord",
    risk_level = "low", claims_count = 0, annual_premium = 1200, claim_amount = 0
  )
  expect_true(validate_contract_data(valid_data))
})

test_that("Negative Prämien werden abgelehnt", {
  invalid_data <- data.frame(
    contract_id = "C101", industry = "Bau", region = "West",
    risk_level = "medium", claims_count = 1, annual_premium = -50, claim_amount = 100
  )
  expect_error(validate_contract_data(invalid_data), "darf nicht negativ")
})
