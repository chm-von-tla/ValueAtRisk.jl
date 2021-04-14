"""
    flexfit(asp::ARCHSpec, data::AbstractVector)

A wrapper around `fit(VS::Type{<:UnivariateVolatilitySpec}, data; dist=StdNormal,
meanspec=Intercept, algorithm=BFGS(), autodiff=:forward, kwargs...)` that catches
`AssertionError`s thrown when the requested `ARCHSpec` could not be fitted and falls back to
fitting GARCH{1,1} as the volatility specification
"""
function flexfit(asp::ARCHSpec, data::AbstractVector)
    try
        fit(asp.volspec, data, meanspec = asp.meanspec, dist=asp.dist)
    catch e
        if isa(e,AssertionError)
            @warn ("Could not fit $(asp.volspec), falling back to GARCH{1,1}")
            fit(GARCH{1,1}, data, meanspec = asp.meanspec, dist=asp.dist)
        else
            rethrow()
        end
    end
end
"""
    dupefit(asp::ARCHSpec, data::AbstractVector; prefitted::Union{ARCHMode[l,Nothing}=nothing])

A wrapper around `flexfit(asp::ARCHSpec, data::AbstractVector)` that fits an `ARCHModel` only once if multiple VaR models depend on the same underlying `ARCHSpec` in order to avoid wasted repetitions
"""
function dupefit(asp::ARCHSpec, data::AbstractVector; prefitted::Union{ARCHModel,Nothing}=nothing)
    prefitted != nothing ? prefitted : flexfit(asp,data)
end

# generate lists of models
function non_arch_models(αs::Vector{<:Real})
    [HistoricalSimulationVaR(αs),
     EWMAHistoricalSimulationVaR(αs,decayfactor=0.94),
     EWMAHistoricalSimulationVaR(αs,decayfactor=0.99),
     EWMARiskMetricsVaR(αs,decayfactor=0.94),
     EWMARiskMetricsVaR(αs,decayfactor=0.99),
     CAViaR_ad(αs),
     CAViaR_sym(αs),
     CAViaR_asym(αs),
     ExtremeValueTheoryVaR(αs)]
end
function arch_models(αs::Vector{<:Real},asp::ARCHSpec)
    [ARCHVaR(αs,archspec=asp),
     FilteredHistoricalSimulationVaR(αs,archspec=asp),
     FilteredExtremeValueTheoryVaR(αs,archspec=asp)]
end

all_models(αs::Vector{<:Real},asp::ARCHSpec) = vcat(non_arch_models(αs),arch_models(αs,asp))
