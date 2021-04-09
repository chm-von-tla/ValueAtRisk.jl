"""
    FilteredExtremeValueTheoryVaR{T} <: VaRModel{T}

A technique which fits an `ARCHModel` to the data and forecasts VaR by finding the quantile
function of the innovation terms using Extreme Value Theory the standardized residuals. The
VaR forecast combines the one-step ahead conditional mean estimate of the model and the
result of the quantile function of the innovation terms scaled by the one-step ahead
conditional volatility estimate
"""
struct FilteredExtremeValueTheoryVaR{T} <: VaRModel{T}
    αs::Vector{T}
    qthreshold::T
    asp::ARCHSpec
    function FilteredExtremeValueTheoryVaR(confidence_levels::Vector{T};
                                           qthreshold::T=0.9,
                                           archspec::ARCHSpec=ARCHSpec(GARCH{1,1})) where {T <: Real}
        for α in confidence_levels
            0 <= α <= 1 || throw(DomainError(confidence_levels, "element of confidence_levels parameters \"α\" must be in the interval [0,1]"))
        end
        0 < qthreshold < 1 || throw(DomainError(confidence_levels, "qthreshold parameter  must be in the interval (0,1)"))
        new{T}(confidence_levels,qthreshold,archspec)
    end
end
function FilteredExtremeValueTheoryVaR(α::T;
                                       qthreshold=0.9,
                                       archspec=ARCHSpec(GARCH{1,1})) where {T<:Real}
    FilteredExtremeValueTheoryVaR([α],qthreshold=qthreshold,archspec=archspec)
end
Base.show(io::IO,vm::FilteredExtremeValueTheoryVaR) = print(io, "Extreme Value Theory on residuals filtered by $(vm.asp), $(round.((1 .- vm.αs), digits=4)) confidence levels")
shortname(vm::FilteredExtremeValueTheoryVaR) = "FEVT-$(shortname(vm.asp))"
confidence_levels(vm::FilteredExtremeValueTheoryVaR) = vm.αs
has_arch_dynamics(vm::FilteredExtremeValueTheoryVaR) = true


function predict(vm::FilteredExtremeValueTheoryVaR{T},data::AbstractVector;prefitted::Union{ARCHModel,Nothing}=nothing) where T
    # every model that shares arch dynamics is computed on the right tail of the negative of
    # in order to be compatible with the Extreme Value Theory models
    αs′ = 1 .- vm.αs
    losses = -data

    am = dupefit(vm.asp,losses,prefitted=prefitted)

    η = residuals(am,standardized=true)

    mean_est = predict(am, :return)
    vol_est = predict(am, :volatility)
    η_dist = pot_find_gpd_dist(η,qthreshold=vm.qthreshold)
    mean_est .+ (vol_est.*quantile(η_dist,αs′))
end
function pot_find_gpd_dist(data::AbstractVector;qthreshold::T) where T<:Real
    u = quantile(data, qthreshold)
    excesses = filter(x->(x>u), data)
    fit_mle(GeneralizedPareto,excesses,u)
end
