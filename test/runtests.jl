using ValueAtRisk
using Distributions
using Test
using Random
using ARCHModels


@testset "predict" begin
    test_lvls = [0.01,0.025]
    test_archspec = ARCHSpec(EGARCH{1,1,1}, meanspec=ARMA{1,1}, dist=StdSkewT)
    @test predict(HistoricalSimulationVaR(test_lvls),BG96) ≈ -quantile.(Ref(BG96),test_lvls)
    @test predict(EWMAHistoricalSimulationVaR(test_lvls),BG96) ≈ [1.0097709773632497,
                                                                  0.6924229277249955]
    @test predict(EWMARiskMetricsVaR(test_lvls),BG96) ≈ [0.7129791067589807,
                                                         0.6006897706789867]
    @test predict(ARCHVaR(test_lvls),BG96) ≈ (am=fit(GARCH{1,1},BG96);
                                              (α->(predict(am, :VaR; level=α))).(test_lvls))
    ARCHModels_res = (am=fit(EGARCH{1,1,1}, BG96, meanspec=ARMA{1,1}, dist=StdSkewT);
                                              (α->(predict(am, :VaR; level=α))).(test_lvls))
    @test predict(ARCHVaR(test_lvls, archspec=test_archspec), BG96) ≈ ARCHModels_res
    @test predict(FilteredHistoricalSimulationVaR(test_lvls),BG96) ≈ [1.1203427769524021,
                                                                      0.8311624687898621]
    @test predict(FilteredHistoricalSimulationVaR(test_lvls, archspec=test_archspec),
                  BG96) ≈ [1.137636712141567, 0.7868245777588732]
    @test predict(ExtremeValueTheoryVaR(test_lvls),BG96) ≈ [1.4494489094680492,
                                                            1.0900955538454402]
    @test predict(FilteredExtremeValueTheoryVaR(test_lvls),BG96) ≈ [1.424807399619189,
                                                                    1.1049531357158502]
    @test predict(FilteredExtremeValueTheoryVaR(test_lvls, archspec=test_archspec),
                  BG96) ≈ [1.512828548418339, 1.1503812783002576]
    @test predict(CAViaR_ad(test_lvls),BG96) ≈ [1.0569669926351937, 0.5626654417373804]
    @test predict(CAViaR_sym(test_lvls),BG96) ≈ [1.1948822219187047, 0.8192804874236312]
    @test predict(CAViaR_asym(test_lvls),BG96) ≈ [1.2069491626655224, 0.8872412502254272]
end

# print method ambiguities
println("Potentially stale exports: ")
display(Test.detect_ambiguities(ValueAtRisk))
println()
