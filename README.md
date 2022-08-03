# ValueAtRisk.jl

[![version](https://juliahub.com/docs/ValueAtRisk/version.svg)](https://juliahub.com/ui/Packages/ValueAtRisk/HUjPU)
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://chm-von-tla.github.io/ValueAtRisk.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://chm-von-tla.github.io/ValueAtRisk.jl/dev)
[![Build Status](https://github.com/chm-von-tla/ValueAtRisk.jl/workflows/CI/badge.svg)](https://github.com/chm-von-tla/ValueAtRisk.jl/actions)
[![Build Status](https://travis-ci.com/chm-von-tla/ValueAtRisk.jl.svg?branch=master)](https://travis-ci.com/chm-von-tla/ValueAtRisk.jl)
[![Coverage](https://codecov.io/gh/chm-von-tla/ValueAtRisk.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/chm-von-tla/ValueAtRisk.jl)
[![pkgeval](https://juliahub.com/docs/ValueAtRisk/pkgeval.svg)](https://juliahub.com/ui/Packages/ValueAtRisk/HUjPU)
[![deps](https://juliahub.com/docs/ValueAtRisk/deps.svg)](https://juliahub.com/ui/Packages/ValueAtRisk/HUjPU?t=2)

# ValueAtRisk

[Value-at-Risk](https://en.wikipedia.org/wiki/Value_at_risk) is a method for measuring the risk of extremal losses in financial investments. [Nieto and Ruiz (2016)](https://doi.org/10.1016/j.ijforecast.2015.08.003) and [Kuester et al. (2005)](https://doi.org/10.1093/jjfinec/nbj002) provide a good overview of the subject. 

This package is still at an experimental development stage. It has been written in a way to accomondate the needs of my thesis. (If you want to take a look at it you can find it [here](https://www.pyxida.aueb.gr/index.php?op=view_object&object_id=8462). The model mentioned as EWMA in the thesis corresponds to the `EWMAHistoricalSimulationVaR` model in this package. The usual RiskMetrics EWMA model has  not been used in the thesis and has been added here as `EWMARiskMetricsVaR`. The code for the LASSO-GARCH model has not been uploaded at the moment since it was a novel approach that required/requires more research) 

Please check the [documentation](https://chm-von-tla.github.io/ValueAtRisk.jl/dev) for more regarding use of the package and implementation concerns. 

Any feedback is appreciated!

# Installation

`ValueAtRisk` is a registered Julia package. To install it , do

```
add ValueAtRisk
```

in the Pkg REPL mode (which is entered by pressing `]` at the prompt).

Alternatively you may run `using Pkg; Pkg.add("ValueAtRisk")` at the repl

# Usage

Check the [documentation](https://chm-von-tla.github.io/ValueAtRisk.jl/dev)
