using ValueAtRisk
using Documenter

DocMeta.setdocmeta!(ValueAtRisk, :DocTestSetup, :(using ValueAtRisk); recursive=true)

makedocs(;
    modules=[ValueAtRisk],
    authors="Charis P. Michelakis <ch.p.michelakis@gmail.com>",
    repo="https://github.com/chm-von-tla/ValueAtRisk.jl/blob/{commit}{path}#{line}",
    sitename="ValueAtRisk.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://chm-von-tla.github.io/ValueAtRisk.jl",
        assets=String[],
    ),

    pages=[
        "Home" => "index.md",
        "Usage" => "usage.md",
        "VaR methods available" => "models.md",
        "Reference Guide" => "autodocs.md"
    ],
)

deploydocs(
    repo = "github.com/chm-von-tla/ValueAtRisk.jl.git",
)
