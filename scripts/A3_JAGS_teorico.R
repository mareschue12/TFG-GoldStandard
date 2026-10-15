library(rjags)

# Definimos el modelo de Hui-Walter en JAGS
modelo_hui_walter <- "
model {
  for (i in 1:2) { # Iteracion sobre las dos subpoblaciones epidemiologicas

    # y: matriz de frecuencias para los 4 perfiles observables
    y[i, 1:4] ~ dmulti(prob[i, 1:4], N[i])

    # Prior Beta no informativo para la prevalencia latente de cada poblacion
    p[i] ~ dbeta(1, 1)

    # Sistema de Hui-Walter: probabilidades teoricas condicionales de celda
    prob[i, 1] <- p[i]*Se[1]*Se[2]         + (1-p[i])*(1-Sp[1])*(1-Sp[2]) # (T1+, T2+)
    prob[i, 2] <- p[i]*Se[1]*(1-Se[2])     + (1-p[i])*(1-Sp[1])*Sp[2]     # (T1+, T2-)
    prob[i, 3] <- p[i]*(1-Se[1])*Se[2]     + (1-p[i])*Sp[1]*(1-Sp[2])     # (T1-, T2+)
    prob[i, 4] <- p[i]*(1-Se[1])*(1-Se[2]) + (1-p[i])*Sp[1]*Sp[2]         # (T1-, T2-)
  }

  # Prioris Beta(1,1) para sensibilidad y especificidad de cada test.
  # La restriccion T(0.5, 1) corrige la bimodalidad por label switching.
  for (j in 1:2) {
    Se[j] ~ dbeta(1, 1) T(0.5, 1) # Fuerza Se > 50%
    Sp[j] ~ dbeta(1, 1) T(0.5, 1) # Fuerza Sp > 50%
  }
}
"

# Matriz de frecuencias de dos poblaciones en los 4 casos [++, +-, -+, --] (reutilizamos los datos simulados de la Tabla 5.1)
y <- matrix(c(384, 199,  70, 347,       # Poblacion 1
              152, 227,  42, 579),      # Poblacion 2
            nrow = 2, byrow = TRUE)

N <- c(1000, 1000)      # Tamaño muestral de cada poblacion
lista_datos <- list(y = y, N = N)     # Lista que recibe JAGS

# Compilamos el modelo en JAGS inicializando 3 cadenas paralelas para control de convergencia
jags_modelo <- jags.model(
  file = textConnection(modelo_hui_walter),
  data = lista_datos,
  n.chains = 3
)

# Burn-in: descartamos 5,000 iteraciones iniciales para disipar el efecto de los valores semilla
update(jags_modelo, 5000)

# Simulamos 50,000 iteraciones para dibujar las distribuciones a posteriori de los parametros
muestras_post <- coda.samples(
  model = jags_modelo,
  variable.names = c("Se", "Sp", "p"),
  n.iter = 50000
)

# Resumen de estimaciones (mediana, desv. tipica) e intervalos de credibilidad del 95%
summary(muestras_post)
