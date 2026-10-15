> auc(curva_roc)
Area under the curve: 0.9432
> # Buscamos el umbral óptimo (M) maximizando el índice de Youden
> coords(curva_roc, x = "best", best.method = "youden",
+        ret = c("threshold", "specificity", "sensitivity"))
  threshold specificity sensitivity
1  7.834607       0.949       0.871
2  7.835825       0.950       0.870
3  7.836889       0.951       0.869
4  7.837633       0.952       0.868
