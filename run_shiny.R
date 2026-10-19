# Startet die interaktive Shiny-Seite.
if (!requireNamespace("shiny", quietly = TRUE)) {
  stop("Das Paket shiny fehlt. Bitte einmal ausführen: install.packages('shiny')")
}

shiny::runApp(".")
