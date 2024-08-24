# Final Report for Expected Return

	Contributor: Ziyu (Harry) He
	Mentor: Justin Shea, Brian Peterson, Erol Biceroglu, Bryan Rodriguez
	Organization: R project for statistical computing
## Introduction
[Expected Return][https://github.com/JustinMShea/ExpectedReturns] is an R package that applies machine learning (ML) methods to quantitative finance. This package aims to aid practitioners and researchers in using machine learning for portfolio construction, backtesting, and risk analysis.

We decide to create this package and include core functionality that has appeared in academic literature but had no or limited functional equivalent in R. We found key inspiration from *Machine Learning for Factor Investing* (2020) and *Advances in Financial Machine Learning* (2018).
## About the Package
R does not lack packages and functions that provide machine learning frameworks and pipelines for data analysis. Current approaches, however, often fall short of robust functions for analyzing financial data. As many theorists and practitioners have discussed at length, conventional machine learning procedures from feature engineering to cross-validation often fail when applied to time-series data. Ultimate we hope this package will provide a robust machine learning framework for quantitative finance. At the current stage, we aim to offer a viable pipeline with core functions for empirical applications
## Contributions
### Data Preprocessing
- [Outlier detection][https://github.com/JustinMShea/ExpectedReturns/blob/master/sandbox/outliers.R]: interval outlier detection and winsorization
- [Feature rescaling][https://github.com/JustinMShea/ExpectedReturns/blob/master/sandbox/rescale.R]: standardization, min-max rescaling, and uniformization
- [Feature selection][https://github.com/JustinMShea/ExpectedReturns/blob/master/sandbox/featureselection.R]: feature correlation analysis
- Labeling: [triple-barrier labeling][https://github.com/JustinMShea/ExpectedReturns/blob/master/sandbox/triple_barrier.R]
### Backtesting
- Portfolio construction: 
	- [ML-based strategy][https://github.com/JustinMShea/ExpectedReturns/blob/master/sandbox/build_strategy.R]: use ML algorithm to predict future returns and create weights for long-only or long/short portfolios
	- [Benchmark portfolio][https://github.com/JustinMShea/ExpectedReturns/blob/master/sandbox/benchmark_strategy.R]: build equal-weight or momentum-scaled benchmark portfolios 
- Cross-validation:
	- [Walk-forward k-fold][https://github.com/JustinMShea/ExpectedReturns/blob/master/sandbox/walkforward_kfold.R]: generalization of conventional walk-forward cross-validation method to allows for more flexibility and user controls over training/testing windows and cross-validation sizes
	- [Purged k-fold][https://github.com/JustinMShea/ExpectedReturns/blob/master/sandbox/purged_kfold.R]: purged k-fold cross-validation as suggested by Lopez de Prado. Purging overlapped observations to minimize data leakage
	- [Combinatorial purged][https://github.com/JustinMShea/ExpectedReturns/blob/master/sandbox/combinatorial_purged.R]: new method suggested by Lopez de Prado to address the drawback of walk-forward cross-validation by creating more backtest paths.

Contributions also include constructing a class object for faster and more efficient application, test functions to ensure the MLR3 wrapper functions properly with various ML algorithms, and evaluation and visualization functions. More detailed progress is recorded in a [developer log][https://github.com/JustinMShea/ExpectedReturns/blob/master/sandbox/developer_log_harry.md]
## Future Steps
1. Fully integrate various components of the pipeline
2. Expand the package to include more core functionalities for hyper-parameter tuning, sample weights construction, model evaluation, feature selection, and feature engineering
3. Explore more cross-validation approaches. Many existing approaches face various types of overfitting problems, including data leakage and the single scenario problem. The combinatorial purged cross-validation approach suggested by Lopez de Prado generate multiple synthetic paths but have limited applicable cases. We plan to examine the robustness of various established cross-validation methods and discuss new ways to avoid the various overfit pitfalls.