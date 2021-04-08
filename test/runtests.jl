using Value_at_Risk
using Test
using Random

@testset "Value_at_Risk.jl" begin
    # Write your tests here.
end

# print method ambiguities
println("Potentially stale exports: ")
display(Test.detect_ambiguities(ValueAtRisk))
println()
