
# Interactive Graphics for PCA in Matlab

---
Marco Riani, Anthony C. Atkinson & Aldo Corbellini & Domenico Perrotta
& Francesca Torti & Gianluca Morelli (2026) 
Interactive Graphics for PCA in Matlab, submitted.

# Abstract
Principal Component Analysis (PCA) is a fundamental tool for dimension
reduction and exploratory analysis of multivariate data, yet standard
implementations often provide limited support for interactive
visualization, robust inference, and integrated outlier detection. In
this paper we present a comprehensive set of MATLAB routines within the
FSDA (Flexible Statistics and Data Analysis) toolbox that extend
classical PCA through interactive and dynamic graphical methods, with
particular emphasis on biplots, robustness, and linked visualizations.
The proposed tools allow users to explore PCA results in two and three
dimensions, dynamically adjust biplot scaling parameters, visualize
confidence regions, and assess the impact of outliers using hard-trimming
approaches such as the Minimum Covariance Determinant and the Forward
Search. Brushing and linking techniques connect PCA representations with
scatter plot matrices and geographical maps, enabling substantive
interpretation of complex data structures. The methodology is illustrated
through an analysis of quality-of-life indicators for Italian provinces,
showing how interactive graphics reveal latent structure, geographical
patterns, and atypical observations that are difficult to detect using
static plots alone. The paper demonstrates how modern interactive
visualization substantially enhances the interpretability and robustness
of PCA analyses. We provide a publicly available and fully documented
interactive program for our procedure which is a robust form of
Tibshirani's AVAS that allows many forms of robust regression. We
illustrate the efficacy of our procedure through data analyses. A
refinement of the backfitting algorithm has interesting implications for
robust model selection.

# MATLAB Code

[Code to obtain the figures](https://github.com/UniprJRC/FSDApapers/blob/main/PCAinteractive/PCAfigures.m).




