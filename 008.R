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
  
  # Convertir la columna datetime a formato de fecha
  datos_variable$datetime <- as.Date(datos_variable$datetime, format="%d/%m/%Y")
  
  # Verificar si hay valores faltantes en las fechas
  if (any(is.na(datos_variable$datetime))) {
    cat("Hay fechas no válidas en los datos.\n")
    
    # Imprimir las filas que contienen NA en la columna de fechas
    cat("Filas con fechas no válidas:\n")
    print(datos_variable[is.na(datos_variable$datetime), ])
    
    next  # Salir del bucle actual si hay fechas no válidas
  }
  
  # Establecer la columna datetime como el índice del marco de datos
  datos_variable <- datos_variable[!duplicated(datos_variable$datetime), ]
  rownames(datos_variable) <- datos_variable$datetime
  datos_variable <- datos_variable[, c("station_id", variable)]
  
  # Continuar con el análisis
  
  # ...
  
  # Realizar un gráfico de la serie temporal
  ggplot(datos_variable, aes(x = datetime, y = get(variable), group = 1)) +
    geom_line() +
    labs(title = paste("Serie Temporal de", variable),
         x = "Fecha",
         y = variable)
  
  # Prueba de estacionariedad (Dickey-Fuller)
  df_test <- adf.test(datos_variable[[variable]])
  cat("\nPrueba de estacionariedad (Dickey-Fuller):\n", df_test)
  
  # Decomposición de la serie temporal
  decomp <- decompose(ts(datos_variable[[variable]], frequency = 12))
  plot(decomp)
  
  # Autocorrelación y autocorrelación parcial
  acf_result <- acf(datos_variable[[variable]], main = paste("Autocorrelación de", variable))
  pacf_result <- pacf(datos_variable[[variable]], main = paste("Autocorrelación Parcial de", variable))
  
  # Modelo ARIMA
  arima_model <- auto.arima(datos_variable[[variable]])
  cat("\nModelo ARIMA:\n")
  summary(arima_model)
  
  # Predicción a futuro (ajustar según tus necesidades)
  future_steps <- 12  # por ejemplo, predicción de 12 pasos hacia el futuro
  forecast_values <- forecast(arima_model, h = future_steps)
  plot(forecast_values)
}



