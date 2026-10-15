library(OptimalCutpoints)

set.seed(123) # Aseguramos la replicabilidad de la muestra simulada

n_sanos    <- 1000
n_enfermos <- 1000

diam_sanos    <- rnorm(n_sanos,    mean = 7.5, sd = 0.2)
diam_enfermos <- rnorm(n_enfermos, mean = 8.5, sd = 0.6)

datos_clinicos <- data.frame(
  marcador = c(diam_sanos, diam_enfermos),
  estado = factor(c(rep("Sano", 1000), rep("Enfermo", 1000)))
)

# Penalizacion asimetrica: un Falso Negativo es 10 veces mas grave que un Falso Positivo
coste_fp <- 1
coste_fn <- 10

# Optimizamos el corte minimizando el coste esperado de clasificacion (MCT)
punto_optimo <- optimal.cutpoints(
  X = "marcador", 
  status = "estado",
  tag.healthy = "Sano", 
  methods = "MCT", 
  data = datos_clinicos,
  control = control.cutpoints(CFP = coste_fp, CFN = coste_fn)
)

summary(punto_optimo) # Tabla resumen con el umbral M y metricas resultantes
plot(punto_optimo)    # Graficacion de la curva con la localizacion del corte optimo
