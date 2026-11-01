set.seed(123) # Semilla

# Parametros teoricos reales del escenario controlado
N1 <- 1000; N2 <- 1000
p1_true <- 0.50; p2_true <- 0.20
Se1_true <- 0.90; Sp1_true <- 0.75
Se2_true <- 0.85; Sp2_true <- 0.95

# Funcion que simula una poblacion y cuenta sus 4 perfiles
generar_frecuencias <- function(N, p, Se1, Sp1, Se2, Sp2) {
  estado_real <- rbinom(N, size = 1, prob = p)
  
  # Test 1 condicionado al estado real
  t1 <- ifelse(estado_real == 1, 
               rbinom(N, 1, prob = Se1),      # Verdaderos Positivos
               rbinom(N, 1, prob = 1 - Sp1))  # Falsos Positivos
  
  # Comportamiento del Test 2 condicionado al estado latente
  t2 <- ifelse(estado_real == 1, 
               rbinom(N, 1, prob = Se2), 
               rbinom(N, 1, prob = 1 - Sp2))
  
  # Contamos los 4 perfiles observables
  frecuencias <- c(
    sum(t1 == 1 & t2 == 1), # Doble positivo [T1+, T2+]
    sum(t1 == 1 & t2 == 0), # Conflicto [T1+, T2-]
    sum(t1 == 0 & t2 == 1), # Conflicto [T1-, T2+]
    sum(t1 == 0 & t2 == 0)  # Doble negativo [T1-, T2-]
  )
  return(frecuencias)
}

# Juntamos las dos poblaciones en la matriz final
matriz_y_simulada <- matrix(c(
  generar_frecuencias(N1, p1_true, Se1_true, Sp1_true, Se2_true, Sp2_true),
  generar_frecuencias(N2, p2_true, Se1_true, Sp1_true, Se2_true, Sp2_true)
), nrow = 2, byrow = TRUE)

colnames(matriz_y_simulada) <- c("[T1+, T2+]", "[T1+, T2-]", "[T1-, T2+]", "[T1-, T2-]")
rownames(matriz_y_simulada) <- c("Población 1", "Población 2")

print(matriz_y_simulada)
