"""
    struct BacktestResult{T<:Real}

A type that contains information on the results of backtesting a `VaRModel` on a dataset.
"""
struct BacktestResult{T<:Real}
    dataset::String
    vm::Type{<:VaRModel}
    windowsize::Int
    observations::Int
    violations::Int
    confidence_level::T
    LRuc::LRucTest
    DQ::DQTest
    LB::LjungBoxTest
end

"""
    BacktestResult(dataset::String, vm::Type{<:VaRModel}, windowsize::Integer, level::T1,
                   data::Vector{T1}, vars::Vector{T1}; lags::Integer=1) where T1<:Real

Create an object of type `BacktestResult`. `dataset` specifies the name of the dataset on
which Value-at-Risk backtesting was performed. `vm` specifies the `VaRModel` used for
obtaining Value-at-Risk estimates. `windowsize` specifies the number of in-sample
observations that were used to obtain each out-of-sample VaR forecast. `level` is VaR
quantile level. `data` is the vector of realizations, while `vars` is the vector of VaR
estimates. The optional parameter `lags` specifies the number of lags used in the `DQTest`
and `LjungBoxTest` for testing the time independence of the violations/hits sequence of VaR
estimates.
"""
function BacktestResult(dataset::String, vm::Type{<:VaRModel}, windowsize::T2, level::T1,
                        data::Vector{T1}, vars::Vector{T1}; lags::T2=1) where {T1<:Real,
                                                                               T2<:Integer}
    @assert length(data) == length(vars)
    violations = data .< -vars
    LR = LRucTest(violations,level)
    DQ = DQTest(data, vars, level,lags)
    LB = LjungBoxTest(violations,lags)

    BacktestResult(dataset, vm, windowsize, length(violations), sum(violations), level, LR,
                   DQ, LB)
end
