using ValueAtRisk
using Documenter

DocMeta.setdocmeta!(ValueAtRisk, :DocTestSetup, :(using ValueAtRisk); recursive=true)

makedocs(;
    modules=[ValueAtRisk],
    authors="Charis P. Michelakis <ch.p.michelakis@gmail.com>",
    repo="https://github.com/chm-von-tla/ValueAtRisk.jl/blob/{commit}{path}#{line}",
    sitename="ValueAtRisk.jl",
    format=:html,
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(
    repo = "github.com/chm-von-tla/ValueAtRisk.jl.git",
)
