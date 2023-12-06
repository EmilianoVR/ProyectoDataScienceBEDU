library(shiny)
library(DT)
library(ggplot2)
library(leaflet) 

# Variables que se cargarán únicamente
variables_interes <- c("datetime", "station_id", "PM2.5", "PM10", "NOx", "O3", "CO", "HR", "NO", "NO2", "TMP")

# Referencia para usar info de los diccionarios 
source("data/dict_info.R")

# Se lee el archivo CSV especificando los nombres y tipos de las columnas para crear correctamente el objeto
datos_original <- read.csv("data/stations_daily.csv", encoding = "UTF-8")
datos <- datos_original[, variables_interes] #Se especifica especificamente cuales se usarán

station_id <- datos$station_id

# Conversión de values de datetime a formato date
datos$datetime <- as.Date(datos$datetime)

# Ordenar los datos por la columna datetime
datos_fecha <- datos[order(datos$datetime), ]
print(head(datos_fecha))

# Elimina duplicados y crea una lista
station <- unique(station_id)

#----CSV ESTACIONES
datos_station <- read.csv("data/stations_rsinaica_clean.csv", encoding = "UTF-8")

#----CSV HOURLY
# datos_hourly <- read.csv("C:/Users/980025550/Documents/cdmxStation/stationsHourly/data/stations_hourly_clean.csv", encoding="UTF-8")

# Aquí se define la lógica del servidor
server <- function(input, output) {
  
  # Aquí se renderiza la tabla de datos TAB1
  output$tableData <- DT::renderDT({ # Los dos puntos son para especificar paqueteria::función 
    subset_table <- datos[, input$columns, drop = F]
    datatable(subset_table, options = list(autoWidth = TRUE))
  })
  
  # TAB2 Lógica para crear el mapa 
  
  output$map <- renderLeaflet({
    mymap <- leaflet() %>% addTiles()
    
    mymap <- mymap %>% 
      addMarkers(
        data = datos_station,
        lng = ~lon,
        lat = ~lat,
        popup = ~paste("Station ID: ", station_id, "<br>Station Name: ", station_name)
      )
    mymap
  })
  
  # TAB3 Render información
  output$gas_info_render <- renderText({
    paste(dict_gas[[input$gas_select]]$info)
  })
  
  # TAB3 Lógica gráfica de progresión de tiempo 
  output$timePlot <- renderPlot({
    ggplot(datos_fecha, aes(x = datetime, y = datos_fecha[[input$gas_select]])) +
    labs(x = "Tiempo",
         y = input$gas_select) +
      geom_line() +
      coord_cartesian(xlim = c(input$timeSlide[1], input$timeSlide[2]))  +
      scale_y_continuous(limits = c(0, dict_gas[[input$gas_select]]$concent))
  })
  
  # TAB4 Lógica para los histogramas
  output$histPlot <- renderPlot({
    histogram <- ggplot(datos_fecha, aes(x = datos_fecha[[input$gas_select_2]])) +
      geom_histogram(bins = input$binsHist, fill = "#ff6029", color = "black") +
      labs(title = paste("Histograma del nivel de ", input$gas_select_2),
           x = paste("Niveles de ", input$gas_select_2),
           y = "Frecuencia") +
      theme_minimal() +
      xlim(min(datos_fecha[[input$gas_select_2]]), dict_gas[[input$gas_select_2]]$concent)
    
    print(histogram)
  })
  
}