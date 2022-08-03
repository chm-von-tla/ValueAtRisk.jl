```@meta
CurrentModule = ValueAtRisk
```

# ValueAtRisk

Documentation for [ValueAtRisk](https://github.com/chm-von-tla/ValueAtRisk.jl).

## Introduction

[Value-at-Risk](https://en.wikipedia.org/wiki/Value_at_risk) is a method for measuring the risk of extremal losses in financial investments. [Nieto and Ruiz (2016)](https://doi.org/10.1016/j.ijforecast.2015.08.003) and [Kuester et al. (2005)](https://doi.org/10.1093/jjfinec/nbj002) provide a good overview of the subject. 

This package was born out of my master thesis which concerned a comparative study of various univariate Value-at-Risk methodologies. Therefore plenty of univariate Value-at-Risk methods are provided with a focus being placed on providing efficient backtesting methods for the evaluation of the effectiveness of each method. 

The package is still at an early stage. The documentation and test coverage are limited. Any feedback or contributions are appreciated.

## Design choices
The focus on backtesting efficiency has guided the "architectural" choices for the types and methods/functions provided. Each VaR methodology has a multi-quantile representation because in the vast majority of cases the forecasting of additional VaR quantiles is cheap once the necessary work for forecasting a single one of them has been completed. The backtesting function also takes a vector of different methodologies to be calculated in order to take advantage of the fact that a lot of the models share GARCH dynamics specifications and fit the appropriate model only once and hence not repeat the same step again.
