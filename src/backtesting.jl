"""
    backtest(vms::Vector{<:VaRModel}, data::Vector{<:Real},
                  windowsize::Integer;dataset_name::String="Dataset name not specified",
                  lags::Integer=5)

Backtest multiple `VaRModel`s on the supplied dataset. `windowsize` specifies the number of
in-sample observations used for forecasting Value-at-Risk. `backtest(...)` returns a vector
of `BacktestResult`s. The optional parameter `lags` controls the number of lags used in the
the tests of time independence. `dataset_name` may be provided in order to be included in
the `BacktestResult`
"""
function backtest(vms::Vector{<:VaRModel}, data::Vector{<:Real},
                  windowsize::Integer;dataset_name::String="Dataset name not specified",
                  lags::Integer=5)

    T=length(data)

    realizations = data[windowsize+1:end]

    res_dict = init_results_dict(vms,data,T,windowsize)

    archmods = shared_arch_models_dict(vms)

    backtesting_loop!(res_dict,vms,data,windowsize,T,archmods)

    get_backtest_results(res_dict, realizations, windowsize, dataset_name, lags=lags)
end

"""
    backtest(vms::Vector{<:VaRModel}, data::Vector{<:Real},
                  windowsize::Integer;dataset_name::String="Dataset name not specified",
                  lags::Integer=5)

Backtests a single `VaRModel` on the supplied dataset. `windowsize` specifies the number of
in-sample observations used for forecasting Value-at-Risk. `backtest(...)` returns an object
of type `BacktestResult`. The optional parameter `lags` controls the number of lags used in
the the tests of time independence. `dataset_name` may be provided in order to be included
in the `BacktestResult`
"""
function backtest(vm::VaRModel, data::Vector{<:Real},
                  windowsize::Integer;dataset_name::String="Dataset name not specified",
                  lags::Integer=5)
    backtest([vm],data,windowsize,dataset_name=dataset_name,lags=lags)[1]
end

"""
    shared_arch_models_dict(vms::AbstractVector{<:VaRModel})

Return a dict with key an `ARCHSpec` and value a `Union{ARCHModel,Nothing}`
"""
function shared_arch_models_dict(vms::Vector{<:VaRModel})
    result=Dict{ARCHSpec, Union{ARCHModel, Nothing}}()
    for vm in vms
        if shares_arch_dynamics(vm)
            result[vm.asp] = nothing
        end
    end
    result
end

Base.@propagate_inbounds @inline function backtesting_loop!(res_dict,vms,data,windowsize,
                                                            T,archmods)
    @threads for t in windowsize+1:T
        insample = data[t-windowsize:t-1]

        # fit shared arch models
        archmods = fit_models!(archmods, insample)

        for vm in vms
            if shares_arch_dynamics(vm)
                for (asp, am) in pairs(archmods)
                    if vm.asp == asp
                        (res_dict[vm])[t-windowsize] = predict(vm,insample;prefitted=am)
                        break
                    end
                end
            else
                (res_dict[vm])[t-windowsize,:] = predict(vm,insample)
            end
        end
    end
    res_dict
end


@inline function init_results_dict(vms, data, T, windowsize)
    result=Dict{eltype(vms),Array{eltype(data),2}}()
    for vm in vms
        nlvls = length(vm.αs)
        result[vm] = Array{eltype(data),2}(undef, T-windowsize, nlvls)
    end
    result
end

@inline function fit_models!(ams::Dict{ARCHSpec, Union{ARCHModel, Nothing}},data)
    for (asp, am) in pairs(ams)
        ams[am] = flexfit(am,data)
    end
    ams
end

@inline function get_backtest_results(res_dict, realizations, windowsize, dataset_name;
                                          lags=1)
    results = BacktestResult[]
    for (vm, forecasts) in pairs(res_dict)
        for i in 1:length(vm.αs)
            push!(results, BacktestResult(dataset_name, typeof(vm), windowsize,
                                          confidence_levels(vm)[i],
                                          realizations, forecasts[:,i], lags=lags))
        end
    end
    results
end
