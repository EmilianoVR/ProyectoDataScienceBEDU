# Cargar la base de datos
ruta_archivo <- "C:/Users/Luiz/Downloads/stations_daily.csv/stations_daily.csv"
datos <- read.csv(ruta_archivo)

# Seleccionar las columnas de interés
variables_interes <- c("PM2.5", "PM10", "NOx", "O3", "CO", "HR", "NO", "NO2", "TMP")

# Valor de referencia para el contraste de hipótesis
valor_referencia <- 0.5

# Realizar pruebas para cada columna
for (variable in variables_interes) {
  cat("\nAnálisis para la variable:", variable, "\n")
  
  # Limpiar los datos eliminando NA
  datos_variable <- datos[, c("datetime", "station_id", variable)]
  datos_variable <- na.omit(datos_variable)
  variable_data <- datos_variable[[variable]]
  
  # Realizar prueba de contraste de hipótesis
  t_test_result <- t.test(variable_data, mu = valor_referencia)
  
  # Imprimir resultados
  cat("Estadística t:", t_test_result$statistic, "\n")
  cat("Valor p:", t_test_result$p.value, "\n")
  
  # Tomar decisión basada en el valor p
  if (t_test_result$p.value < 0.05) {
    cat("Conclusión: Hay evidencia para rechazar la hipótesis nula.\n")
  } else {
    cat("Conclusión: No hay suficiente evidencia para rechazar la hipótesis nula.\n")
  }
}

