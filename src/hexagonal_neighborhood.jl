# move to package HexagonalNeighborhood

# => macro hexcoord(neigborhood, I, body) :(@neighborhood(zero(HexagonalIndex), $neigborhood.radius, $N, $body)) end

struct NeighborhoodIndex
    I
    i
end

Base.Tuple(I::NeighborhoodIndex) = Tuple(I.I)

Base.@propagate_inbounds Base.getindex(A::HexagonalArray, I::NeighborhoodIndex) = harray(A)[Tuple(I)...]

Base.@propagate_inbounds Base.setindex!(A::HexagonalArray, v, I::NeighborhoodIndex) = (harray(A)[Tuple(I)...] = v)

# Extends function of HexagonalIndex
# arithmetic operators
to_cartesian(I::NeighborhoodIndex, d_unit) = to_cartesian(I.I, d_unit)

heuclidean(I1::NeighborhoodIndex, I2::HexagonalIndex, d_unit) = heuclidean(I1.I, I2, d_unit)

heuclidean(I1::HexagonalIndex, I2::NeighborhoodIndex, d_unit) = heuclidean(I1, I2.I, d_unit)

heuclidean(I1::NeighborhoodIndex, I2::NeighborhoodIndex, d_unit) = heuclidean(I1.I, I2.I, d_unit)

struct HexagonalNeighborhood{T} <: AbstractVector{T}
    neighborhood::Vector{T}
    radius
end

HexagonalNeighborhood(T::Type, radius) = HexagonalNeighborhood(Vector{Int}(undef, hcount(radius)), radius)

HexagonalNeighborhood(A::HexagonalArray, radius) = HexagonalNeighborhood(eltype(A), radius)

neighborhood(N) = N.neighborhood

radius(N) = N.radius

Base.size(N::HexagonalNeighborhood) = size(N.neighborhood)

Base.@propagate_inbounds Base.getindex(N::HexagonalNeighborhood, i) = N.neighborhood[i]

Base.@propagate_inbounds Base.setindex!(N::HexagonalNeighborhood, v, i) = (N.neighborhood[i] = v)

Base.@propagate_inbounds Base.getindex(N::HexagonalNeighborhood, I::NeighborhoodIndex) = N.neighborhood[I.i]

Base.@propagate_inbounds Base.setindex!(N::HexagonalNeighborhood, v, I::NeighborhoodIndex) = (N.neighborhood[I.i] = v)


macro neighborhood(I, radius, N, body)
    quote
        local count = 1
        local i, j, k = Tuple($(esc(I)))
        local Δj = $(esc(radius)) >> 1
        for oj in -Δj:Δj
            local Δi = $(esc(radius)) - abs(oj)
            for oi in -Δi:Δi
                $(esc(N)) = NeighborhoodIndex(HexagonalIndex(i + oi, j + oj, k), count)
                $(esc(body))
                count += 1
            end
        end
        local i = i + k - 2
        local j = j + k - 2
        local Δj = ($(esc(radius)) + 1) >> 1
        for oj in -Δj + 1:Δj
            local Δi = trunc(Int, $(esc(radius)) - abs(oj - 0.5) - 0.5)
            for oi in -Δi:Δi + 1
                $(esc(N)) = NeighborhoodIndex(HexagonalIndex(i + oi, j + oj, 3 - k), count)
                $(esc(body))
                count += 1
            end
        end
    end
end

function _neighborhood(I::HexagonalIndex)
    r, c, a = I.I
    r1, c1 = r + a - 2, c + a - 2
    r2, c2 = r1 + 1, c1 + 1
    a_ = 3 - a
    (r - 1, c, a),
    (r,     c, a),
    (r + 1, c, a),
    (r1,    c1, a_),
    (r2,    c1, a_),
    (r1,    c2, a_),
    (r2,    c2, a_)
end

macro neighborhood(I, N, body)
    quote
        local count = 1
        for n in _neighborhood($(esc(I)))
            $(esc(N)) = NeighborhoodIndex(HexagonalIndex(n), count)
            $(esc(body))
            count += 1
        end
    end
end

macro cneighborhood(radius, N, body) #HexagonalNeighborhood
    :(@neighborhood(zero(HexagonalIndex), $radius, $N, $body))
end

