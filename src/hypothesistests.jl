"""
    DQTest <: HypothesisTest
Christoffersen's (1998) Unconditional Coverage Likelihood Ratio test (out of sample)
"""
struct LRucTest{T1<:Real} <: HypothesisTest
    observations::Int
    violations::Int
    level::T1
    LRuc::T1
end

testname(::LRucTest) = "Christoffersen's (1998) Unconditional Coverage Likelihood Ratio test (out of sample)"

"""
    LRucTest(violations::AbstractArray{Bool},level)

Conduct Christoffersen's (1998) Unconditional Coverage Likelihood Ratio test by passing a
a `AbstractArray{Bool}` representing the violations/hits sequence and the `VaRModel` quantile level
"""
function LRucTest(violations::AbstractArray{Bool},level)
    T=length(violations)
    v = sum(violations) # number of violations
    α′ = v/T
    α = level

    LR = -2*(v*log(α)+(T-v)*log(1-α)) + 2*(v*log(α′)+(T-v)*log(1-α′))

    LRucTest(T,v,α,LR)
end

"""
    LRucTest(data::Vector{T}, vars::Vector{T},level)

Conduct Christoffersen's (1998) Unconditional Coverage Likelihood Ratio test by passing a
a vector of realizations accompanied by a vector of the correponding VaR forecasts and the
`VaRModel` quantile level
"""
function LRucTest(data::Vector{T}, vars::Vector{T}, level) where T<:Real
    @assert length(data) == length(vars)
    violations = data .< -vars
    LRucTest(violations, level)
end

function show_params(io::IO, x::LRucTest, ident)
    println(io, ident, "sample size:                    ", x.observations)
    println(io, ident, "number of violations:           ", x.violations)
    println(io, ident, "violation percentage:           ", x.violations/x.observations)
    println(io, ident, "VaR quantile level              ", x.level)
    println(io, ident, "LRuc statistic:                 ", x.LRuc)
end

pvalue(x::LRucTest) = pvalue(Chisq(1), x.LRuc; tail=:right)
population_param_of_interest(x::LRucTest) = ("Likelihood Ratio statistic for percentage of violations", 0, x.LRuc)

"""
    LjungBoxTest(data::Vector{T}, vars::Vector{T}, lag::Integer=1)

Compute the Ljung-Box `Q` statistic to test the null hypothesis of independence in the
violations/hits sequence that is implied by the vectors of realizations (`data`) and
Value-at-Risk forecasts(`vars`). `lag` specifies the number of lags used in the construction of `Q`
"""
function LjungBoxTest(data::Vector{T}, vars::Vector{T}, lag::Integer=1) where T<:Real
    @assert length(data) == length(vars)
    violations = data .< -vars
    LjungBoxTest(violations, lag)
end
