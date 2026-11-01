library(OptimalCutpoints)

set.seed(123) # Semilla para que la muestra salga siempre igual

n_sanos    <- 1000
n_enfermos <- 1000

diam_sanos    <- rnorm(n_sanos,    mean = 7.5, sd = 0.2)
diam_enfermos <- rnorm(n_enfermos, mean = 8.5, sd = 0.6)

datos_clinicos <- data.frame(
  marcador = c(diam_sanos, diam_enfermos),
  estado = factor(c(rep("Sano", 1000), rep("Enfermo", 1000)))
)

# Penalizacion asimetrica: Un falso negativo es 10 veces mas grave que un falso positivo
coste_fp <- 1
coste_fn <- 10

# Corte que minimiza el coste esperado (metodo MCT)
punto_optimo <- optimal.cutpoints(
  X = "marcador", 
  status = "estado",
  tag.healthy = "Sano", 
  methods = "MCT", 
  data = datos_clinicos,
  control = control.cutpoints(CFP = coste_fp, CFN = coste_fn)
)

summary(punto_optimo)   # Tabla resumen con el umbral M y metricas resultantes
plot(punto_optimo)      # Dibuja la curva con el corte marcado
