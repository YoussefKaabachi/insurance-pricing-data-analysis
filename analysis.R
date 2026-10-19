# Liest fiktive Versicherungsdaten ein, prüft sie und erstellt Auswertungen.
source("R/pricing_functions.R")

# 1. Daten einlesen
contracts <- read.csv("data/insurance_contracts.csv", stringsAsFactors = FALSE)
cat("Anzahl eingelesener Verträge:", nrow(contracts), "\n")

# 2. Daten prüfen
validate_contract_data(contracts)
cat("Datenprüfung: erfolgreich\n")

# 3. Fehlende Geldwerte ersetzen
contracts_clean <- clean_contract_data(contracts)
cat("Fehlende Geldwerte wurden mit dem Median ersetzt.\n\n")

# 4. Kennzahlen berechnen
average_premium <- calculate_average_premium(contracts_clean$annual_premium)
cat("Durchschnittliche Jahresprämie:", round(average_premium, 2), "EUR\n\n")

average_claims_by_industry <- aggregate(claims_count ~ industry, data = contracts_clean, FUN = mean)
names(average_claims_by_industry)[2] <- "average_claims"
cat("Durchschnittliche Anzahl der Schäden nach Branche:\n")
print(average_claims_by_industry)

average_premium_by_risk <- aggregate(annual_premium ~ risk_level, data = contracts_clean, FUN = mean)
names(average_premium_by_risk)[2] <- "average_premium"
cat("\nDurchschnittliche Prämie nach Risikostufe:\n")
print(average_premium_by_risk)

contracts_many_claims <- contracts_clean[contracts_clean$claims_count > 1, ]
cat("\nVerträge mit mehr als einem Schaden:\n")
print(contracts_many_claims[, c("contract_id", "industry", "risk_level", "claims_count")])

# 5. Eine einfache Risikokennzahl pro Vertrag hinzufügen.
contracts_clean$risk_score <- mapply(calculate_risk_score, contracts_clean$risk_level, contracts_clean$claims_count)

# 6. Diagramm und bereinigte Daten speichern.
dir.create("output", showWarnings = FALSE)
png("output/average_premium_by_risk.png", width = 900, height = 600)
barplot(average_premium_by_risk$average_premium,
  names.arg = average_premium_by_risk$risk_level,
  col = c("#7FB3D5", "#F7DC6F", "#E59866"),
  main = "Durchschnittliche Jahresprämie nach Risikostufe",
  xlab = "Risikostufe", ylab = "Durchschnittliche Jahresprämie in EUR")
dev.off()
write.csv(contracts_clean, "output/insurance_contracts_cleaned.csv", row.names = FALSE)

cat("\nFertig. Ergebnisse liegen im Ordner output/.\n")
