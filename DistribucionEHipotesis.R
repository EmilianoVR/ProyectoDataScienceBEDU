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
      plotOutput("time_series_plot"),
      textOutput("normality_result")  # Agregado para mostrar resultados de normalidad
    )
  )
)

# Función para realizar la prueba de normalidad
perform_shapiro_test <- function(column) {
  if (is.numeric(column) && length(unique(column)) > 1) {
    shapiro_test_result <- shapiro.test(na.omit(column))
    return(shapiro_test_result$p.value)
  } else {
    return(NA)
  }
}

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
        geom_line(aes(y = PM2.5, color = "PM2.5"), na.rm = TRUE) +  # Agregado PM2.5
        labs(title = paste("Serie de Tiempo para la Estación", input$station),
             x = "Fecha y Hora",
             y = "Concentración") +
        theme_minimal() +
        scale_color_manual(values = c("PM10" = "red", "NOx" = "blue", "O3" = "green",
                                      "CO" = "purple", "HR" = "orange", "NO" = "brown",
                                      "NO2" = "pink", "PM2.5" = "black"))  # Agregado PM2.5
    }
  })
  
  # Realizar prueba de normalidad y mostrar resultado
  output$normality_result <- renderText({
    # Obtener datos numéricos para realizar la prueba de normalidad
    numeric_data <- sapply(selected_station_data(), function(x) perform_shapiro_test(x))
    
    # Mostrar resultados de normalidad
    paste("Resultados de la prueba de Shapiro-Wilk:",
          ifelse(all(numeric_data > 0.05), "Todos los contaminantes siguen una distribución normal.", "Al menos un contaminante no sigue una distribución normal."))
  })
}

shinyApp(ui, server)

