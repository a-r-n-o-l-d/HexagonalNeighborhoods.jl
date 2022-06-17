using HexagonalNeighborhoods
using Documenter

DocMeta.setdocmeta!(HexagonalNeighborhoods, :DocTestSetup, :(using HexagonalNeighborhoods); recursive=true)

makedocs(;
    modules=[HexagonalNeighborhoods],
    authors="Arnold",
    repo="https://github.com/a-r-n-o-l-d/HexagonalNeighborhoods.jl/blob/{commit}{path}#{line}",
    sitename="HexagonalNeighborhoods.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://a-r-n-o-l-d.github.io/HexagonalNeighborhoods.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/a-r-n-o-l-d/HexagonalNeighborhoods.jl",
    devbranch="main",
)
