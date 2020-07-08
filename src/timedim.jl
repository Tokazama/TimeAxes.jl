
Base.@pure is_time(x::Symbol) = (x === :time) || (x === :Time)

AxisIndices.@defdim(time, is_time, false)

"""
    ntime(x) -> Int

Returns the size along the dimension corresponding to the time. Defaults to 1
"""
@inline function ntime(x)
    if has_timedim(x)
        return size(x, timedim(x))
    else
        return 1
    end
end

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
@inline function assert_timedim_last(x::T) where {T}
    if has_timedim(x)
        if timedim(x) === ndims(T)
            return nothing
        else
            error("time dimension is not last")
        end

    else
        return nothing
    end
end
