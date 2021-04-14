# Models 
```@meta
CurrentModule = ValueAtRisk
DocTestSetup  = quote
    using ValueAtRisk
end
```

Value-at-Risk models currently available:
  - [`HistoricalSimulationVaR`](@ref)
  - [`EWMAHistoricalSimulationVaR`](@ref)
  - [`FilteredHistoricalSimulationVaR`](@ref)*
  - [`EWMARiskMetricsVaR`](@ref)
  - CAViaR (adaptive,symmetric absolute value, asymmetrics slope)
    - [`CAViaR_ad`](@ref)
    - [`CAViaR_sym`](@ref)
    - [`CAViaR_asym`](@ref)
  - [`ARCHVaR`](@ref)*
  - [`ExtremeValueTheoryVaR`](@ref)
  - [`FilteredExtremeValueTheoryVaR`](@ref)*

For models marked with `*` an ARCH dynamics specification may be supplied:
   [`ARCHSpec`](@ref)


