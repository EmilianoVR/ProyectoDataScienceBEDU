library(shiny)
library(ggplot2)
library(dplyr)
library(lubridate)

stations_daily <- read.csv("stations_daily.csv")
stations_rsinaica <- read.csv("stations_rsinaica.csv")


perform_regression_analysis <- function(station) {
  selected_data <- stations_daily %>%
    filter(station_id %in% stations_rsinaica$station_id[stations_rsinaica$station_name == station]) %>%
    select(datetime, PM2.5) %>%
    na.omit()
  

  if (nrow(selected_data) > 1) {
    fit <- lm("PM2.5 ~ datetime", data = selected_data)
    
    result <- data.frame(
      Station = station,
      Contaminant = "PM2.5",
      Coefficient = summary(fit)$coefficients[2, 1],
      P_Value = summary(fit)$coefficients[2, 4]
    )
    
    return(result)
  } else {
    return(NULL)  
  }
}

results_list <- lapply(unique(stations_rsinaica$station_name), function(station) {
  perform_regression_analysis(station)
})


results_df <- do.call(rbind, lapply(Filter(Negate(is.null), results_list), data.frame))


ui <- fluidPage(
  titlePanel("Resultados del Análisis de Regresión para PM2.5"),
  mainPanel(
    textOutput("regression_results")
  )
)

server <- function(input, output) {
  output$regression_results <- renderText({
    if (nrow(results_df) > 0) {
      paste(capture.output(print(results_df)), collapse = '\n')
    } else {
      "No hay suficientes datos para realizar el análisis de regresión para PM2.5."
    }
  })
}

shinyApp(ui, server)


