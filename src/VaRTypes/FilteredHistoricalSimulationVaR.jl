"""
    FilteredHistoricalSimulationVaR{T} <: VaRModel{T}

A technique which fits an `ARCHModel` to the data and forecasts VaR by combining the
one-step ahead conditional mean estimate of the model and the quantile of the empirical
distributions of the standardized residuals of our data scaled by the one-step ahead
conditional volatility estimate
"""
struct FilteredHistoricalSimulationVaR{T} <: VaRModel{T}
    αs::Vector{T}
    asp::ARCHSpec
    function FilteredHistoricalSimulationVaR(confidence_levels::Vector{T};
                                  archspec::ARCHSpec=ARCHSpec(GARCH{1,1})) where {T <: Real}
        for α in confidence_levels
            0 <= α <= 1 || throw(DomainError(confidence_levels, "element of confidence_levels parameters \"α\" must be in the interval [0,1]"))
        end
        new{T}(confidence_levels,archspec)
    end
end
function FilteredHistoricalSimulationVaR(α::T;
                                         archspec=ARCHSpec(GARCH{1,0})) where T<:Real
    FilteredHistoricalSimulationVaR([α],archspec=archspec)
end
Base.show(io::IO,vm::FilteredHistoricalSimulationVaR) = print(io, "Historical Simulation on residuals filtered by $(vm.asp), $(round.((1 .- vm.αs),digits=4)) confidence levels")
shortname(vm::FilteredHistoricalSimulationVaR)  = "FHS-$(shortname(vm.asp))"
confidence_levels(vm::FilteredHistoricalSimulationVaR) = vm.αs
has_arch_dynamics(vm::FilteredHistoricalSimulationVaR) = true

function predict(vm::FilteredHistoricalSimulationVaR{T1}, data::AbstractVector;prefitted::Union{ARCHModel,Nothing}=nothing) where T1
    # every model that shares arch dynamics is computed on the right tail of the negative of
    # in order to be compatible with the Extreme Value Theory models
    αs′ = 1 .- vm.αs
    losses = -data

    am = dupefit(vm.asp, losses; prefitted=prefitted)

    η = residuals(am,standardized=true)
    emp_qs = quantile.(Ref(η),αs′)
    mean_est = predict(am, :return)
    vol_est = predict(am, :volatility)
    mean_est .+ (vol_est.*emp_qs)
end
