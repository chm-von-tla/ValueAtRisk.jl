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

    local _, σ, ξ
    try
        _, σ, ξ = params(fit_mle(GeneralizedPareto, PeakOverThreshold(losses,u)))
    catch e
        @warn "ExtremeStats threw $(e.msg). Falling back to native optimization algorithm"
        _, σ, ξ = params(fit_mle(GeneralizedPareto, excesses, u))
    end

    (α->(EVT_VaR(u, k, T, σ, ξ, α))).(vm.αs)
end

@inline EVT_VaR(u, k, T, σ, ξ, α) =  u + σ/ξ * ((T*α/k)^-ξ - 1)

function fit_mle(::Type{<:GeneralizedPareto}, excesses::AbstractVector, u::T) where T<:Real
    objfunc = TwiceDifferentiable(coeffs->_loglik(GeneralizedPareto, excesses, u,
                                                  coeffs[1], coeffs[2]),
                                  [1.,0.05]; autodiff=:forward)
    opt = optimize(objfunc,[1.,0.05])
    σ, ξ = exp.(opt.minimizer)
    GeneralizedPareto(σ,ξ)
end

function _loglik(::Type{<:GeneralizedPareto}, excesses::AbstractVector, uthreshold, log_σ, log_ξ)
    #warning: the assumption ξ ≠ 0 is made since we assume to be working with heavy-tailed
    #data (in which case ξ > 0)
    σ = exp(log_σ)
    ξ = exp(log_ξ)
    n = length(excesses)
    Y = excesses.-uthreshold
    LL = -n*log(σ) -(1 + 1/ξ)*sum(log.(1 .+ ξ.*Y./σ))
    -LL
end
