library(poLCA)               # Paquete para el analisis de clases latentes por EM

set.seed(123)                # Aseguramos la replicabilidad de la simulacion

# Parametros verdaderos que el modelo debera recuperar sin conocerlos
N  <- 2000                   # Tamaño de la muestra
p  <- 0.30                   # Prevalencia latente: P(enfermo)
Se <- c(0.90, 0.85, 0.80)    # Sensibilidades verdaderas de T1, T2 y T3
Sp <- c(0.95, 0.90, 0.85)    # Especificidades verdaderas de T1, T2 y T3

# Simulamos el estado de salud latente D (la verdad oculta, no observable)
D <- rbinom(N, 1, p)         # D = 1 enfermo, D = 0 sano

# Generamos cada test condicionado a D: positivo con prob. Se si enfermo, 1 - Sp si sano
T1 <- rbinom(N, 1, ifelse(D == 1, Se[1], 1 - Sp[1]))
T2 <- rbinom(N, 1, ifelse(D == 1, Se[2], 1 - Sp[2]))
T3 <- rbinom(N, 1, ifelse(D == 1, Se[3], 1 - Sp[3]))

# poLCA exige niveles 1/2 en lugar de 0/1: 1 = negativo, 2 = positivo. D no se incluye
datos <- data.frame(T1 = T1 + 1, T2 = T2 + 1, T3 = T3 + 1)

# Ajuste del modelo de 2 clases latentes (enfermo / sano) mediante el algoritmo EM
# nrep = 10 reinicia el EM en 10 puntos distintos para evitar maximos locales
modelo <- poLCA(cbind(T1, T2, T3) ~ 1, data = datos,
                nclass = 2, maxiter = 1000, tol = 1e-7, nrep = 10)

print(modelo)          # Resumen del ajuste
modelo$P               # Prevalencias estimadas de cada clase latente
modelo$probs           # Probabilidades por clase (de donde se leen Se y Sp)
