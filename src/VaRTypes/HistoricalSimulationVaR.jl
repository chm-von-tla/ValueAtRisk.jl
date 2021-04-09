"""
    HistoricalSimulationVaR{T} <: VaRModel{T}

A naive Historical Simulation approach in which the VaR estimates is the corresponding
quantile of the empirical distribution of returns
"""
struct HistoricalSimulationVaR{T} <: VaRModel{T}
    αs::Vector{T}
    function HistoricalSimulationVaR(confidence_levels::Vector{T}) where T
        for α in confidence_levels
            0 <= α <= 1 || throw(DomainError(confidence_levels,
             "element of confidence_levels parameters \"α\" must be in the interval [0,1]"))
        end
        new{T}(confidence_levels)
    end
end
HistoricalSimulationVaR(α::T) where T<:Real = HistoricalSimulationVaR([α])
Base.show(io::IO,vm::HistoricalSimulationVaR) = print(io, "Historical Simulation (naive empirical quantile approach), $(round.((1 .- vm.αs), digits=4)) confidence levels")
shortname(vm::HistoricalSimulationVaR)  = "HS"
confidence_levels(vm::HistoricalSimulationVaR) = vm.αs

predict(vm::HistoricalSimulationVaR{T}, data::AbstractVector) where T = -quantile.(Ref(data),vm.αs)
