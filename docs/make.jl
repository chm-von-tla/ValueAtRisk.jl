using Value_at_Risk
using Documenter

DocMeta.setdocmeta!(Value_at_Risk, :DocTestSetup, :(using Value_at_Risk); recursive=true)

makedocs(;
    modules=[Value_at_Risk],
    authors="Charis P. Michelakis <ch.p.michelakis@gmail.com>",
    repo="https://github.com/chm-von-tla/Value_at_Risk.jl/blob/{commit}{path}#{line}",
    sitename="Value_at_Risk.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
