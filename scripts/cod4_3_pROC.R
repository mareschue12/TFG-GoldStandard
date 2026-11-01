library(pROC)

set.seed(123)

n_sanos    <- 1000
n_enfermos <- 1000

diam_sanos    <- rnorm(n_sanos,    mean = 7.5, sd = 0.2)
diam_enfermos <- rnorm(n_enfermos, mean = 8.5, sd = 0.6)

estado_GS <- c(rep(0, n_sanos), rep(1, n_enfermos))

# diametro: Biomarcador continuo asociado a cada paciente
diametro  <- c(diam_sanos, diam_enfermos)

curva_roc <- roc(response = estado_GS, predictor = diametro)

# Area bajo la curva
auc(curva_roc)

# Corte optimo por el indice de Youden
coords(curva_roc, x = "best", best.method = "youden",
       ret = c("threshold", "specificity", "sensitivity"))
