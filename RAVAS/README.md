
# The Box-Cox Transformation: Review and Extensions

---
Marco Riani, Anthony C. Atkinson & Aldo Corbellini (2023) Robust Transformations for Multiple Regression via Additivity and Variance Stabilization, Journal of Computational and Graphical Statistics, DOI: 10.1080/10618600.2023.2205447

# Abstract
Outliers can have a major effect on the estimated transformation of the response in linear regression models, as they can on the estimates of the coefficients of the fitted model. The effect is more extreme in the Generalized Additive Models (GAMs) that are the subject of this paper, as the forms of terms in the model can also be affected. We develop, describe and illustrate robust methods for the non-parametric transformation of the response and estimation of the terms in the model. Numerical integration is used to calculate the estimated variance stabilizing transformation. Robust regression provides outlier free input to the polynomial smoothers used in the calculation of the response transformation and in the backfitting algorithm for estimation of the functions of the GAM. Our starting point was the AVAS (Additivity and VAriance Stabilization) algorithm of Tibshirani. Even if robustness is not required, we have made four further general optional improvements to AVAS which greatly improve the performance of Tibshirani’s original Fortran program.

We provide a publicly available and fully documented interactive program for our procedure which is a robust form of Tibshirani’s AVAS that allows many forms of robust regression. We illustrate the efficacy of our procedure through data analyses. A refinement of the backfitting algorithm has interesting implications for robust model selection.

# MATLAB Code

[Code to obtain the figures](https://github.com/UniprJRC/FSDApapers/blob/main/RAVAS/avasfigures.m).




