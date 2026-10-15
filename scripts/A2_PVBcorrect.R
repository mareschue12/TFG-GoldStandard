library(PVBcorrect)

# Simulamos un escenario de verificación parcial donde:
# 'T' representa el resultado del test diagnóstico (0=Negativo, 1=Positivo)
# 'D' representa el estado clínico real por Gold Standard (0=Sano, 1=Enfermo, NA = no verificado)

set.seed(123)       # Reproducibilidad

N    <- 1000        # Tamaño de la muestra
prev <- 0.30        # Prevalencia real de la enfermedad
Se   <- 0.90        # Sensibilidad real del test indice
Sp   <- 0.70        # Especificidad real del test indice

# Estado de salud real (latente): 1 = Enfermo, 0 = Sano
enfermo_real <- rbinom(N, 1, prev)

# Resultado del test indice T, condicionado al estado real
test_T <- ifelse(enfermo_real == 1,
                 rbinom(N, 1, Se),
                 rbinom(N, 1, 1 - Sp))

# Mecanismo de verificacion parcial (MAR): Confirmamos con Gold Standard a casi todos los positivos y solo a una fraccion de los negativos
v1 <- 0.90      # prob. de verificar si T = 1
v0 <- 0.20      # prob. de verificar si T = 0
verificado <- rbinom(N, 1, ifelse(test_T == 1, v1, v0))

# D = Estado real del paciente verificado por Gold Standard, NA en el resto
D <- ifelse(verificado == 1, enfermo_real, NA)

# Data frame final: Columnas 'T' (test) y 'D' (diagnostico real, con NA)
datos_pvb <- data.frame(T = test_T, D = D)

# Visualizamos la tabla de verificación (opcional, útil para el informe)
view_table(data = datos_pvb, test = "T", disease = "D",
           show_unverified = TRUE, show_total = TRUE)

# 1) Corrección por el metodo de Begg y Greenes extendido (EBG):
# requiere bootstrap para el IC, por eso se fija semilla y número de réplicas

resultado_ebg <- acc_ebg(data = datos_pvb, test = "T", disease = "D",
                         ci = TRUE, ci_type = "bca",
                         seednum = 123, R = 999)
resultado_ebg$acc_results

# 2) Corrección mediante Imputación Múltiple (MI):
resultado_mi <- acc_mi(data = datos_pvb, test = "T", disease = "D",
                       ci = TRUE, seednum = 123, m = 10)
resultado_mi$acc_results
