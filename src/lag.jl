
"""
    lag(A::AbstractArray, n::Integer)

Shift the elements of `A` along the the axis of the dimension `dim` by `nshift`
elements later. If `dim` is not specified then the dimension returned by
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

julia> lag(A, 1)
4-element NamedAxisArray{Int64,1}
 • time - 2 s:1 s:5 s

  2 s   1
  3 s   2
  4 s   3
  5 s   4

julia> lag([1 2 3; 4 5 6; 7 8 9], 1, 1)
2×3 Array{Int64,2}:
 1  2  3
 4  5  6

julia> lag([1 2 3; 4 5 6; 7 8 9], 1, 2)
3×2 Array{Int64,2}:
 1  2
 4  5
 7  8

```
"""

@inline function lag(A::AbstractArray{T,N}, nshift::Integer, dim::Integer) where {T,N}
    return A[_lag_indices(Val(N), axes(A), nshift, dim)...]
end

@inline function lag(A::AxisArray{T,N}, nshift::Integer, dim::Int) where {T,N}
    indexing_indices = _lag_indices(Val(N), axes(A), nshift, dim)
    p = parent(A)[indexing_indices...]
    axs = _shift_axes(axes(A), indexing_indices, axes(p), dim)
    return unsafe_reconstruct(A, p, axs)
end

function lag(A::NamedAxisArray, dim::Int, n::Int)
    return NamedDimsArray{dimnames(A)}(lag(parent(A), dim, n))
end

@inline function lag(A::AbstractArray{T,N}, nshift::Int) where {T,N}
    if has_timedim(A)
        return lag(A, nshift, timedim(A))
    else
        return lag(A, nshift, N)
    end
end

@inline function _lag_indices(::Val{N}, inds::Tuple, nshift::Integer, dim::Integer) where {N}
    ntuple(Val(N)) do i
        if i === dim
            index = getfield(inds, i)
            firstindex(index):(lastindex(index) - nshift)
        else
            Colon()
        end
    end
end

#=
lag(A::AbstractArray, n::Int) = _lag(A, timedim(A), n)

function _lag(A::NamedAxisArray, dim::Int, n::Int)
    return NamedDimsArray{dimnames(A)}(_lag(parent(A), dim, n))
end
function _lag(A::AxisArray{T,N}, dim::Int, n::Int) where {T,N}
    axs = axes(A)
    p = parent(A)[_lag_indices(axs, dim, n)...]
    newaxs = _lag_axes(axs, axes(p), dim, n)
    return AxisArray{eltype(p),N,typeof(p),typeof(newaxs)}(p, newaxs)
end

# _lag_indices
@inline function _lag_indices(axs::NTuple{N,Any}, dim, n) where {N}
    if dim == 1
        axis = first(axs)
        return (firstindex(axis):lastindex(axis) - n, ntuple(_-> :, Val(N-1))...)
    else
        return (:, _lag_indices(tail(axs), dim, n)...)
    end
end
_lag_indices(::Tuple{}, dim, n) = ()

# _lag_axes
# TODO should probably add support for non AbstractAxis
_lag_axes(::Tuple{}, ::Tuple{}, dim, n) = ()
@inline function _lag_axes(axs::Tuple, newinds::Tuple, dim, n)
    if dim == 1
        return (_lag_axis(first(axs), first(newinds), n), map(assign_indices, tail(axs), tail(newinds))...)
    else
        return (assign_indices(first(axs), first(newinds)), _lag_axes(tail(axs), tail(newinds), dim, n)...)
    end
end

@inline function _lag_axis(axis::AbstractAxis, newinds, n)
    if is_indices_axis(axis)
        return assign_indices(axis, newinds)
    else
        return to_axis(axis, keys(axis)[(firstindex(axis) + n):lastindex(axis)], newinds)
    end
end
=#
