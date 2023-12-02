# Cargar la base de datos
ruta_archivo <- "C:/Users/Luiz/Downloads/stations_daily.csv/stations_daily.csv"
datos <- read.csv(ruta_archivo)

# Seleccionar las columnas de interés
variables_interes <- c("PM2.5", "PM10", "NOx", "O3", "CO", "HR", "NO", "NO2", "TMP")

# Almacenar los resultados de las pruebas
resultados_pruebas <- data.frame(Variable = character(), p_valor = numeric(), stringsAsFactors = FALSE)

# Realizar pruebas para cada columna
for (variable in variables_interes) {
  cat("\nAnálisis para la variable:", variable, "\n")
  
  # Limpiar los datos eliminando NA
  datos_variable <- datos[, c("datetime", "station_id", variable)]
  datos_variable <- na.omit(datos_variable)
  variable_data <- datos_variable[[variable]]
  
  # Prueba del límite central
  t_test_result <- t.test(variable_data)
  
  # Almacenar los resultados
  resultados_pruebas <- rbind(resultados_pruebas, data.frame(Variable = variable, p_valor = t_test_result$p.value, stringsAsFactors = FALSE))
}

# Mezclar los resultados
mezcla_resultados <- sample(resultados_pruebas$Variable)
mezcla_resultados <- unique(mezcla_resultados)

# Imprimir resultados
cat("\nResultados de las pruebas individuales:\n")
print(resultados_pruebas)

cat("\nMezcla de los resultados:\n")
print(mezcla_resultados)
