#=============================================
# MODELADO BAYESIANO DE HUI-WALTER SIN GOLD STANDARD
# APLICADO AL CRIBADO DE LA ENFERMEDAD DE ALZHEIMER EN EUROPA
#=============================================

if (!requireNamespace("rjags", quietly = TRUE)) {
  install.packages("rjags")
}
library(rjags)

# 1. Definicion de la matriz de datos reales (Tabla 2)
# Poblacion 1: Sur de Europa (p1 ~ 6.88%) 
# Poblacion 2: Norte de Europa (p2 ~ 4.31%)
y <- matrix(c(
  112, 255, 148, 985,  # Poblacion 1: Sur de Europa
  84,  258, 147, 1011  # Poblacion 2: Norte de Europa
), nrow = 2, byrow = TRUE)

N <- c(1500, 1500)
lista_datos <- list(y = y, N = N)

# 2. Formulacion del Modelo de Clases Latentes (Hui-Walter) en JAGS
modelo_hw_alzheimer <- "
model {
  for (i in 1:2) { # Iteracion sobre las dos subpoblaciones
    
    # Distribucion multinomial condicionada a las probabilidades de celda y N
    y[i, 1:4] ~ dmulti(prob[i, 1:4], N[i])
    
    # Distribucion a priori no informativa Beta(1,1) para la prevalencia latente
    p[i] ~ dbeta(1, 1)
    
    # Ecuaciones de Hui-Walter (probabilidades marginales de celda)
    # prob[i, 1] : Probabilidad de doble positivo (T1+, T2+)
    prob[i, 1] <- p[i] * Se[1] * Se[2] + (1 - p[i]) * (1 - Sp[1]) * (1 - Sp[2])
    
    # prob[i, 2] : Probabilidad de (T1+, T2-)
    prob[i, 2] <- p[i] * Se[1] * (1 - Se[2]) + (1 - p[i]) * (1 - Sp[1]) * Sp[2]
    
    # prob[i, 3] : Probabilidad de (T1-, T2+)
    prob[i, 3] <- p[i] * (1 - Se[1]) * Se[2] + (1 - p[i]) * Sp[1] * (1 - Sp[2])
    
    # prob[i, 4] : Probabilidad de doble negativo (T1-, T2-)
    prob[i, 4] <- p[i] * (1 - Se[1]) * (1 - Se[2]) + (1 - p[i]) * Sp[1] * Sp[2]
  }
  
  # Distribuciones a priori no informativas Beta(1,1) para la precisión de los tests
  # j = 1 representa al Test 1 (MMSE) 
  # j = 2 representa al Test 2 (CAMDEX)
  for (j in 1:2) {
    Se[j] ~ dbeta(1, 1) T(0.5, 1) # Fuerza a que la sensibilidad sea mayor del 50%
    Sp[j] ~ dbeta(1, 1) T(0.5, 1) # Fuerza a que la especificidad sea mayor del 50%
}   
}
"

# 3. Inicializacion, compilacion del modelo y fase de adaptacion
# Configuramos 3 cadenas independientes de Markov para monitorizar la convergencia
jags_compilado <- jags.model(
  file = textConnection(modelo_hw_alzheimer),
  data = lista_datos,
  n.chains = 3,
  n.adapt = 1000
)

# 4. Fase de descarte (Burn-in)
# Descartamos las primeras 5,000 muestras para estabilizar el algoritmo MCMC
update(jags_compilado, n.iter = 5000)

# 5. Muestreo de la distribucion a posteriori (Simulación MCMC)
muestras_posteriori <- coda.samples(
  model = jags_compilado,
  variable.names = c("p", "Se", "Sp"),
  n.iter = 20000
)

# 6. Resumen numerico de la distribución posterior
summary(muestras_posteriori)

# 7. Creamos las figuras 5.2 y 5.3

# Figura 5.3: Modelo CORREGIDO 
pdf("fig_5_3_restringido.pdf", width = 9, height = 4)
plot(muestras_posteriori[, "Se[1]"])
dev.off()

# Figura 5.2: Modelo SIN la restriccion T(0.5,1) 
modelo_hw_sin_restriccion <- "
model {
  for (i in 1:2) {
    y[i, 1:4] ~ dmulti(prob[i, 1:4], N[i])
    p[i] ~ dbeta(1, 1)
    prob[i, 1] <- p[i]*Se[1]*Se[2]         + (1-p[i])*(1-Sp[1])*(1-Sp[2])
    prob[i, 2] <- p[i]*Se[1]*(1-Se[2])     + (1-p[i])*(1-Sp[1])*Sp[2]
    prob[i, 3] <- p[i]*(1-Se[1])*Se[2]     + (1-p[i])*Sp[1]*(1-Sp[2])
    prob[i, 4] <- p[i]*(1-Se[1])*(1-Se[2]) + (1-p[i])*Sp[1]*Sp[2]
  }
  for (j in 1:2) {
    Se[j] ~ dbeta(1, 1)   # SIN truncar: reaparece el label switching
    Sp[j] ~ dbeta(1, 1)
  }
}
"

jags_sin <- jags.model(
  file = textConnection(modelo_hw_sin_restriccion),
  data = lista_datos, n.chains = 3, n.adapt = 1000
)
update(jags_sin, n.iter = 5000)   # mismo burn-in que el modelo principal

muestras_sin <- coda.samples(
  model = jags_sin,
  variable.names = c("p", "Se", "Sp"),
  n.iter = 20000
)

pdf("fig_5_2_sin_restriccion.pdf", width = 9, height = 4)
plot(muestras_sin[, "Se[1]"])
dev.off()
