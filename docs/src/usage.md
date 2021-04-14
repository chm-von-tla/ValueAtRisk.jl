```@meta
DocTestSetup = quote
    using Random
    Random.seed!(1)
end
DocTestFilters = r".*[0-9\.]"
```
# Usage

You may specify a Value-at-Risk model like so:
```jldoctest MANUAL
julia> using ValueAtRisk

julia> hs = HistoricalSimulationVaR(0.01)
Historical Simulation (naive empirical quantile approach), [0.99] confidence levels
```
A lot of the implemented methods depend on an ARCH model specification. We use the [`ARCHModels`](@ref) package for these methods and we provide a wrapper type for specification of the arch dynamics
```jldoctest MANUAL
julia> asp = ARCHSpec(GARCH{1,1})
Intercept-GARCH{1, 1, T} where T<:AbstractFloat model with StdNormal innovations

julia> asp2 = ARCHSpec(EGARCH{1,1,1},meanspec=AR{1},dist=StdSkewT)
AR{1, T} where T-EGARCH{1, 1, 1, T} where T<:AbstractFloat model with StdSkewT innovations
```

You can then specify a model with ARCH dynamics like so:
```jldoctest MANUAL
julia> fevt = FilteredExtremeValueTheoryVaR(0.01,archspec=asp2)
Extreme Value Theory on residuals filtered by AR{1, T} where T-EGARCH{1, 1, 1, T} where T<:AbstractFloat model with StdSkewT innovations, [0.99] confidence levels
```

You can obtain VaR forecasts by using the [`predict`](@ref) function:
```jldoctest MANUAL
# using the BG96 dataset provided by ARCHModels
julia> predict(fevt,BG96)
[1.5173537504541281]
```

You can also use the [`backtest`](@ref) function to evaluate the out-of-sample forecasting performance of a [`VaRModel`](@ref). [`backtest`](@ref) returns an object of type [`BacktestResult`](@ref)
```jldoctest MANUAL
julia> backtest(fevt,BG96,500)
______________________________________________________________________

Backtesting run on:                         Dataset name not specified
Method used:                                FEVT-EGARCH-StdSkewT
Confidence level:                           99.0%

In-sample observations/window size:         500
Out-of-sample observations:                 1474
Violations:                                 19

Value-at-Risk quantile level:               1.0%
Violations percentage:                      1.289009497964722%

Uncondtional Coverage LR Test p-value:      0.285723380115036
Dynamic Quantile Test p-value:              7.33621086930769e-14
Ljung-Box Test p-value:                     5.345020056176901e-10
______________________________________________________________________
```

Every Value-at-Risk model has a multi-quantile representation. It is possible to define a [`VaRModel`](@ref) with multiple quantiles:
```jldoctest MANUAL
julia> rms = EWMARiskMetricsVaR([0.01,0.025],decayfactor=0.96)
RiskMetrics EWMA approach, λ=0.96, [0.99, 0.975] confidence levels
```
The [`predict`](@ref) function will then return multiple results
```jldoctest MANUAL
julia> predict(rms,BG96)
[0.7129791067589807, 0.6006897706789867]
```

You can also provide a [`Vector`](@ref) of [`VaRModels`](@ref) to the [`backtest`](@ref) function in order to perform multiple backtesting procedures
```jldoctest MANUAL
julia> backtest([rms,fevt],BG96,1000,dataset_name="Bollerslev and Ghysels(JBES 1996)")
BacktestResult[______________________________________________________________________

Backtesting run on:                         Bollerslev and Ghysels(JBES 1996)
Method used:                                FEVT-EGARCH-StdSkewT
Confidence level:                           99.0%

In-sample observations/window size:         1000
Out-of-sample observations:                 974
Violations:                                 7

Value-at-Risk quantile level:               1.0%
Violations percentage:                      0.7186858316221766%

Uncondtional Coverage LR Test p-value:      0.3528600958576604
Dynamic Quantile Test p-value:              0.7824260394178464
Ljung-Box Test p-value:                     0.99835779977077
______________________________________________________________________
, ______________________________________________________________________

Backtesting run on:                         Bollerslev and Ghysels(JBES 1996)
Method used:                                RM-EWMA-0.94
Confidence level:                           99.0%

In-sample observations/window size:         1000
Out-of-sample observations:                 974
Violations:                                 20

Value-at-Risk quantile level:               1.0%
Violations percentage:                      2.0533880903490758%

Uncondtional Coverage LR Test p-value:      0.0038163257175188657
Dynamic Quantile Test p-value:              3.009857068419523e-5
Ljung-Box Test p-value:                     0.10673471090370372
______________________________________________________________________
, ______________________________________________________________________

Backtesting run on:                         Bollerslev and Ghysels(JBES 1996)
Method used:                                RM-EWMA-0.94
Confidence level:                           97.5%

In-sample observations/window size:         1000
Out-of-sample observations:                 974
Violations:                                 33

Value-at-Risk quantile level:               2.5%
Violations percentage:                      3.3880903490759757%

Uncondtional Coverage LR Test p-value:      0.09186260747237893
Dynamic Quantile Test p-value:              0.008501941078277678
Ljung-Box Test p-value:                     0.057764853136010125
______________________________________________________________________
]
```
