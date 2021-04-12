"""
    EWMARiskMetricsVaR{T} <: VaRModel{T}

The RiskMetrics approach to forecasting Value-at-Risk according to which our data is assumed
to be normally distributed with mean zero and conditional volatility calculated based on an
Exponentially Weighted Moving Average approach
"""
struct EWMARiskMetricsVaR{T} <: VaRModel{T}
    αs::Vector{T}
    λ::T
    function EWMARiskMetricsVaR(confidence_levels::Vector{T};
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
function EWMARiskMetricsVaR(α::T; decayfactor::T=0.94) where T<:Real
    EWMARiskMetricsVaR([α],decayfactor=decayfactor)
end
Base.show(io::IO,vm::EWMARiskMetricsVaR) = print(io, "RiskMetrics EWMA approach, λ=$(vm.λ), $(round.((1 .- vm.αs), digits=4)) confidence levels")
shortname(vm::EWMARiskMetricsVaR)  = "RM-EWMA-$(vm.λ)"
confidence_levels(vm::EWMARiskMetricsVaR) = vm.αs

function predict(vm::EWMARiskMetricsVaR{T1}, data::AbstractVector) where T1
    T=length(data)

    uncond_var = var(data)
    ewma_var = Vector{T1}(undef,T+1)
    ewma_var[1] = uncond_var
    for t in 2:T+1
        ewma_var[t] = vm.λ * ewma_var[t-1] + (1 - vm.λ)*data[t-1]^2
    end
    cond_vol = sqrt(ewma_var[T+1])

    -quantile.(Ref(Normal(0,cond_vol)),vm.αs)
end
