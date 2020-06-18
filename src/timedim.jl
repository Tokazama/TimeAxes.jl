
Base.@pure is_time(x::Symbol) = (x === :time) || (x === :Time)

AxisIndices.@defdim time is_time

"""
    time_end(x)

Last time point along the time axis.
"""
time_end(x) = last(time_keys(x))

"""
    onset(x)

First time point along the time axis.
"""
onset(x) = first(time_keys(x))

"""
    time_step(x)

The time step/interval between each element.
"""
time_step(x) = step(time_keys(x))

"""
    duration(x)

Duration of the event along the time axis.
"""
duration(x) = time_end(x) - onset(x) + time_step(x)

"""
    sampling_rate(x)

Number of samples per second.
"""
sampling_rate(x) = 1 / time_step(x)

"""
    assert_timedim_last(x)

Throw an error if the `x` has a time dimension that is not the last dimension.
"""
@inline assert_timedim_last(x) = is_time(last(dimnames(x)))


"""
    lead(A::AbstractArray, n::Integer)

Shift the elements of `A` along the time axis so that they are `n` time units sooner.

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

```
"""
lead(A::AbstractArray, n::Int) = _lead(A,  timedim(A), n)

"""
    lag(A::AbstractArray, n::Integer)

Shift the elements of `A` along the time axis so that they are `n` time units later.

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

```
"""
lag(A::AbstractArray, n::Int) = _lag(A, timedim(A), n)


###
### lead
###
function _lead(A::NamedAxisArray, dim::Int, n::Int)
    return NamedDimsArray{dimnames(A)}(_lead(parent(A), dim, n))
end

function _lead(A::AxisArray{T,N}, dim::Int, n::Int) where {T,N}
    axs = axes(A)
    p = parent(A)[_lead_indices(axs, dim, n)...]
    newaxs = _lead_axes(axs, axes(p), dim, n)
    return AxisArray{eltype(p),N,typeof(p),typeof(newaxs)}(p, newaxs)
end

# _lead_indices
@inline function _lead_indices(axs::NTuple{N,Any}, dim, n) where {N}
    if dim == 1
        axis = first(axs)
        return ((firstindex(axis) + n):lastindex(axis), ntuple(_-> :, Val(N-1))...)
    else
        return (:, _lead_indices(tail(axs), dim, n)...)
    end
end
_lead_indices(::Tuple{}, dim, n) = ()

# _lead_axes
# TODO should probably add support for non AbstractAxis
_lead_axes(::Tuple{}, ::Tuple{}, dim, n) = ()
@inline function _lead_axes(axs::Tuple, newinds::Tuple, dim, n)
    if dim == 1
        return (
            _lead_axis(first(axs), first(newinds), n),
            map(assign_indices, tail(axs), tail(newinds))...
        )
    else
        return (
            assign_indices(first(axs), first(newinds)),
            _lead_axes(tail(axs), tail(newinds), dim, n)...
        )
    end
end

@inline function _lead_axis(axis::AbstractAxis, newinds, n)
    if is_indices_axis(axis)
        return AxisIndices.assign_indices(axis, newinds)
    else
        return to_axis(axis, keys(axis)[firstindex(axis):(lastindex(axis) - n)], newinds)
    end
end

###
### lags
###
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

