var documenterSearchIndex = {"docs":
[{"location":"usage/","page":"Usage","title":"Usage","text":"DocTestSetup = quote\n    using Random\n    Random.seed!(1)\nend","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"DocTestFilters = r\".*[0-9\\.]+.*\"","category":"page"},{"location":"usage/#Usage","page":"Usage","title":"Usage","text":"","category":"section"},{"location":"usage/","page":"Usage","title":"Usage","text":"You may specify a Value-at-Risk model like so:","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"julia> using ValueAtRisk\n\njulia> hs = HistoricalSimulationVaR(0.01)\nHistorical Simulation (naive empirical quantile approach), [0.99] confidence levels","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"A lot of the implemented methods depend on an ARCH model specification. We use the ARCHModels package for these methods and we provide a wrapper type for specification of the arch dynamics","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"julia> asp = ARCHSpec(GARCH{1,1})\nIntercept-GARCH{1, 1, T} where T<:AbstractFloat model with StdNormal innovations\n\njulia> asp2 = ARCHSpec(EGARCH{1,1,1},meanspec=AR{1},dist=StdSkewT)\nAR{1, T} where T-EGARCH{1, 1, 1, T} where T<:AbstractFloat model with StdSkewT innovations","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"You can then specify a model with ARCH dynamics like so:","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"julia> fevt = FilteredExtremeValueTheoryVaR(0.01,archspec=asp2)\nExtreme Value Theory on residuals filtered by AR{1, T} where T-EGARCH{1, 1, 1, T} where T<:AbstractFloat model with StdSkewT innovations, [0.99] confidence levels","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"You can obtain VaR forecasts by using the predict function:","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"# using the BG96 dataset provided by ARCHModels\njulia> predict(fevt,BG96)\n1-element Vector{Float64}:\n 1.5173537504541281","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"You can also use the backtest function to evaluate the out-of-sample forecasting performance of a VaRModel. backtest returns an object of type BacktestResult","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"julia> backtest(fevt,BG96,500)\n┌ Warning: Could not fit EGARCH{1, 1, 1, T} where T<:AbstractFloat, falling back to GARCH{1,1}\n└ @ ValueAtRisk ~/pgm/julia/dev/ValueAtRisk/src/utils.jl:14\n┌ Warning: Could not fit EGARCH{1, 1, 1, T} where T<:AbstractFloat, falling back to GARCH{1,1}\n└ @ ValueAtRisk ~/pgm/julia/dev/ValueAtRisk/src/utils.jl:14\n______________________________________________________________________\n\nBacktesting run on:                         Dataset name not specified\nMethod used:                                FEVT-EGARCH-StdSkewT\nConfidence level:                           99.0%\n\nIn-sample observations/window size:         500\nOut-of-sample observations:                 1474\nViolations:                                 18\n\nValue-at-Risk quantile level:               1.0%\nViolations percentage:                      1.2211668928086838%\n\nUncondtional Coverage LR Test p-value:      0.4094711648996806\nDynamic Quantile Test p-value:              2.7523601502903782e-12\nLjung-Box Test p-value:                     4.475778001388754e-9\n______________________________________________________________________","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"Every Value-at-Risk model has a multi-quantile representation. It is possible to define a VaRModel with multiple quantiles:","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"julia> rms = EWMARiskMetricsVaR([0.01,0.025],decayfactor=0.96)\nRiskMetrics EWMA approach, λ=0.96, [0.99, 0.975] confidence levels","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"The predict function will then return multiple results","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"julia> predict(rms,BG96)\n2-element Vector{Float64}:\n 0.6774901732183329\n 0.5707901016030177","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"You can also provide a Vector of VaRModels to the backtest function in order to perform multiple backtesting procedures","category":"page"},{"location":"usage/","page":"Usage","title":"Usage","text":"julia> backtest([rms,fevt],BG96,1000,dataset_name=\"Bollerslev and Ghysels(JBES 1996)\")\n3-element Vector{BacktestResult}:\n ______________________________________________________________________\n\nBacktesting run on:                         Bollerslev and Ghysels(JBES 1996)\nMethod used:                                RM-EWMA-0.96\nConfidence level:                           99.0%\n\nIn-sample observations/window size:         1000\nOut-of-sample observations:                 974\nViolations:                                 21\n\nValue-at-Risk quantile level:               1.0%\nViolations percentage:                      2.1560574948665296%\n\nUncondtional Coverage LR Test p-value:      0.0016710153907773877\nDynamic Quantile Test p-value:              0.0028296427287938393\nLjung-Box Test p-value:                     0.6951726097998511\n______________________________________________________________________\n\n ______________________________________________________________________\n\nBacktesting run on:                         Bollerslev and Ghysels(JBES 1996)\nMethod used:                                RM-EWMA-0.96\nConfidence level:                           97.5%\n\nIn-sample observations/window size:         1000\nOut-of-sample observations:                 974\nViolations:                                 31\n\nValue-at-Risk quantile level:               2.5%\nViolations percentage:                      3.1827515400410675%\n\nUncondtional Coverage LR Test p-value:      0.19009150894828886\nDynamic Quantile Test p-value:              0.0059707406056583\nLjung-Box Test p-value:                     0.02211883643264028\n______________________________________________________________________\n\n ______________________________________________________________________\n\nBacktesting run on:                         Bollerslev and Ghysels(JBES 1996)\nMethod used:                                FEVT-EGARCH-StdSkewT\nConfidence level:                           99.0%\n\nIn-sample observations/window size:         1000\nOut-of-sample observations:                 974\nViolations:                                 7\n\nValue-at-Risk quantile level:               1.0%\nViolations percentage:                      0.7186858316221766%\n\nUncondtional Coverage LR Test p-value:      0.3528600958576604\nDynamic Quantile Test p-value:              0.7840970640689414\nLjung-Box Test p-value:                     0.99835779977077\n______________________________________________________________________","category":"page"},{"location":"models/#Models","page":"VaR methods available","title":"Models","text":"","category":"section"},{"location":"models/","page":"VaR methods available","title":"VaR methods available","text":"CurrentModule = ValueAtRisk\nDocTestSetup  = quote\n    using ValueAtRisk\nend","category":"page"},{"location":"models/","page":"VaR methods available","title":"VaR methods available","text":"Value-at-Risk models currently available:","category":"page"},{"location":"models/#Historical-Simulation","page":"VaR methods available","title":"Historical Simulation","text":"","category":"section"},{"location":"models/","page":"VaR methods available","title":"VaR methods available","text":"HistoricalSimulationVaR","category":"page"},{"location":"models/#ValueAtRisk.HistoricalSimulationVaR","page":"VaR methods available","title":"ValueAtRisk.HistoricalSimulationVaR","text":"HistoricalSimulationVaR{T} <: VaRModel{T}\n\nA naive Historical Simulation approach in which the VaR estimates is the corresponding quantile of the empirical distribution of returns\n\n\n\n\n\n","category":"type"},{"location":"models/#EWMA-Scaled/Filtered-Historical-Simulation","page":"VaR methods available","title":"EWMA Scaled/Filtered Historical Simulation","text":"","category":"section"},{"location":"models/","page":"VaR methods available","title":"VaR methods available","text":"EWMAHistoricalSimulationVaR","category":"page"},{"location":"models/#ValueAtRisk.EWMAHistoricalSimulationVaR","page":"VaR methods available","title":"ValueAtRisk.EWMAHistoricalSimulationVaR","text":"EWMAHistoricalSimulationVaR{T} <: VaRModel{T}\n\nA scaled/filtered Historical Simulation technique in which conditional volatility is calculated using an Exponentially Weighted Moving Average scheme\n\n\n\n\n\n","category":"type"},{"location":"models/#(GARCH)-Filtered-Historical-simulation*","page":"VaR methods available","title":"(GARCH) Filtered Historical simulation*","text":"","category":"section"},{"location":"models/","page":"VaR methods available","title":"VaR methods available","text":"FilteredHistoricalSimulationVaR","category":"page"},{"location":"models/#ValueAtRisk.FilteredHistoricalSimulationVaR","page":"VaR methods available","title":"ValueAtRisk.FilteredHistoricalSimulationVaR","text":"FilteredHistoricalSimulationVaR{T} <: VaRModel{T}\n\nA technique which fits an ARCHModel to the data and forecasts VaR by combining the one-step ahead conditional mean estimate of the model and the quantile of the empirical distributions of the standardized residuals of our data scaled by the one-step ahead conditional volatility estimate\n\n\n\n\n\n","category":"type"},{"location":"models/#EWMA-RiskMetrics-approach","page":"VaR methods available","title":"EWMA RiskMetrics approach","text":"","category":"section"},{"location":"models/","page":"VaR methods available","title":"VaR methods available","text":"EWMARiskMetricsVaR","category":"page"},{"location":"models/#ValueAtRisk.EWMARiskMetricsVaR","page":"VaR methods available","title":"ValueAtRisk.EWMARiskMetricsVaR","text":"EWMARiskMetricsVaR{T} <: VaRModel{T}\n\nThe RiskMetrics approach to forecasting Value-at-Risk according to which our data is assumed to be normally distributed with mean zero and conditional volatility calculated based on an Exponentially Weighted Moving Average approach\n\n\n\n\n\n","category":"type"},{"location":"models/#CAViaR-(adaptive,symmetric-absolute-value,-asymmetrics-slope)","page":"VaR methods available","title":"CAViaR (adaptive,symmetric absolute value, asymmetrics slope)","text":"","category":"section"},{"location":"models/","page":"VaR methods available","title":"VaR methods available","text":"CAViaR_ad","category":"page"},{"location":"models/#ValueAtRisk.CAViaR_ad","page":"VaR methods available","title":"ValueAtRisk.CAViaR_ad","text":"CAViaR_ad{T} <: CAViaR{T}\n\nEngle and Manganelli's Conditionally Autoregressive Value at Risk, adaptive\n\n\n\n\n\n","category":"type"},{"location":"models/","page":"VaR methods available","title":"VaR methods available","text":"CAViaR_sym","category":"page"},{"location":"models/#ValueAtRisk.CAViaR_sym","page":"VaR methods available","title":"ValueAtRisk.CAViaR_sym","text":"CAViaR_sym{T} <: CAViaR{T}\n\nEngle and Manganelli's Conditionally Autoregressive Value at Risk, symmetric absolute value\n\n\n\n\n\n","category":"type"},{"location":"models/","page":"VaR methods available","title":"VaR methods available","text":"CAViaR_asym","category":"page"},{"location":"models/#ValueAtRisk.CAViaR_asym","page":"VaR methods available","title":"ValueAtRisk.CAViaR_asym","text":"CAViaR_asym{T} <: CAViaR{T}\n\nEngle and Manganelli's Conditionally Autoregressive Value at Risk, asymmetric slope\n\n\n\n\n\n","category":"type"},{"location":"models/#ARCH-models*","page":"VaR methods available","title":"ARCH models*","text":"","category":"section"},{"location":"models/","page":"VaR methods available","title":"VaR methods available","text":"ARCHVaR","category":"page"},{"location":"models/#ValueAtRisk.ARCHVaR","page":"VaR methods available","title":"ValueAtRisk.ARCHVaR","text":"ARCHVaR{T} <: VaRModel{T}\n\nEstimate VaR using an autoregressive conditional heteroskedasticity model\n\n\n\n\n\n","category":"type"},{"location":"models/#Extreme-Value-Theory","page":"VaR methods available","title":"Extreme Value Theory","text":"","category":"section"},{"location":"models/","page":"VaR methods available","title":"VaR methods available","text":"ExtremeValueTheoryVaR","category":"page"},{"location":"models/#ValueAtRisk.ExtremeValueTheoryVaR","page":"VaR methods available","title":"ValueAtRisk.ExtremeValueTheoryVaR","text":"ExtremeValueTheoryVaR{T} <: VaRModel{T}\n\nA VaR forecasting technique that makes use of Peaks Over Theshold technique which originates in Extreme Value Theory\n\n\n\n\n\n","category":"type"},{"location":"models/#Filtered-Extreme-Value-Theory*","page":"VaR methods available","title":"Filtered Extreme Value Theory*","text":"","category":"section"},{"location":"models/","page":"VaR methods available","title":"VaR methods available","text":"FilteredExtremeValueTheoryVaR","category":"page"},{"location":"models/#ValueAtRisk.FilteredExtremeValueTheoryVaR","page":"VaR methods available","title":"ValueAtRisk.FilteredExtremeValueTheoryVaR","text":"FilteredExtremeValueTheoryVaR{T} <: VaRModel{T}\n\nA technique which fits an ARCHModel to the data and forecasts VaR by finding the quantile function of the innovation terms using Extreme Value Theory the standardized residuals. The VaR forecast combines the one-step ahead conditional mean estimate of the model and the result of the quantile function of the innovation terms scaled by the one-step ahead conditional volatility estimate\n\n\n\n\n\n","category":"type"},{"location":"models/","page":"VaR methods available","title":"VaR methods available","text":"For models marked with * an ARCH dynamics specification may be supplied: ARCHSpec","category":"page"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = ValueAtRisk","category":"page"},{"location":"#ValueAtRisk","page":"Home","title":"ValueAtRisk","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for ValueAtRisk.","category":"page"},{"location":"#Introduction","page":"Home","title":"Introduction","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Value-at-Risk is a method for measuring the risk of extremal losses in financial investments. Nieto and Ruiz (2016) and Kuester et al. (2005) provide a good overview of the subject. ","category":"page"},{"location":"","page":"Home","title":"Home","text":"This package was born out of my master thesis which concerned a comparative study of various univariate Value-at-Risk methodologies. Therefore plenty of univariate Value-at-Risk methods are provided with a focus being placed on providing efficient backtesting methods for the evaluation of the effectiveness of each method. ","category":"page"},{"location":"","page":"Home","title":"Home","text":"The package is still at an early stage. The documentation and test coverage are limited. Any feedback or contributions are appreciated.","category":"page"},{"location":"#Design-choices","page":"Home","title":"Design choices","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The focus on backtesting efficiency has guided the \"architectural\" choices for the types and methods/functions provided. Each VaR methodology has a multi-quantile representation because in the vast majority of cases the forecasting of additional VaR quantiles is cheap once the necessary work for forecasting a single one of them has been completed. The backtesting function also takes a vector of different methodologies to be calculated in order to take advantage of the fact that a lot of the models share GARCH dynamics specifications and fit the appropriate model only once and hence not repeat the same step again. The backtesting loop also uses the ","category":"page"},{"location":"autodocs/#Reference-guide","page":"Reference Guide","title":"Reference guide","text":"","category":"section"},{"location":"autodocs/#Index","page":"Reference Guide","title":"Index","text":"","category":"section"},{"location":"autodocs/","page":"Reference Guide","title":"Reference Guide","text":"","category":"page"},{"location":"autodocs/#API","page":"Reference Guide","title":"API","text":"","category":"section"},{"location":"autodocs/","page":"Reference Guide","title":"Reference Guide","text":"Modules = [ValueAtRisk]\nFilter = t -> !(typeof(t) === UnionAll && t <: ValueAtRisk.VaRModel)","category":"page"},{"location":"autodocs/#HypothesisTests.LjungBoxTest-Union{Tuple{T}, Tuple{Vector{T}, Vector{T}}, Tuple{Vector{T}, Vector{T}, Integer}} where T<:Real","page":"Reference Guide","title":"HypothesisTests.LjungBoxTest","text":"LjungBoxTest(data::Vector{T}, vars::Vector{T}, lag::Integer=1)\n\nCompute the Ljung-Box Q statistic to test the null hypothesis of independence in the violations/hits sequence that is implied by the vectors of realizations (data) and Value-at-Risk forecasts(vars). lag specifies the number of lags used in the construction of Q\n\n\n\n\n\n","category":"method"},{"location":"autodocs/#ValueAtRisk.ARCHSpec","page":"Reference Guide","title":"ValueAtRisk.ARCHSpec","text":"ARCHSpec\n\nA specification for the GARCH dynamics of an appropriate model\n\n\n\n\n\n","category":"type"},{"location":"autodocs/#ValueAtRisk.BacktestResult","page":"Reference Guide","title":"ValueAtRisk.BacktestResult","text":"struct BacktestResult{T<:Real}\n\nA type that contains information on the results of backtesting a VaRModel on a dataset.\n\n\n\n\n\n","category":"type"},{"location":"autodocs/#ValueAtRisk.BacktestResult-Union{Tuple{T2}, Tuple{T1}, Tuple{String, VaRModel, T2, T1, Vector{T1}, Vector{T1}}} where {T1<:Real, T2<:Integer}","page":"Reference Guide","title":"ValueAtRisk.BacktestResult","text":"BacktestResult(dataset::String, vm::VaRModel, windowsize::Integer, level::T1\n               data::Vector{T1}, vars::Vector{T1}; lags::Integer=1) where T1<:Real\n\nCreate an object of type BacktestResult. dataset specifies the name of the dataset on which Value-at-Risk backtesting was performed. vm specifies the VaRModel used for obtaining Value-at-Risk estimates. windowsize specifies the number of in-sample observations that were used to obtain each out-of-sample VaR forecast. level is VaR quantile level. data is the vector of realizations, while vars is the vector of VaR estimates. The optional parameter lags specifies the number of lags used in the DQTest and LjungBoxTest for testing the time independence of the violations/hits sequence of VaR estimates.\n\n\n\n\n\n","category":"method"},{"location":"autodocs/#ValueAtRisk.LRucTest","page":"Reference Guide","title":"ValueAtRisk.LRucTest","text":"DQTest <: HypothesisTest\n\nChristoffersen's (1998) Unconditional Coverage Likelihood Ratio test (out of sample)\n\n\n\n\n\n","category":"type"},{"location":"autodocs/#ValueAtRisk.LRucTest-Tuple{AbstractArray{Bool}, Any}","page":"Reference Guide","title":"ValueAtRisk.LRucTest","text":"LRucTest(violations::AbstractArray{Bool},level)\n\nConduct Christoffersen's (1998) Unconditional Coverage Likelihood Ratio test by passing a a AbstractArray{Bool} representing the violations/hits sequence and the VaRModel quantile level\n\n\n\n\n\n","category":"method"},{"location":"autodocs/#ValueAtRisk.LRucTest-Union{Tuple{T}, Tuple{Vector{T}, Vector{T}, Any}} where T<:Real","page":"Reference Guide","title":"ValueAtRisk.LRucTest","text":"LRucTest(data::Vector{T}, vars::Vector{T},level)\n\nConduct Christoffersen's (1998) Unconditional Coverage Likelihood Ratio test by passing a a vector of realizations accompanied by a vector of the correponding VaR forecasts and the VaRModel quantile level\n\n\n\n\n\n","category":"method"},{"location":"autodocs/#StatsAPI.predict-Tuple{VaRModel, AbstractVector}","page":"Reference Guide","title":"StatsAPI.predict","text":"predict(vm::VaRModel, data::AbstractVector)\n\nReturn a one-step ahead VaR forecast with VaRModel vm for the provided data vector\n\n\n\n\n\n","category":"method"},{"location":"autodocs/#ValueAtRisk.backtest-Tuple{VaRModel, Vector{<:Real}, Integer}","page":"Reference Guide","title":"ValueAtRisk.backtest","text":"backtest(vms::Vector{<:VaRModel}, data::Vector{<:Real},\n              windowsize::Integer;dataset_name::String=\"Dataset name not specified\",\n              lags::Integer=5)\n\nBacktests a single VaRModel on the supplied dataset. windowsize specifies the number of in-sample observations used for forecasting Value-at-Risk. backtest(...) returns an object of type BacktestResult. The optional parameter lags controls the number of lags used in the the tests of time independence. dataset_name may be provided in order to be included in the BacktestResult\n\n\n\n\n\n","category":"method"},{"location":"autodocs/#ValueAtRisk.backtest-Tuple{Vector{<:VaRModel}, Vector{<:Real}, Integer}","page":"Reference Guide","title":"ValueAtRisk.backtest","text":"backtest(vms::Vector{<:VaRModel}, data::Vector{<:Real},\n              windowsize::Integer;dataset_name::String=\"Dataset name not specified\",\n              lags::Integer=5)\n\nBacktest multiple VaRModels on the supplied dataset. windowsize specifies the number of in-sample observations used for forecasting Value-at-Risk. backtest(...) returns a vector of BacktestResults. The optional parameter lags controls the number of lags used in the the tests of time independence. dataset_name may be provided in order to be included in the BacktestResult\n\n\n\n\n\n","category":"method"},{"location":"autodocs/#ValueAtRisk.confidence_levels-Tuple{VaRModel}","page":"Reference Guide","title":"ValueAtRisk.confidence_levels","text":"confidence_levels(vm::VaRModel)\n\nReturn the confidence level(s) for the given model\n\n\n\n\n\n","category":"method"},{"location":"autodocs/#ValueAtRisk.dupefit-Tuple{ARCHSpec, AbstractVector}","page":"Reference Guide","title":"ValueAtRisk.dupefit","text":"dupefit(asp::ARCHSpec, data::AbstractVector; prefitted::Union{ARCHMode[l,Nothing}=nothing])\n\nA wrapper around flexfit(asp::ARCHSpec, data::AbstractVector) that fits an ARCHModel only once if multiple VaR models depend on the same underlying ARCHSpec in order to avoid wasted repetitions\n\n\n\n\n\n","category":"method"},{"location":"autodocs/#ValueAtRisk.flexfit-Tuple{ARCHSpec, AbstractVector}","page":"Reference Guide","title":"ValueAtRisk.flexfit","text":"flexfit(asp::ARCHSpec, data::AbstractVector)\n\nA wrapper around fit(VS::Type{<:UnivariateVolatilitySpec}, data; dist=StdNormal, meanspec=Intercept, algorithm=BFGS(), autodiff=:forward, kwargs...) that catches AssertionErrors thrown when the requested ARCHSpec could not be fitted and falls back to fitting GARCH{1,1} as the volatility specification\n\n\n\n\n\n","category":"method"},{"location":"autodocs/#ValueAtRisk.shared_arch_models_dict-Tuple{Vector{<:VaRModel}}","page":"Reference Guide","title":"ValueAtRisk.shared_arch_models_dict","text":"shared_arch_models_dict(vms::AbstractVector{<:VaRModel})\n\nReturn a dict with key an ARCHSpec and value a Union{ARCHModel,Nothing}\n\n\n\n\n\n","category":"method"},{"location":"autodocs/#ValueAtRisk.shares_arch_dynamics-Tuple{VaRModel}","page":"Reference Guide","title":"ValueAtRisk.shares_arch_dynamics","text":"shares_arch_dynamics(vm::VaRModel)\n\nWhether the given model contains a specification for autoregressive conditionaly heteroskedastic dynamics. If models share such a specification the model is fitted only once during backtesting\n\n\n\n\n\n","category":"method"},{"location":"autodocs/#ValueAtRisk.shortname-Tuple{ARCHSpec}","page":"Reference Guide","title":"ValueAtRisk.shortname","text":"shortname(asp::ARCHSpec)\n\nPrint a short description for the ARCHSpec given. Orders of ARCH models and mean specifications are ignored\n\n\n\n\n\n","category":"method"},{"location":"autodocs/#ValueAtRisk.shortname-Tuple{VaRModel}","page":"Reference Guide","title":"ValueAtRisk.shortname","text":"shortname(vm::VaRModel)\n\nPrint a short description for the model given\n\n\n\n\n\n","category":"method"}]
}
