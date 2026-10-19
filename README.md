# Insurance Pricing Data Analysis

Ein kleines R-Projekt mit ausschließlich fiktiven Versicherungsdaten. Es zeigt Datenimport, Datenprüfung, Bereinigung, Auswertung, Funktionen und Unit Tests.

> Die Daten und die Risikokennzahl sind frei erfunden. Das Projekt ist kein echtes Preis- oder Risikomodell.

## Live-Demo

Die interaktive Shiny-Anwendung ist online verfügbar: [Insurance Pricing Data Analysis](https://youssef-kaabachi.shinyapps.io/insurance-pricing-data-analysis/)

## Ordnerstruktur

```text
insurance-pricing-data-analysis/
|-- data/insurance_contracts.csv       # 50 fiktive Versicherungsverträge
|-- R/pricing_functions.R              # Funktionen für Prüfung und Berechnung
|-- tests/test_pricing_functions.R     # Unit Tests mit testthat
|-- output/                            # wird beim Ausführen befüllt
|-- analysis.R                         # Hauptauswertung
|-- run_tests.R                        # startet die Tests
|-- app.R                              # interaktive Shiny-Seite
|-- run_shiny.R                        # startet die Shiny-Seite
`-- README.md                          # diese Anleitung
```

## Was die Daten bedeuten

| Spalte | Bedeutung |
|---|---|
| `contract_id` | fiktive Vertragsnummer |
| `industry` | Branche des Unternehmens |
| `region` | Region des Unternehmens |
| `risk_level` | vereinfachte Risikostufe: low, medium oder high |
| `claims_count` | Anzahl der Schadenfälle |
| `annual_premium` | fiktive Jahresprämie in Euro |
| `claim_amount` | fiktive Schadenhöhe in Euro |

## Installation

1. Installiere [R](https://cran.r-project.org/).
2. Optional, aber empfohlen: Installiere RStudio Desktop.
3. Öffne RStudio und installiere einmal das Testpaket:

```r
install.packages("testthat")
```

## Ausführen

Öffne ein Terminal im Projektordner und führe aus:

```powershell
Rscript analysis.R
Rscript run_tests.R
```

Oder in RStudio: Öffne `analysis.R` und klicke auf **Source**. Danach öffne `run_tests.R` und klicke ebenfalls auf **Source**.

Im Ordner `output/` erscheinen danach das Balkendiagramm `average_premium_by_risk.png` und die bereinigte CSV-Datei `insurance_contracts_cleaned.csv`.

## Interaktive Shiny-Seite starten

Installiere einmal das Paket `shiny`:

```r
install.packages("shiny")
```

Danach kannst du die Anwendung starten:

```r
source("run_shiny.R")
```

Oder öffne `app.R` in RStudio und klicke oben rechts auf **Run App**. Die Anwendung zeigt die Kennzahlen, das Balkendiagramm und die gefilterten Verträge direkt in RStudio oder im Browser. Mit den Filtern kannst du Branche, Risikostufe und Mindestanzahl der Schäden auswählen.

## Was passiert in analysis.R?

1. Die CSV-Datei wird eingelesen.
2. `validate_contract_data()` prüft Spalten, Risikostufen und negative Werte.
3. Fehlende Geldwerte werden mit dem Median ersetzt. Der Median ist ein robuster mittlerer Wert.
4. Das Skript berechnet Durchschnittswerte und findet Verträge mit mehr als einem Schaden.
5. `calculate_risk_score()` erstellt eine einfache Kennzahl: low = 1, medium = 2, high = 3; dazu kommt die Anzahl der Schäden.
6. Ein Balkendiagramm wird gespeichert.

## Was sind Unit Tests?

Unit Tests prüfen kleine Teile des Codes automatisch. Dieses Projekt prüft:

- ob der Durchschnitt korrekt berechnet wird;
- ob fehlende Werte ignoriert werden;
- ob Text statt Zahlen abgelehnt wird;
- ob eine ungültige Risikostufe eine Fehlermeldung erzeugt;
- ob negative Prämien abgelehnt werden.

Dadurch kann man Code sicherer ändern: Nach jeder Änderung startet man die Tests erneut.

## Hinweis zur Risikokennzahl

Die Risikokennzahl ist bewusst nur ein Lernbeispiel und kein echtes Versicherungsmodell. Sie dient dazu, Datenverarbeitung, Validierung und getestete Funktionen in R zu demonstrieren.

## Nächster Lernschritt

Als nächstes kannst du mit `shiny` eine kleine Seite bauen, auf der man Branche und Risikostufe auswählt und eine Auswertung sieht. Danach könnte man mit `plumber` eine einfache API bereitstellen.
