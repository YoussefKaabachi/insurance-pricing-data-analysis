# Funktionen für das Projekt "Insurance Pricing Data Analysis".

# Prüft Spalten, Risikostufen und negative Werte.
validate_contract_data <- function(data) {
  required_columns <- c("contract_id", "industry", "region", "risk_level", "claims_count", "annual_premium", "claim_amount")
  missing_columns <- setdiff(required_columns, names(data))
  if (length(missing_columns) > 0) {
    stop(paste("Fehlende Spalten:", paste(missing_columns, collapse = ", ")))
  }

  allowed_risk_levels <- c("low", "medium", "high")
  invalid_risk_levels <- !is.na(data$risk_level) & !(data$risk_level %in% allowed_risk_levels)
  if (any(invalid_risk_levels)) stop("risk_level darf nur low, medium oder high sein.")
  if (any(!is.na(data$claims_count) & data$claims_count < 0)) stop("claims_count darf nicht negativ sein.")
  if (any(!is.na(data$annual_premium) & data$annual_premium < 0)) stop("annual_premium darf nicht negativ sein.")
  if (any(!is.na(data$claim_amount) & data$claim_amount < 0)) stop("claim_amount darf nicht negativ sein.")
  TRUE
}

# Berechnet die durchschnittliche Jahresprämie. Fehlende Werte werden ignoriert.
calculate_average_premium <- function(premiums) {
  if (!is.numeric(premiums)) stop("Die Prämien müssen numerisch sein.")
  if (all(is.na(premiums))) stop("Mindestens eine Prämie muss vorhanden sein.")
  mean(premiums, na.rm = TRUE)
}

# Ein Lernbeispiel, kein echtes Versicherungsmodell: Risikostufe plus Schäden.
calculate_risk_score <- function(risk_level, claims_count) {
  risk_points <- c(low = 1, medium = 2, high = 3)
  if (length(risk_level) != 1 || is.na(risk_level) || !(risk_level %in% names(risk_points))) {
    stop("risk_level muss low, medium oder high sein.")
  }
  if (length(claims_count) != 1 || is.na(claims_count) || !is.numeric(claims_count) || claims_count < 0) {
    stop("claims_count muss eine nicht negative Zahl sein.")
  }
  unname(risk_points[risk_level] + claims_count)
}

# Ersetzt fehlende Geldwerte durch den Median der jeweiligen Spalte.
clean_contract_data <- function(data) {
  data$annual_premium[is.na(data$annual_premium)] <- median(data$annual_premium, na.rm = TRUE)
  data$claim_amount[is.na(data$claim_amount)] <- median(data$claim_amount, na.rm = TRUE)
  data
}
