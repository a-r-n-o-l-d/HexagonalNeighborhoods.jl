
radius = 2
d = []
@neighborhood HexagonalIndex(0, 0, 1) radius N begin 
    push!(d, heuclidean(N, HexagonalIndex(0, 0, 1), 1))
end
@test all(@. d <= radius)
@test length(d) == hcount(radius)

function infunc(I, r)
    d = []
    @neighborhood I r neighbor begin
        push!(d, heuclidean(neighbor, I, 1))
    end
    d
end
radius = 19
I = HexagonalIndex(rand(1:10), rand(1:5), rand(1:2))
d = infunc(I, radius)
@test all(@. d <= radius)
@test length(d) == hcount(radius)

d = []
@neighborhood I neighbor begin
    push!(d, heuclidean(neighbor, I, 1))
end
@test all(@. d <= 1)
@test length(d) == hcount(1)
