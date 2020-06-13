
using Documenter, TimeAxes, Dates, AxisIndices, Unitful

makedocs(;
    modules=[TimeAxes],
    format=Documenter.HTML(),
    pages=[
        "index.md"
    ],
    repo="https://github.com/Tokazma/TimeAxes.jl/blob/{commit}{path}#L{line}",
    sitename="TImeAxes.jl",
    authors="Zachary P. Christensen",
)

deploydocs(repo = "github.com/Tokazama/TimeAxes.jl.git")
