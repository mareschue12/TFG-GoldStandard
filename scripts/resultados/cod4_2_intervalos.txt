> # IC del 95% para la Se: asymptotic = Wald (2.13), wilson = Wilson (2.14), exact = Clopper-Pearson (2.15)
> binom.confint(VP, n1, conf.level = 0.95, methods = c("asymptotic", "wilson", "exact"))
      method   x   n      mean     lower     upper
1 asymptotic 112 367 0.3051771 0.2580655 0.3522887
2      exact 112 367 0.3051771 0.2584421 0.3550883
3     wilson 112 367 0.3051771 0.2602848 0.3541056
> # IC del 95% para la Sp con los mismos tres metodos
> binom.confint(VN, n0, conf.level = 0.95, methods = c("asymptotic", "wilson", "exact"))
      method   x    n      mean     lower     upper
1 asymptotic 985 1133 0.8693733 0.8497509 0.8889957
2      exact 985 1133 0.8693733 0.8483481 0.8884583
3     wilson 985 1133 0.8693733 0.8484963 0.8877542
