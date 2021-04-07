abstract type ForecastingModel end

abstract type VaRModel{T} <: ForecastingModel where T <: Real end

"""
    shortname(vm::VaRModel)

Print a short description for the model given
"""
shortname(vm::VaRModel) = throw("shortname not implemented for model: $(vm)")
"""
    confidence_levels(vm::VaRModel)

Return the confidence level(s) for the given model
"""
confidence_levels(vm::VaRModel) = throw("confidence_levels not implemented for model: $(vm)")

"""
    has_arch_dynamics(vm::VaRModel)

Whether the given model contains a specification for autoregressive conditionaly
heteroskedastic dynamics. If models share such a specification the model is fitted only once
during backtesting
"""
has_arch_dynamics(vm::VaRModel) = false

"""
    predict(vm::VaRModel, data::AbstractVector)

Return a one-step ahead VaR forecast with `VaRModel` vm for the provided data vector
"""
predict(vm::VaRModel, data::AbstractVector) = throw("predict not implemented for model: $(vm)")
