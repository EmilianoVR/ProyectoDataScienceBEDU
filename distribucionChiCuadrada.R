# Instalar e cargar las librerías necesarias
library(moments)
# Cargar las librerías necesarias
library(tidyverse)

# Cargar la base de datos
ruta_archivo <- "C:/Users/Luiz/Downloads/stations_daily.csv/stations_daily.csv"
datos <- read.csv(ruta_archivo)

# Seleccionar las columnas de interés
variables_interes <- c("PM2.5", "PM10", "NOx", "O3", "CO", "HR", "NO", "NO2", "TMP")
datos_seleccionados <- datos[, c("datetime", "station_id", variables_interes)]

# Eliminar filas con valores NA en alguna de las variables
datos_seleccionados <- na.omit(datos_seleccionados)

# Realizar la prueba de chi-cuadrado para normalidad para cada columna
resultados_chi_cuadrado <- apply(datos[, variables_interes], 2, function(column) {
  # Limpiar los datos eliminando NA
  column <- na.omit(column)
  
  # Verificar si hay valores negativos en los datos
  if (any(column < 0)) {
    return(paste("Los datos de", names(column), "contienen valores negativos. La prueba de normalidad requiere datos no negativos."))
  }
  
  # Realizar la prueba de chi-cuadrado para normalidad
  prueba_chi_cuadrado <- chisq.test(column)
  
  # Imprimir los resultados de la prueba de chi-cuadrado
  cat(paste("Prueba de chi-cuadrado para normalidad en", names(column), ":\n"))
  print(prueba_chi_cuadrado)
  
  # Imprimir la decisión basada en el p-valor de la prueba de chi-cuadrado
  if (prueba_chi_cuadrado$p.value < 0.05) {
    return(paste("Los datos de", names(column), "no siguen una distribución normal según la prueba de chi-cuadrado."))
  } else {
    return(paste("No se puede rechazar la hipótesis de que los datos de", names(column), "siguen una distribución normal según la prueba de chi-cuadrado."))
  }
})

# Imprimir resultados generales
cat("\nResultados Generales:\n")
cat(resultados_chi_cuadrado, sep = "\n")
