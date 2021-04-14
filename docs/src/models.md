# Models 
```@meta
CurrentModule = ValueAtRisk
DocTestSetup  = quote
    using ValueAtRisk
end
```

Value-at-Risk models currently available:

  - Historical Simulation

```@docs
HistoricalSimulationVaR
```
test 1 
```@autodocs
HistoricalSimulationVaR
```
test 2

[`HistoricalSimulationVaR`](@ref)

-----------------------------------



```@docs
ValueAtRisk.HistoricalSimulationVaR
```
test 1 
```@autodocs
ValueAtRisk.HistoricalSimulationVaR
```
test 2

[`ValueAtRisk.HistoricalSimulationVaR`](@ref)






  - EWMA Scaled/Filtered Historical Simulation
```@docs
EWMAHistoricalSimulationVaR
```
  - (GARCH) Filtered Historical simulation*
```@docs
FilteredHistoricalSimulationVaR
```
  - EWMA RiskMetrics approach
```@docs
EWMARiskMetricsVaR
```
  - CAViaR (adaptive,symmetric absolute value, asymmetrics slope)
```@docs
CAViaR_ad
```
```@docs
CAViaR_sym
```
```@docs
CAViaR_asym
```
  - ARCH models*
```@docs
ARCHVaR
```
  - Extreme Value Theory
```@docs
ExtremeValueTheoryVaR
```
  - Filtered Extreme Value Theory*
```@docs
FilteredExtremeValueTheoryVaR
```
  
For models marked with `*` an ARCH dynamics specification may be supplied:
```@docs
ARCHSpec
```

