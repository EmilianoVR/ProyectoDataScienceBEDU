# Cargar la librería ggplot2
library(ggplot2)

# Cargar la base de datos
ruta_archivo <- "C:/Users/Luiz/Downloads/stations_daily.csv/stations_daily.csv"
datos <- read.csv(ruta_archivo)

# Seleccionar las columnas de interés
variables_interes <- c("PM2.5", "PM10", "NOx", "O3", "CO", "HR", "NO", "NO2", "TMP")

# Realizar pruebas para cada columna
for (variable in variables_interes) {
  cat("\nAnálisis para la variable:", variable, "\n")
  
  # Limpiar los datos eliminando NA
  datos_variable <- datos[, c("datetime", "station_id", variable)]
  datos_variable <- na.omit(datos_variable)
  
  # Comprobar si hay datos después de la limpieza
  if (nrow(datos_variable) > 0) {
    variable_data <- datos_variable[[variable]]
    
    # Crear gráfico de dispersión
    scatter_plot <- ggplot(datos_variable, aes(x = datetime, y = variable_data)) +
      geom_point() +
      labs(title = paste("Scatter Plot de", variable),
           x = "Fecha y Hora",
           y = variable) +
      theme_minimal()
    
    # Crear histograma
    histogram <- ggplot(datos_variable, aes(x = variable_data)) +
      geom_histogram(binwidth = 0.001, fill = "blue", color = "black") +  # Ajustar binwidth según necesidades
      labs(title = paste("Histograma de", variable),
           x = variable,
           y = "Frecuencia") +
      theme_minimal() +
      xlim(0, 0.1)  # Establecer límites del eje x
    
    # Imprimir los gráficos
    print(scatter_plot)
    print(histogram)
  } else {
    cat("No hay datos disponibles para", variable, "\n")
  }
}
