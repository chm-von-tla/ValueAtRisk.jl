"""
    EWMAHistoricalSimulationVaR{T} <: VaRModel{T}

A scaled/filtered Historical Simulation technique in which conditional volatility is calculated
using an Exponentially Weighted Moving Average scheme
"""
struct EWMAHistoricalSimulationVaR{T} <: VaRModel{T}
    αs::Vector{T}
    λ::T
    function EWMAHistoricalSimulationVaR(confidence_levels::Vector{T};
                                          decayfactor::T=0.94) where {T <: Real}
        for α in confidence_levels
            0 <= α <= 1 || throw(DomainError(confidence_levels,
             "element of confidence_levels parameters \"α\" must be in the interval [0,1]"))
        end
        0 < decayfactor < 1 || throw(DomainError(confidence_levels,
                              "decayfactor parameter \"λ\" must be in the interval (0,1)"))
        new{T}(confidence_levels,decayfactor)
    end
end
function EWMAHistoricalSimulationVaR(α::T; decayfactor::T=0.94) where T<:Real
    EWMAHistoricalSimulationVaR([α],decayfactor=decayfactor)
end
Base.show(io::IO,vm::EWMAHistoricalSimulationVaR) = print(io, "Historical Simulation (exponentially weighted moving average, λ=$(vm.λ)), $(round.((1 .- vm.αs), digits=4)) confidence levels")
shortname(vm::EWMAHistoricalSimulationVaR)  = "HS-EWMA-$(vm.λ)"
confidence_levels(vm::EWMAHistoricalSimulationVaR) = vm.αs

function predict(vm::EWMAHistoricalSimulationVaR{T1}, data::AbstractVector) where T1
    T=length(data)

    uncond_var = var(data)
    ewma_var = Vector{T1}(undef,T+1)
    ewma_var[1] = uncond_var
    for t in 2:T+1
        ewma_var[t] = vm.λ * ewma_var[t-1] + (1 - vm.λ)*data[t-1]^2
    end
    σ = sqrt.(ewma_var)
    scaled_ret = [ σ[end] * data[i]/σ[i] for i in 1:T]

    -quantile(scaled_ret,vm.αs)
end
