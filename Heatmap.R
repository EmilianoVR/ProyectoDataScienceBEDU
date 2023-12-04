# Instalar las bibliotecas necesarias si no están instaladas
# install.packages(c("shiny", "dplyr", "ggplot2"))

library(shiny)
library(dplyr)
library(ggplot2)

# Cargar datos
# Asegúrate de ajustar las rutas a los archivos
data_hourly <- read.csv("stations_hourly.csv")
data_rsinaica <- read.csv("stations_rsinaica.csv")

# Fusionar los conjuntos de datos
data <- merge(data_hourly, data_rsinaica, by = "station_id")

# UI
ui <- fluidPage(
  titlePanel("Heatmap de Contaminantes"),
  sidebarLayout(
    sidebarPanel(
      selectInput("station", "Seleccionar Estación:",
                  choices = unique(data$station_name)),
      selectInput("contaminant", "Seleccionar Contaminante:",
                  choices = c("PM2.5", "PM10", "NOx", "O3", "CO", "HR", "NO", "NO2"))
    ),
    mainPanel(
      plotOutput("heatmapPlot")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Filtrar datos según la selección del usuario
  filtered_data <- reactive({
    data %>%
      filter(station_name == input$station) %>%
      select(datetime, input$contaminant) %>%
      na.omit()
  })
  
  # Calcular el promedio por hora
  hourly_avg <- reactive({
    filtered_data() %>%
      mutate(hour = as.numeric(format(as.POSIXct(datetime), "%H"))) %>%
      group_by(hour) %>%
      summarise(avg_contaminant = mean(!!sym(input$contaminant), na.rm = TRUE))
  })
  
  # Crear el heatmap
  output$heatmapPlot <- renderPlot({
    ggplot(hourly_avg(), aes(x = hour, y = 1, fill = avg_contaminant)) +
      geom_tile() +
      scale_fill_viridis_c() +
      labs(title = paste("Promedio de", input$contaminant, "por Hora"),
           x = "Hora del Día",
           y = "") +
      theme_minimal()
  })
}

shinyApp(ui, server)
