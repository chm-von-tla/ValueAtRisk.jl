"""
    CAViaR{T} <: VaRModel{T}

Engle and Manganelli's Conditionally Autoregressive Value at Risk
"""
abstract type CAViaR{T} <: VaRModel{T} end

#########################
# adaptive
"""
    CAViaR_ad{T} <: CAViaR{T}

Engle and Manganelli's Conditionally Autoregressive Value at Risk, adaptive
"""
struct CAViaR_ad{T} <: CAViaR{T}
    αs::Vector{T}
    function CAViaR_ad(confidence_levels::Vector{T}) where T <: Real
        for α in confidence_levels
            0 <= α <= 1 || throw(DomainError(confidence_levels, "element of confidence_levels parameters \"α\" must be in the interval [0,1]"))
        end
        new{T}(confidence_levels)
    end
end
CAViaR_ad(α::T) where T<:Real = CAViaR_ad([α])
Base.show(io::IO,vm::CAViaR_ad) = print(io, "CAViaR adaptive method, $(round.((1 .- vm.αs), digits=4)) confidence levels")
shortname(vm::CAViaR_ad)  = "CAViaR-ad"
confidence_levels(vm::CAViaR_ad) = vm.αs

function predict(vm::CAViaR_ad{T}, data::AbstractVector) where T
    # a multiquantile regression approach maybe could speed the prediction significantly
    (α -> _singleq_predict(CAViaR_ad(α),data)).(vm.αs)
end
function _singleq_predict(vm::CAViaR_ad{T1}, data::AbstractVector) where T1
    length(vm.αs) == 1 || throw("_singleq_predict works with only a single quantile")

    α = vm.αs[1]
    T = length(data)
    empq = quantile(data,α)

    VaRs = similar(data)
    Hits = similar(data)

    β′ = _cav_optim_loop!(β->CAViaR_obj!(vm,β,data,VaRs,Hits,empq,α,T), 1, BFGS())
    VaRs[end]
end

@inline function CAViaR_obj!(vm::CAViaR_ad,β,data,VaRs,Hits,empq,α,T)
    CAViaR_obj_init!(data,VaRs,Hits,empq,α)
    @inbounds for i in 2:T
        VaRs[i] = VaRs[i-1] + β[1]*((data[i-1] < -VaRs[i-1] ? 1 : 0) - α)
        Hits[i] = (data[i] < -VaRs[i] ? 1 : 0) - α
    end
    CAViaR_obj_qr(data,VaRs,Hits)
end

#########################
# symmetric
"""
    CAViaR_sym{T} <: CAViaR{T}

Engle and Manganelli's Conditionally Autoregressive Value at Risk, symmetric absolute value
"""
struct CAViaR_sym{T} <: CAViaR{T}
    αs::Vector{T}
    function CAViaR_sym(confidence_levels::Vector{T}) where T <: Real
        for α in confidence_levels
            0 <= α <= 1 || throw(DomainError(confidence_levels, "element of confidence_levels parameters \"α\" must be in the interval [0,1]"))
        end
        new{T}(confidence_levels)
    end
end
CAViaR_sym(α::T) where T<:Real = CAViaR_sym([α])
Base.show(io::IO,vm::CAViaR_sym) = print(io, "CAViaR symmetric absolute value method, $(round.((1 .- vm.αs), digits=4)) confidence levels")
shortname(vm::CAViaR_sym)  = "CAViaR-sym"
confidence_levels(vm::CAViaR_sym) = vm.αs

function predict(vm::CAViaR_sym{T}, data::AbstractVector) where T
    # a multiquantile regression approach maybe could speed the prediction significantly
    (α -> _singleq_predict(CAViaR_sym(α),data)).(vm.αs)
