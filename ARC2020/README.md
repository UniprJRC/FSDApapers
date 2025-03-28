
# The Analysis of Transformations for Profit-and-Loss Data

Anthony C. Atkinson, Marco Riani, Aldo Corbellini, The Analysis of Transformations for Profit-and-Loss Data, Journal of the Royal Statistical Society Series C: Applied Statistics, Volume 69, Issue 2, April 2020, Pages 251–275, https://doi.org/10.1111/rssc.12389

# Abstract
We analyse data on the performance of investment funds, 99 out of 309 of which report a loss, and on the profitability of 1405 firms, 407 of which report losses. The problem in both cases is to use regression to predict performance from sets of explanatory variables. In one case, it is clear from scatter plots of the data that the negative responses have a lower variance than the positive responses and a different relationship with the explanatory variables. Because the data include negative responses, the Box–Cox transformation cannot be used. We develop a robust version of an extension to the Yeo–Johnson transformation which allows different transformations for positive and negative responses. Tests and graphical methods from our robust analysis enable the detection of outliers, the assessment of values of the two transformation parameters and the building of simple regression models. Performance comparisons are made with non-parametric transformations

# MATLAB Code

The code which generates all the figures


Balance sheets dataset Figures. [Code](https://github.com/UniprJRC/FSDApapers/blob/main/ARC2020/figuresAR2019InvFunds.m).

Investment funds data Figures. [Code](https://github.com/UniprJRC/FSDApapers/blob/main/ARC2020/FiguresAR2019BalanceSheets.m).

Simulation study [Code](https://github.com/UniprJRC/FSDApapers/blob/main/ARC2020/simstudyAR2019.m).


