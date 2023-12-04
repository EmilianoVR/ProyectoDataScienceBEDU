#Aplicaremos el modelo para revisar si alguna de las variables contaminantes se ven afectadas con 
#el aumento de la temperatura en donde se usara la variable TMPÍ(como temperatura) y PM2.5(como contaminante)

#importamos la libreria que vamos usar
library(ggplot2)
#indicamos la direccionde  la carpeta para hacer uso del archivo
setwd("C:/Users/hackm/OneDrive - Universidad Autonoma de Coahuila/Data Science/BEDU/M5.Programacion y estadistica con R- Remoto Masivo 2022/ProyectFinal/contaminacion mexico")
#leemos el archivo y lo metemos en una variable
stations_daily <- read.csv("stations_daily.csv", header = TRUE)
#mostramos las columnas del archivo csv
head(stations_daily)

#revisamos tener los datos a trabajar en el mismo formato de forma correcta
stations_daily$PM2.5 <- as.numeric(stations_daily$PM2.5)
stations_daily$TMPI <- as.numeric(stations_daily$TMPI)

#eliminamos los valores nulos de ambas variables en sus respectivas filas
datos_filtrados <- na.omit(stations_daily[c('PM2.5', 'TMPI')])

#creamos el modelos para la regresion libeal con las variables
modelo <- lm(PM2.5 ~ TMPI, data = datos_filtrados)

#mostrar resumen del modelo
summary(modelo)

#Creamos un grafico  de dispercion con la linea de regresion
ggplot(datos_filtrados, aes(x = TMPI, y = PM2.5)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Relación entre PM2.5 y Temperatura (TMPI)",
       x = "Temperatura (TMPI)", y = "PM2.5")
#conclusion a mayor temperatura mas aumenta el indice de PM2.5
#como podemos ver el coeficiente de correlacion es de 0.78 dando como
#resultado una relacion entre ambas varianbles, al igual se sugiere
#la revision de datos debido a una gran presencia de valores atipícos 
#es por eso que se sugiere la revision de los datos o mayor limpieza antes
#de realizar la regresion

#Grafico diagnostico r para verificar suposisiones
par(mfrow = c(2,2))
plot(modelo)
#clasificacion
suppressMessages(suppressWarnings(library(dplyr))) 
library(e1071) 
plot(datos_filtrados$TMPI, datos_filtrados$`PM2.5`, xlab = "Temperatura (TMPI)", ylab = "PM2.5", pch = 16)
#Convertimos la matriz de datos a data frame y convertimos la columna y a factor:
dat <- as.data.frame(datos_filtrados)
dat <- dat %>% mutate(y = factor(PM2.5))
tail(dat)

#Ajustamos el clasificador de vectores de soporte con la función svm
svmfit <- svm(y~., data = dat, kernel = "linear", 
              cost = 10, scale = TRUE, max_iter=100000)

