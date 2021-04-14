using ValueAtRisk
using Distributions
using Test
using Random
using ARCHModels


Random.seed!(36)
test_lvls = [0.01,0.025]
test_archspec = ARCHSpec(EGARCH{1,1,1}, meanspec=ARMA{1,1}, dist=StdSkewT)
@testset "predict" begin
    @test isapprox(predict(HistoricalSimulationVaR(test_lvls),BG96), -quantile.(Ref(BG96),test_lvls), rtol=1e-4)
    @test isapprox(predict(EWMAHistoricalSimulationVaR(test_lvls),BG96), [1.0097709773632497, 0.6924229277249955], rtol=1e-4)
    @test isapprox(predict(EWMARiskMetricsVaR(test_lvls),BG96), [0.7129791067589807, 0.6006897706789867], rtol=1e-4)
    @test isapprox(predict(ARCHVaR(test_lvls),BG96), (am=fit(GARCH{1,1},BG96); (α->(predict(am, :VaR; level=α))).(test_lvls)), rtol=1e-4)
    ARCHModels_res = (am=fit(EGARCH{1,1,1}, BG96, meanspec=ARMA{1,1}, dist=StdSkewT);
                                              (α->(predict(am, :VaR; level=α))).(test_lvls))
    @test isapprox(predict(ARCHVaR(test_lvls, archspec=test_archspec), BG96), ARCHModels_res, rtol=1e-4)
    @test isapprox(predict(FilteredHistoricalSimulationVaR(test_lvls),BG96), [1.1203427769524017, 0.8311624687898619], rtol=1e-4)
    @test isapprox(predict(FilteredHistoricalSimulationVaR(test_lvls, archspec=test_archspec), BG96), [1.137636707660993, 0.7868248434849923], rtol=1e-4)
    @test isapprox(predict(ExtremeValueTheoryVaR(test_lvls),BG96), [1.4494467283414116, 1.0900942879197193], rtol=1e-3)
    @test isapprox(predict(FilteredExtremeValueTheoryVaR(test_lvls),BG96), [1.424807399619189, 1.1049531357158502], rtol=1e-4)
    @test isapprox((predict(FilteredExtremeValueTheoryVaR(test_lvls, archspec=test_archspec), BG96)), [1.512828548418339, 1.1503812783002576], rtol=1e-4)
    @test isapprox(predict(CAViaR_ad(test_lvls),BG96), [1.0569669926351937, 0.5626693667827622], rtol=1e-4) || isapprox(predict(CAViaR_ad(test_lvls),BG96), [1.1082793498593972, 0.5626693667827622], rtol=1e-4) ## two different values supplied since the algorithm is unstable
    @test isapprox(predict(CAViaR_sym(test_lvls),BG96), [1.1948822219187047, 0.8192804874236312], rtol=1e-4)
    @test isapprox(predict(CAViaR_asym(test_lvls),BG96), [1.2069491626655224, 0.8872412502254272], rtol=1e-4)
end
@testset "shares_arch_dynamics" begin
    for vm in ValueAtRisk.non_arch_models(test_lvls)
        @test shares_arch_dynamics(vm) == false
    end
    for vm in ValueAtRisk.arch_models(test_lvls,test_archspec)
        @test shares_arch_dynamics(vm) == true
    end
end
@testset "names_format" begin
    vmname_format=r"(?<name_only>.*), (?<confidence_levels>\[.*\] confidence levels)"
    for vm in ValueAtRisk.all_models(test_lvls,test_archspec)
        m = match(vmname_format,repr(vm))
        @test m["name_only"] != nothing && m["confidence_levels"] == "$(round.((1 .- test_lvls), digits=4)) confidence levels"
    end
end

# print method ambiguities
println("Potentially stale exports: ")
display(Test.detect_ambiguities(ValueAtRisk))
println()
