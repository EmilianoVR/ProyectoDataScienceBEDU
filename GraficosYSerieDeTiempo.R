# Cargar los paquetes
library(shiny)
library(ggplot2)
library(dplyr)
library(lubridate)

# Cargar los datos
stations_daily <- read.csv("stations_daily.csv")
stations_rsinaica <- read.csv("stations_rsinaica.csv")

# Crear la aplicación Shiny
ui <- fluidPage(
  titlePanel("Gráficos y Series de Tiempo"),
  sidebarLayout(
    sidebarPanel(
      # Selección de estación
      selectInput("station", "Selecciona una estación:",
                  choices = unique(stations_rsinaica$station_name),
                  selected = NULL)
    ),
    mainPanel(
      plotOutput("time_series_plot")
    )
  )
)

server <- function(input, output) {
  # Filtrar datos según la estación seleccionada
  selected_station_data <- reactive({
    filter(stations_daily, station_id == stations_rsinaica$station_id[stations_rsinaica$station_name == input$station])
  })
  
  # Generar serie de tiempo
  output$time_series_plot <- renderPlot({
    # Verificar si hay datos disponibles
    if (nrow(selected_station_data()) == 0) {
      # Mostrar mensaje de datos insuficientes
      message <- "Datos insuficientes para la estación seleccionada."
      plot(1, type = "n", axes = FALSE, xlab = "", ylab = "")
      text(1, 1, message, cex = 1.5, col = "red", font = 2)
    } else {
      # Crear la serie de tiempo para varios contaminantes
      ggplot(selected_station_data(), aes(x = as.POSIXct(datetime))) +
        geom_line(aes(y = PM10, color = "PM10"), na.rm = TRUE) +
        geom_line(aes(y = NOx, color = "NOx"), na.rm = TRUE) +
        geom_line(aes(y = O3, color = "O3"), na.rm = TRUE) +
        geom_line(aes(y = CO, color = "CO"), na.rm = TRUE) +
        geom_line(aes(y = HR, color = "HR"), na.rm = TRUE) +
        geom_line(aes(y = NO, color = "NO"), na.rm = TRUE) +
        geom_line(aes(y = NO2, color = "NO2"), na.rm = TRUE) +
        labs(title = paste("Serie de Tiempo para la Estación", input$station),
             x = "Fecha y Hora",
             y = "Concentración") +
        theme_minimal() +
        scale_color_manual(values = c("PM10" = "red", "NOx" = "blue", "O3" = "green",
                                      "CO" = "purple", "HR" = "orange", "NO" = "brown",
                                      "NO2" = "pink"))
    }
  })
}

shinyApp(ui, server)

