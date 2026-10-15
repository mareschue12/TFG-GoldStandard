library(binom)                      # Proporciona binom.confint con varios metodos de IC

# Recuperamos los conteos de la tabla de contingencia del Codigo 4.1
VP <- 112; FP <- 148; FN <- 255; VN <- 985
n1 <- VP + FN                       # Enfermos reales: base muestral de la sensibilidad
n0 <- VN + FP                       # Sanos reales: base muestral de la especificidad

# IC del 95% para la Se: asymptotic = Wald (2.13), wilson = Wilson (2.14), exact = Clopper-Pearson (2.15)
binom.confint(VP, n1, conf.level = 0.95, methods = c("asymptotic", "wilson", "exact"))

# IC del 95% para la Sp con los mismos tres metodos
binom.confint(VN, n0, conf.level = 0.95, methods = c("asymptotic", "wilson", "exact"))
