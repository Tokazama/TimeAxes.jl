
"""
    lead(A::AbstractArray, nshift::Integer[, dim::Integer])

Shift the elements of `A` along the the axis of the dimension `dim` by `nshift`
elements earlier. If `dim` is not specified then the dimension returned by
`timedim` is used. If `A` does not have a time dimension then the last dimension
is assumed to be the time dimension.

## Examples
```jldoctest
julia> using TimeAxes

julia> using Unitful: s

julia> A = NamedAxisArray{(:time,)}(collect(1:5), (1:5)s)
5-element NamedAxisArray{Int64,1}
 • time - 1 s:1 s:5 s

  1 s   1
  2 s   2
  3 s   3
  4 s   4
  5 s   5

julia> lead(A, 1)
4-element NamedAxisArray{Int64,1}
 • time - 1 s:1 s:4 s

  1 s   2
  2 s   3
  3 s   4
  4 s   5

julia> lead([1 2 3; 4 5 6; 7 8 9], 1, 1)
2×3 Array{Int64,2}:
 4  5  6
 7  8  9

julia> lead([1 2 3; 4 5 6; 7 8 9], 1, 2)
3×2 Array{Int64,2}:
 2  3
 5  6
 8  9

```
"""
@inline function lead(A::AbstractArray{T,N}, nshift::Integer, dim::Integer) where {T,N}
    return A[_lead_indices(Val(N), axes(A), nshift, dim)...]
end

@inline function lead(A::AxisArray{T,N}, nshift::Integer, dim::Int) where {T,N}
    indexing_indices = _lead_indices(Val(N), axes(A), nshift, dim)
    p = parent(A)[indexing_indices...]
    axs = _shift_axes(axes(A), indexing_indices, axes(p), dim)
    return unsafe_reconstruct(A, p, axs)
end

function lead(A::NamedAxisArray, dim::Int, n::Int)
    return NamedDimsArray{dimnames(A)}(lead(parent(A), dim, n))
end

@inline function lead(A::AbstractArray{T,N}, nshift::Int) where {T,N}
    if has_timedim(A)
        return lead(A, nshift, timedim(A))
    else
        return lead(A, nshift, N)
    end
end

@inline function _lead_indices(::Val{N}, inds::Tuple, nshift::Integer, dim::Integer) where {N}
    ntuple(Val(N)) do i
        index = getfield(inds, i)
        if i === dim
            index = getfield(inds, i)
            (firstindex(index) + nshift):lastindex(index)
        else
            Colon()
        end
    end
end
