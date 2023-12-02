# Cargar las librerías necesarias
library(shiny)
library(plotly)

# Leer tus datos (asegúrate de que df_combinado ya está cargado)
df_combinado <- read.csv("datos_combinados.csv")

# Verificar y convertir 'datetime' a tipo de dato de fecha y hora
if (!inherits(df_combinado$datetime, "POSIXct")) {
  df_combinado$datetime <- as.POSIXct(df_combinado$datetime, format = "%Y-%m-%d %H:%M:%S")
}

df_combinado$hour <- format(df_combinado$datetime, "%H")

# Crear la aplicación Shiny
shinyApp(
  ui = fluidPage(
    selectInput("estacion", "Seleccionar Estación", choices = unique(df_combinado$station_name)),
    plotlyOutput("heatmap")
  ),
  server = function(input, output) {
    output$heatmap <- renderPlotly({
      print("Entrando a renderPlotly")
      
      # Filtrar datos por estación seleccionada
      datos_estacion <- subset(df_combinado, station_name == input$estacion)
      
      print(paste("Número de filas después de filtrar:", nrow(datos_estacion)))
      
      # Verificar si hay datos después de filtrar
      if (nrow(datos_estacion) == 0) {
        print("No hay datos para la estación seleccionada")
        return(NULL)  # No hay datos para la estación seleccionada, no se puede crear el heatmap
      }
      
      # Verificar y convertir 'datetime' a tipo de dato de fecha y hora si es necesario
      if (!inherits(datos_estacion$datetime, "POSIXct")) {
        datos_estacion$datetime <- as.POSIXct(datos_estacion$datetime, format = "%Y-%m-%d %H:%M:%S")
      }
      
      # Extraer la hora
      datos_estacion$hour <- format(datos_estacion$datetime, "%H")
      
      print("Calculando el promedio por hora")
      
      # Calcular el promedio por hora
      datos_promedio <- aggregate(. ~ hour, data = datos_estacion, mean)
      
      print("Creando el heatmap")
      
      # Crear el heatmap
      heatmap <- plot_ly(
        datos_promedio,
        x = ~hour,
        y = colnames(datos_promedio)[2:ncol(datos_promedio)],  # Contaminantes en el eje Y
        z = ~datos_promedio[, 2:ncol(datos_promedio)],  # Datos de contaminantes
        type = "heatmap"
      ) %>%
        layout(
          title = paste("Heatmap de Promedio de Contaminantes para", input$estacion, "por Hora del Día"),
          xaxis = list(title = "Hora del Día"),
          yaxis = list(title = "Concentraciones")
        )
      
      print("Heatmap creado exitosamente")
      
      heatmap
    })
  }
)
