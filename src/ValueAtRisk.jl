module ValueAtRisk

using Distributions
using Optim
using Base.Threads
using HypothesisTests
using Reexport
@reexport using ARCHModels

import Base: show
import StatsBase: predict
import Distributions: fit_mle
import ARCHModels: DQTest
import HypothesisTests: HypothesisTest, testname, population_param_of_interest, show_params, pvalue, LjungBoxTest


export VaRModel, ARCHSpec, shortname, confidence_levels, shares_arch_dynamics, ARCHVaR, CAViaR_ad, CAViaR_sym, CAViaR_asym, EWMAHistoricalSimulationVaR, EWMARiskMetricsVaR, ExtremeValueTheoryVaR, FilteredExtremeValueTheoryVaR, FilteredHistoricalSimulationVaR, HistoricalSimulationVaR, backtest, BacktestResult, LRucTest, LjungBoxTest

include("core_types.jl")
include("support_types.jl")
include("utils.jl")
include("backtesting.jl")
include("hypothesistests.jl")
include("BacktestResult.jl")
include("VaRTypes/ARCHVaR.jl")
include("VaRTypes/CAViaR.jl")
include("VaRTypes/EWMAHistoricalSimulationVaR.jl")
include("VaRTypes/EWMARiskMetricsVaR.jl")
include("VaRTypes/ExtremeValueTheoryVaR.jl")
include("VaRTypes/FilteredExtremeValueTheoryVaR.jl")
include("VaRTypes/FilteredHistoricalSimulationVaR.jl")
include("VaRTypes/HistoricalSimulationVaR.jl")

end
