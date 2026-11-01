library(epiR)

# Tabla de contingencia clasica con la muestra (VP, FP, FN, VN)
frecuencias_observadas <- matrix(c(112, 148, 255, 985), nrow = 2, byrow = TRUE)

# epi.tests devuelve Se, Sp, valores predictivos y razones de verosimilitud
analisis_clasico <- epi.tests(frecuencias_observadas, conf.level = 0.95)
print(analisis_clasico)
