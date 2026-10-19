# Interaktive Shiny-Seite für die Auswertung fiktiver Versicherungsdaten.

library(shiny)
source("R/pricing_functions.R")

# Daten einmal beim Start der Anwendung einlesen und bereinigen.
contracts <- read.csv("data/insurance_contracts.csv", stringsAsFactors = FALSE)
validate_contract_data(contracts)
contracts_clean <- clean_contract_data(contracts)
contracts_clean$risk_score <- mapply(
  calculate_risk_score,
  contracts_clean$risk_level,
  contracts_clean$claims_count
)

# Benutzeroberfläche: Das ist der sichtbare Teil der Anwendung.
ui <- fluidPage(
  titlePanel("Insurance Pricing Data Analysis"),
  sidebarLayout(
    sidebarPanel(
      h4("Filter"),
      selectInput(
        "industry", "Branche auswählen:",
        choices = c("Alle", sort(unique(contracts_clean$industry)))
      ),
      selectInput(
        "risk_level", "Risikostufe auswählen:",
        choices = c("Alle", "low", "medium", "high")
      ),
      sliderInput(
        "minimum_claims", "Mindestens so viele Schäden:",
        min = 0,
        max = max(contracts_clean$claims_count),
        value = 0,
        step = 1
      ),
      p("Alle Daten in dieser Anwendung sind fiktiv.")
    ),
    mainPanel(
      h3("Ergebnisse"),
      fluidRow(
        column(4, wellPanel(h4("Verträge"), textOutput("contract_count"))),
        column(4, wellPanel(h4("Durchschnittliche Prämie"), textOutput("average_premium"))),
        column(4, wellPanel(h4("Durchschnittliche Schäden"), textOutput("average_claims")))
      ),
      h3("Durchschnittliche Prämie nach Risikostufe"),
      plotOutput("premium_plot", height = "350px"),
      h3("Gefilterte Verträge"),
      tableOutput("contracts_table")
    )
  )
)

# Server: Das ist der unsichtbare Teil. Er verarbeitet Filter und Berechnungen.
server <- function(input, output) {
  filtered_contracts <- reactive({
    data <- contracts_clean

    if (input$industry != "Alle") {
      data <- data[data$industry == input$industry, ]
    }
    if (input$risk_level != "Alle") {
      data <- data[data$risk_level == input$risk_level, ]
    }

    data[data$claims_count >= input$minimum_claims, ]
  })

  output$contract_count <- renderText({
    paste(nrow(filtered_contracts()), "Verträge")
  })

  output$average_premium <- renderText({
    data <- filtered_contracts()
    if (nrow(data) == 0) return("Keine Daten")
    paste0(format(round(calculate_average_premium(data$annual_premium), 2), big.mark = "."), " €")
  })

  output$average_claims <- renderText({
    data <- filtered_contracts()
    if (nrow(data) == 0) return("Keine Daten")
    round(mean(data$claims_count), 2)
  })

  output$premium_plot <- renderPlot({
    data <- filtered_contracts()
    validate(need(nrow(data) > 0, "Für diese Filter gibt es keine Verträge."))

    result <- aggregate(annual_premium ~ risk_level, data = data, FUN = mean)
    barplot(
      result$annual_premium,
      names.arg = result$risk_level,
      col = c("#7FB3D5", "#F7DC6F", "#E59866"),
      main = "Durchschnittliche Jahresprämie nach Risikostufe",
      xlab = "Risikostufe",
      ylab = "Jahresprämie in Euro"
    )
  })

  output$contracts_table <- renderTable({
    data <- filtered_contracts()
    data[, c("contract_id", "industry", "region", "risk_level", "claims_count", "annual_premium", "claim_amount", "risk_score")]
  }, striped = TRUE, bordered = TRUE, spacing = "s")
}

shinyApp(ui = ui, server = server)
