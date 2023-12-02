# Realizar la prueba de bondad de ajuste a una distribución binomial y prueba de normalidad para cada variable
for (variable in variables_interes) {
  # Limpiar los datos eliminando NA
  variable_data <- datos[[variable]]
  variable_data <- na.omit(variable_data)
  
  # Verificar si hay valores negativos en los datos
  if (any(variable_data < 0)) {
    cat(paste("Los datos de", variable, "contienen valores negativos. La prueba binomial requiere datos no negativos.\n"))
    next()  # Salta a la siguiente iteración del bucle
  }
  
  # Verificar si hay 0 o todos los éxitos
  if (sum(variable_data) == 0 || sum(variable_data) == length(variable_data)) {
    cat(paste("No se puede realizar la prueba binomial para", variable, "cuando todos los valores son 0 o todos son éxitos.\n"))
    next()  # Salta a la siguiente iteración del bucle
  }

  
  if (is.integer(n_value) && n_value > x_value) {
    # Realizar la prueba de bondad de ajuste a una distribución binomial
    prueba_binomial <- binom.test(x_value, n_value, p = 0.5, alternative = "two.sided")
    
    # Imprimir los resultados de la prueba binomial
    cat(paste("Prueba de bondad de ajuste para", variable, " (Distribución Binomial):\n"))
    print(prueba_binomial)
    
    # Imprimir la decisión basada en el p-valor de la prueba binomial
    if (prueba_binomial$p.value < 0.05) {
      cat(paste("Los datos de", variable, "no siguen una distribución binomial.\n"))
    } else {
      cat(paste("No se puede rechazar la hipótesis de que los datos de", variable, "siguen una distribución binomial.\n"))
    }
    
    # Realizar la prueba de normalidad solo si el tamaño de la muestra es adecuado
    if (n_value >= 3 && n_value <= 5000) {
      prueba_normalidad <- shapiro.test(variable_data)
      
      # Imprimir los resultados de la prueba de normalidad
      cat(paste("Prueba de normalidad para", variable, ":\n"))
      print(prueba_normalidad)
      
      # Imprimir la decisión basada en el p-valor de la prueba de normalidad
      if (prueba_normalidad$p.value < 0.05) {
        cat(paste("Los datos de", variable, "no siguen una distribución normal.\n"))
      } else {
        cat(paste("No se puede rechazar la hipótesis de que los datos de", variable, "siguen una distribución normal.\n"))
      }
    } else {
      cat(paste("El tamaño de la muestra para", variable, "es grande, se omite la prueba de normalidad.\n"))
    }
  } else {
    cat(paste("No se puede realizar la prueba binomial para", variable, "ya que 'n' no es un entero positivo mayor o igual a 'x'.\n"))
  }
}


