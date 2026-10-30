# Estimación de parámetros de calidad de un test diagnóstico en ausencia de Gold Standard
Trabajo de Fin de Grado del Grado en Matemáticas de la Universidad de Granada, curso académico 2026/2027.

## Autora 
Marina Escañuela Hueso.

## Tutores
Miguel Ángel Montero Alonso y Juan Manuel Melchor Rodríguez.

## Descripción
Este repositorio reúne todo el código en R y los datos que acompañan a la memoria de mi TFG. El trabajo estudia cómo estimar la sensibilidad, la especificidad y la prevalencia de una prueba diagnóstica cuando no se dispone de un patrón de referencia perfecto (gold standard), siguiendo el paradigma de Hui-Walter desde las dos grandes perspectivas de la inferencia estadística, la frecuentista, con el algoritmo EM, y la bayesiana, con simulación MCMC en JAGS. La idea de este repositorio es que cualquier resultado que aparece en la memoria se pueda reproducir ejecutando estos scripts.

## Requisitos
El código está pensado para R (probado con la versión 4.5.3). Será necesario instalar los siguientes paquetes, todos disponibles en CRAN con install.packages("..."): poLCA, PVBcorrect, epiR, binom, pROC, OptimalCutpoints, rjags, coda, bayesplot y ggplot2.

Un detalle a tener en cuenta es que los dos scripts bayesianos (A3 y A5) utilizan rjags, que no es más que el enlace entre R y JAGS, un programa independiente que hay que instalar aparte en el sistema operativo. Se descarga de la web oficial, en mcmc-jags.sourceforge.io, y debe instalarse antes que el paquete de R; si no library(rjags) falla aunque el script esté bien escrito.

## Estructura
scripts/ contiene los códigos, numerados igual que en la memoria para facilitar su localización en el texto. Los cuatro primeros corresponden al capítulo 4 (software) y los cinco siguientes al apéndice.

En data/ encontramos las dos matrices de frecuencias que usan los modelos, la simulada de la Tabla 5.1 y la del cribado europeo de Alzheimer de la Tabla 5.3.

## Reproducibilidad
Los resultados numéricos son reproducibles gracias a las semillas fijadas (set.seed(123) en las simulaciones). En los modelos bayesianos, al tratarse de una simulación estocástica, las cifras exactas pueden variar mínimamente de una ejecución a otra y según la versión de R o de JAGS, sin que esto altere las conclusiones.
