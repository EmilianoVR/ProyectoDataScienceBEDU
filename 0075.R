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
  
  # Crear un boxplot
  boxplot_result <- boxplot(datos_variable[[variable]], 
                            main = paste("Boxplot de", variable),
                            ylab = variable,
                            col = "skyblue",
                            border = "black",
                            notch = TRUE)
  
  # Identificar y visualizar outliers
  outliers <- boxplot_result$out
  points(outliers, rep(1, length(outliers)), pch = 16, col = "red")
  
  # Puedes ajustar más opciones del boxplot y de los puntos de outliers según tus necesidades
  
  # Esperar a que el usuario haga clic para continuar con la siguiente variable
  cat("\nPresiona Enter para continuar con la siguiente variable...\n")
  readline()
}

