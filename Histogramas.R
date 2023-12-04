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

# Crear un gráfico de barras para cada variable
par(mfrow = c(3, 3), mar = c(4, 4, 2, 1))  # Dividir la ventana gráfica en una cuadrícula 3x3

for (i in 1:length(variables_interes)) {
  # Seleccionar la variable actual
  variable_actual <- datos_seleccionados[, variables_interes[i]]
  
  # Crear un gráfico de barras
  barplot(table(variable_actual), main = variables_interes[i], xlab = variables_interes[i], ylab = "Frecuencia")
}

