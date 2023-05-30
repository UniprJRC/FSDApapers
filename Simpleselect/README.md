
# A practically efficient fixed-pivot selection algorithm and its extensible MATLAB suite

Azzini, I. and Perrotta, D and Torti, F. A practically efficient fixed-pivot selection algorithm and its extensible MATLAB suite. ArXiv (2023). https://doi.org/10.48550/arXiv.2302.05705

# Abstract
Many statistical problems and applications require repeated computation of order statistics, such as the median, but most statistical and programming environments do not offer in their main distribution linear selection algorithms.  
We introduce one, formally equivalent to \textsf{quickselect}, which keeps the position of the pivot fixed. This makes the implementation simpler and much practical compared with the best known solutions.
It also enables an ``oracular'' pivot position option that can reduce a lot the convergence time of certain statistical applications.
We have extended the algorithm to weighted percentiles such as the weighted median, applicable to data associated with varying precision measurements, image filtering, descriptive statistics like the medcouple and for combining multiple predictors in boosting algorithms.   
We provide the new functions in \textsf{MATLAB}, \textsf{C} and R. We have packaged them in a broad  \textsf{MATLAB} toolbox addressing robust statistical methods, many of which can be now optimised by means of efficient (weighted) selections. 

# MATLAB Code

The code which generates all the figures can be found [here](Simpleselect/ArticleReplicabilityCodes).
The description of the files needed to replicate the code is in the [_README.txt] (https://github.com/UniprJRC/FSDApapers/blob/main/Simpleselect/ArticleReplicabilityCodes/_README.txt)
