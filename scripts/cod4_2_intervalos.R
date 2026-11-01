library(binom)      # binom.confint calcula los IC por distintos metodos

# Conteos de la tabla de contingencia del Codigo 4.1
VP <- 112; FP <- 148; FN <- 255; VN <- 985
n1 <- VP + FN       # total de enfermos (denominador de la Se)
n0 <- VN + FP       # total de sanos (denominador de la Sp)

# IC del 95% para la Se: asymptotic = Wald (2.13), wilson = Wilson (2.14), ac = Agresti-Coull (2.15), exact = Clopper-Pearson (2.16)
binom.confint(VP, n1, conf.level = 0.95, methods = c("asymptotic", "wilson", "ac", "exact"))

# IC del 95% para la Sp con los mismos cuatro metodos
binom.confint(VN, n0, conf.level = 0.95, methods = c("asymptotic", "wilson", "ac", "exact"))
