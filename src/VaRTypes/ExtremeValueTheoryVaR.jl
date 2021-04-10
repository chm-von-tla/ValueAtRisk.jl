"""
    ExtremeValueTheoryVaR{T} <: VaRModel{T}

A VaR forecasting technique that makes use of Peaks Over Theshold technique which originates
in Extreme Value Theory
"""
struct ExtremeValueTheoryVaR{T} <: VaRModel{T}
    αs::Vector{T}
    qthreshold::T
    function ExtremeValueTheoryVaR(confidence_levels::Vector{T};
                                   qthreshold::T=0.9) where {T <: Real}
        for α in confidence_levels
            0 <= α <= 1 || throw(DomainError(confidence_levels, "element of confidence_levels parameters \"α\" must be in the interval [0,1]"))
        end
        0 < qthreshold < 1 || throw(DomainError(confidence_levels, "qthreshold parameter  must be in the interval (0,1)"))
        new{T}(confidence_levels,qthreshold)
    end
end
function ExtremeValueTheoryVaR(α::T;qthreshold::T=0.9) where {T<:Real}
    ExtremeValueTheoryVaR([α],qthreshold=qthreshold)
end
Base.show(io::IO,vm::ExtremeValueTheoryVaR) = print(io, "Extreme Value Theory (Peaks over Threshold($(vm.qthreshold)) approach), $(round.((1 .- vm.αs),digits=4)) confidence levels")
shortname(vm::ExtremeValueTheoryVaR) = "EVT"
confidence_levels(vm::ExtremeValueTheoryVaR) = vm.αs

function predict(vm::ExtremeValueTheoryVaR{T1}, data::AbstractVector) where T1
    # invert αs and data as for EVT we are dealing with the right tail of the distribution
    αs′ = 1 .- vm.αs
    losses = -data

    T = length(losses)
    u = quantile(losses,vm.qthreshold)


    excesses = filter(x->(x>u), losses)
    k = length(excesses)

    _, σ, ξ = params(fit_mle(GeneralizedPareto, PeakOverThreshold(losses,u)))

    (α->(EVT_VaR(u, k, T, σ, ξ, α))).(vm.αs)
end

@inline EVT_VaR(u, k, T, σ, ξ, α) =  u + σ/ξ * ((T*α/k)^-ξ - 1)
