"""
    ARCHVaR{T} <: VaRModel{T}

Estimate VaR using an autoregressive conditional heteroskedasticity model
"""
struct ARCHVaR{T} <: VaRModel{T}
    αs::Vector{T}
    asp::ARCHSpec
    function ARCHVaR(confidence_levels::Vector{T};
                     archspec::ARCHSpec=ARCHSpec(GARCH{1,1})) where {T<:Real}
        for α in confidence_levels
            0 <= α <= 1 || throw(DomainError(confidence_levels, "element of confidence_levels parameters \"α\" must be in the interval [0,1]"))
        end
        new{T}(confidence_levels,archspec)
    end
end
function ARCHVaR(α::T;archspec::ARCHSpec=ARCHSpec(GARCH{1,1})) where T<:Real
    ARCHVaR([α],archspec=archspec)
end
Base.show(io::IO,vm::ARCHVaR) = print(io, "$(vm.asp), $(round.((1 .- vm.αs), digits=4)) confidence levels")
shortname(vm::ARCHVaR)  = shortname(vm.asp)
confidence_levels(vm::ARCHVaR) = vm.αs
has_arch_dynamics(vm::ARCHVaR) = true

function predict(vm::ARCHVaR{T}, data::AbstractVector;
                 prefitted::Union{ARCHModel, Nothing}=nothing) where T
    # every model that shares arch dynamics is computed on the right tail of the negative of
    # in order to be compatible with the Extreme Value Theory models
    αs′ = 1 .- vm.αs
    losses = -data

    am = dupefit(losses,vm.asp,prefitted=prefitted)

    (α′ -> predict(am, :VaR; level=α′)).(αs′)
end
