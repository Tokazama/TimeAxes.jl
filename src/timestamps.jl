
struct TimeStamp <: AxisIndicesStyle end

AxisIndices.AxisIndicesStyle(::Type{<:TimeAxis}, ::Type{T}) where {T} = TimeStamp()

#AxisIndices.is_element(::Type{TimeStamp}) = AxisIndices.is_element(S)

@inline function _refunction(axis, arg::Interval{L,R,T}) where {L,R,T}
    if T <: stamptype(axis)
        return Interval{L,R}(stamps(axis)[arg.left], stamps(axis)[arg.right])
    else
        return arg
    end
end

@inline function _refunction(axis, arg::Fix2{F,T}) where {F,T}
    if T <: stamptype(axis)
        return arg.f(stamps(axis)[arg.x])
    else
        return arg
    end
end


AxisIndices.to_index(S::TimeStamp, axis, arg) = _to_index(axis, arg)

@propagate_inbounds _to_index(axis, arg) = to_index(axis.axis, _refunction(axis, arg))

@inline function AxisIndices.to_keys(::TimeStamp, axis, arg, index)
    return AxisIndices.to_keys(axis.axis, _refunction(axis, arg), index)
end

