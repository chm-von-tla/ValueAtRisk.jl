"""
    ARCHSpec{VS<:UnivariateVolatilitySpec,
             SD<:StandardizedDistribution{T},
             MS<:MeanSpec{T}
             }
"""
struct ARCHSpec6{T<:AbstractFloat,
                VS<:UnivariateVolatilitySpec,
                SD<:StandardizedDistribution{T},
                MS<:MeanSpec{T}
                }
    volspec::VS
    dist::SD
    meanspec::MS
    function ARCHSpec6{T, VS, SD, MS}(volspec, dist=StdNormal(), meanspec=Intercept()) where {T, VS, SD, MS}
        new(volspec, dist, meanspec)
    end
end
struct ARCHSpec{VS<:UnivariateVolatilitySpec,
                MS<:MeanSpec{<:AbstractFloat},
                }
    volspec::VS
    meanspec::MS
    function ARCHSpec{VS, MS}(volspec, meanspec=Intercept()) where {VS, MS}
        new(volspec, meanspec)
    end
end
struct ARCHSpec2{SD<:StandardizedDistribution{<:AbstractFloat},
                 MS<:MeanSpec{<:AbstractFloat}
                 }
    dist::SD
    meanspec::MS
    function ARCHSpec2{SD, MS}(dist=StdNormal(), meanspec=Intercept()) where {SD, MS}
        new(dist, meanspec)
    end
end
struct ARCHSpec7{VS<:UnivariateVolatilitySpec{<:AbstractFloat},
                 SD<:StandardizedDistribution{<:AbstractFloat},
                 MS<:MeanSpec{<:AbstractFloat}
                 }
    volspec::VS
    dist::SD
    meanspec::MS
    function ARCHSpec7(volspec::VS; dist::SD=StdNormal(), meanspec::MS=Intercept()) where {VS<:UnivariateVolatilitySpec{<:AbstractFloat},
                                                                                           SD<:StandardizedDistribution{<:AbstractFloat},
                                                                                           MS<:MeanSpec{<:AbstractFloat}}
        new{VS,SD,MS}(volspec, dist, meanspec)
    end
end
typeof(Intercept())
Intercept{T}() where T<:AbstractFloat = InterceptIncomplete(T[])
egarch_spec = ARCHSpec5(StdNormal(),AR{1})
egarch_spec = ARCHSpec7(EGARCH{1,1,1}(),StdNormal(),Intercept())
typeof(Type{TGARCH{1,1,1,Float64}})
typeof(TGARCH{1,1,1,Float64})
ARCHSpec2()
typeof(StdNormal(),Intercept([2.]))
typeof(Intercept)
print("done")
abstract type ForecastingModel end

# TODO: is statisticalmodel a proper supertype?
"""
	VaRModel <: StatisticalModel
"""
abstract type VaRModel <: ForecastingModel end

# TODO: check if this works
# # this makes predict.(am, :variance, 1:3) work
# Base.Broadcast.broadcastable(vm::VaRModel) = Ref(vm)

"""
    InterceptIncomplete{T} <: MeanSpec{T}

An incomplete constructor for a mean specification with just an intercept. An
object of type Intercept{T} <: MeanSpec is constructed when the data becomes
available
"""
struct InterceptIncomplete{T} <: MeanSpec{T}
    coefs::Vector{T}
    function InterceptIncomplete{T}(coefs::Vector) where {T}
        length(coefs) == 0 || throw(NumParamError(0, length(coefs)))
        new{T}(coefs)
    end
end

"""
    Intercept(T::Type=Float64)
    Intercept{T}()

Create an instance of InterceptIncomplete. These constructors do not interfere
with the constructor for the completed instance(ARCHModels.Intercept{T}).
"""
Intercept(T::Type=Float64) = InterceptIncomplete(T[])
Intercept{T}() where {T} = InterceptIncomplete(T[])

"""
    TGARCHIncomplete{o,p,q,T} <: UnivariateVolatilitySpec{T}

An incomplete constructor for the TGARCH volatility specification spec. An
object of type TGARCH{o,p,q,T}<:UnivariateVolatilitySpec{T} is constructed when
the data becomes available

"""
struct TGARCHIncomplete{o,p,q,T} <: UnivariateVolatilitySpec{T}
    coefs::Vector{T}
    function TGARCHIncomplete{o,p,q,T}(coefs::Vector) where {o,p,q,T}
        length(coefs) == 0 || throw(NumParamError(0, length(coefs)))
        new{o,p,q,T}(coefs)
    end
end

"""
    TGARCH{o,p,q}(T::Type=Float64)
    TGARCH{o,p,q,T}()

Create an instance of TGARCHIncomplete{o,p,q,T}. These constructors do not interfere
with the constructor for the completed instance(ARCHModels.TGARCH{o,p,q,T}).
"""
TGARCH{o, p, q}(T::Type=Float64) where {o ,p ,q, T1} = TGARCHIncomplete{o, p, q, T1}(T1[])
TGARCH{o, p, q}() where {o ,p ,q, T} = TGARCHIncomplete{o, p, q, Float64}(Float64[])

"""
    EGARCHIncomplete{o,p,q,T} <: UnivariateVolatilitySpec{T}

An incomplete constructor for the EGARCH volatility specification spec. An
object of type EGARCH{o,p,q,T}<:UnivariateVolatilitySpec{T} is constructed when
the data becomes available

"""
struct EGARCHIncomplete{o,p,q,T} <: UnivariateVolatilitySpec{T}
    coefs::Vector{T}
    function EGARCHIncomplete{o,p,q,T}(coefs::Vector) where {o,p,q,T}
        length(coefs) == 0 || throw(NumParamError(0, length(coefs)))
        new{o,p,q,T}(coefs)
    end
end

"""
    EGARCH{o,p,q}(T::Type=Float64)
    EGARCH{o,p,q,T}()

Create an instance of EGARCHIncomplete{o,p,q,T}. These constructors do not interfere
with the constructor for the completed instance(ARCHModels.EGARCH{o,p,q,T}).
"""
EGARCH{o, p, q}(T::Type=Float64) where {o ,p ,q, T1} = EGARCHIncomplete{o, p, q, T1}(T1[])
EGARCH{o, p, q}() where {o ,p ,q, T} = EGARCHIncomplete{o, p, q, Float64}(Float64[])

##################################################################################################
struct ARCHSpec0
    volspec
    archspec_kwargs
    function ARCHSpec0(volspec; kwargs...)
        ksargs = Dict(kwargs)
        new(volspec,kwargs)
    end
end

asp = ARCHSpec0(GARCH{1,1};dist=StdNormal(),meanspec=Intercept)
