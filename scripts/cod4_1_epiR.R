library(epiR)

# Tabla de contingencia clasica con la muestra (VP, FP, FN, VN)
frecuencias_observadas <- matrix(c(112, 148, 255, 985), nrow = 2, byrow = TRUE)

# Calculo automatico de Se, Sp, razones de verosimilitud y valores predictivos
analisis_clasico <- epi.tests(frecuencias_observadas, conf.level = 0.95)
print(analisis_clasico)
