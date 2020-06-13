
struct TimeStampIndex <: AxisIndicesStyle end

AxisIndices.AxisIndicesStyle(::Type{<:TimeAxis}, ::Type{T}) where {T} = TimeStampIndex()

#AxisIndices.is_element(::Type{TimeStamp}) = AxisIndices.is_element(S)

@inline function _refunction(axis, arg::Interval{L,R,T}) where {L,R,T}
    if T <: timestamp_type(axis)
        return Interval{L,R}(to_timestamp(axis, arg.left), to_timestamp(axis, arg.right))
    else
        return arg
    end
end

@inline function _refunction(axis, arg::Fix2{F,T}) where {F,T}
    if T <: timestamp_type(axis)
        return arg.f(to_timestamp(axis, arg.x))
    else
        return arg
    end
end

_refunction(axis, arg) = arg

@propagate_inbounds function AxisIndices.to_index(S::TimeStampIndex, axis, arg)
    return _to_index(axis, arg)
end

@propagate_inbounds function  _to_index(axis, arg)
    return to_index(axis.axis, _refunction(axis, arg))
end

@inline function AxisIndices.to_keys(::TimeStampIndex, axis, arg, index)
    return AxisIndices.to_keys(axis.axis, _refunction(axis, arg), index)
end