end
function _singleq_predict(vm::CAViaR_sym{T1}, data::AbstractVector) where T1
    length(vm.αs) == 1 || throw("_singleq_predict works with only a single quantile")

    α = vm.αs[1]
    T = length(data)
    empq = quantile(data,α)

    VaRs = similar(data)
    Hits = similar(data)

    β′ = _cav_optim_loop!(β->CAViaR_obj!(vm,β,data,VaRs,Hits,empq,α,T), 3, NelderMead())
    VaRs[end]
end

@inline function CAViaR_obj!(vm::CAViaR_sym,β,data,VaRs,Hits,empq,α,T)
    CAViaR_obj_init!(data,VaRs,Hits,empq,α)
    @inbounds for i in 2:T
        VaRs[i] = β[1] + β[2]*VaRs[i-1] + β[3]*abs(data[i-1])
        Hits[i] = (data[i] < -VaRs[i] ? 1 : 0) - α
    end
    CAViaR_obj_qr(data,VaRs,Hits)
end

#########################
# asymmetric
"""
    CAViaR_asym{T} <: CAViaR{T}

Engle and Manganelli's Conditionally Autoregressive Value at Risk, asymmetric slope
"""
struct CAViaR_asym{T} <: CAViaR{T}
    αs::Vector{T}
    function CAViaR_asym(confidence_levels::Vector{T}) where T <: Real
        for α in confidence_levels
            0 <= α <= 1 || throw(DomainError(confidence_levels, "element of confidence_levels parameters \"α\" must be in the interval [0,1]"))
        end
        new{T}(confidence_levels)
    end
end
CAViaR_asym(α::T) where T<:Real = CAViaR_asym([α])
Base.show(io::IO,vm::CAViaR_asym) = print(io, "CAViaR asymmetric slope method, $(round.((1 .- vm.αs), digits=4)) confidence levels")
shortname(vm::CAViaR_asym)  = "CAViaR-asym"
confidence_levels(vm::CAViaR_asym) = vm.αs

function predict(vm::CAViaR_asym{T}, data::AbstractVector) where T
    # a multiquantile regression approach maybe could speed the prediction significantly
    (α -> _singleq_predict(CAViaR_asym(α),data)).(vm.αs)
end
function _singleq_predict(vm::CAViaR_asym{T1}, data::AbstractVector) where T1
    length(vm.αs) == 1 || throw("_singleq_predict works with only a single quantile")

    α = vm.αs[1]
    T = length(data)
    empq = quantile(data,α)

    VaRs = similar(data)
    Hits = similar(data)

    β′ = _cav_optim_loop!(β->CAViaR_obj!(vm,β,data,VaRs,Hits,empq,α,T), 4, NelderMead())
    VaRs[end]
end

@inline function CAViaR_obj!(vm::CAViaR_asym,β,data,VaRs,Hits,empq,α,T)
    CAViaR_obj_init!(data,VaRs,Hits,empq,α)
    @inbounds for i in 2:T
        VaRs[i] = β[1] + β[2]*VaRs[i-1] + β[3]*max(data[i-1],0) + β[4]*min(data[i-1],0)
        Hits[i] = (data[i] < -VaRs[i] ? 1 : 0) - α
    end
    CAViaR_obj_qr(data,VaRs,Hits)
end


##########################################
# shared utility functions
@inline  @inbounds function CAViaR_obj_init!(data,VaRs,Hits,empq,α)
    VaRs[1] = -empq
    Hits[1] = (data[1] < -VaRs[1] ? 1 : 0) - α
end
@inline CAViaR_obj_qr(data,VaRs,Hits) = -Hits'*(data+VaRs)

function _cav_optim_loop!(fun,coef_len,fst_optmzr)
    opt = optimize(fun, ones(coef_len), fst_optmzr)
    tries = 1
    while !Optim.converged(opt) && tries <= 10
        opt = optimize(fun, ones(coef_len), fst_optmzr)
        tries += 1
    end
    β′ = Optim.minimizer(opt)
    tries = 1
    while !Optim.converged(opt) && tries <= 3
        opt = optimize(fun, β′,BFGS())
        tries += 1
    end
    Optim.minimizer(opt)
end
