module ValueAtRisk

using ARCHModels
using Distributions
using Optim

import Base: show
import StatsBase: predict
import Distributions: fit_mle

export VaRModel, ARCHSpec, shortname, confidence_levels, has_arch_dynamics, ARCHVaR, CAViaR_ad, CAViaR_sym, CAViaR_asym, EWMAHistoricalSimulationVaR, EWMARiskMetricsVaR, ExtremeValueTheoryVaR, FilteredExtremeValueTheoryVaR, FilteredHistoricalSimulationVaR, HistoricalSimulationVaR

include("core_types.jl")
include("support_types.jl")
include("utils.jl")
include("VaRTypes/ARCHVaR.jl")
include("VaRTypes/CAViaR.jl")
include("VaRTypes/EWMAHistoricalSimulationVaR.jl")
include("VaRTypes/EWMARiskMetricsVaR.jl")
include("VaRTypes/ExtremeValueTheoryVaR.jl")
include("VaRTypes/FilteredExtremeValueTheoryVaR.jl")
include("VaRTypes/FilteredHistoricalSimulationVaR.jl")
include("VaRTypes/HistoricalSimulationVaR.jl")

end
