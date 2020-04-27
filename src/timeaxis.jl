
struct TimeAxis{K,V,Ks,Vs,A} <: AbstractAxis{K,V,Ks,Vs}
    axis::Axis{K,V,Ks,Vs}
    annotations::A
end

function TimeAxis(keys::AbstractVector, values::AbstractUnitRange=OneTo(length(keys)), annotations=Dict{Symbol,Any}())
    return TimeAxis(Axis(keys, values), annotations)
end

Base.keys(axis::TimeAxis) = keys(getfield(axis, :axis))

Base.values(axis::TimeAxis) = values(getfield(axis, :axis))

annotations(axis::TimeAxis) = getfield(axis, :annotations)

function AxisIndices.similar_type(
       t::TimeAxis{K,V,Ks,Vs,A},
       new_keys_type::Type=Ks,
       new_values_type::Type=Vs
   ) where {K,V,Ks,Vs,A}
       return TimeAxis{eltype(new_keys_type),eltype(new_values_type),new_keys_type,new_values_type,A}
end

function Base.similar(axis::TimeAxis, ks, vals, annotations)
    return unsafe_reconstruct(axis, ks, vals, annotations)
end

function Base.setindex!(axis::TimeAxis, val, i::Symbol)
    axis.annotations[i] = val
end

struct TimeAnnotation <: AxisIndices.AxisIndicesStyle end

AxisIndices.is_element(::Type{TimeAnnotation}) = false

function AxisIndices.AxisIndicesStyle(::Type{<:TimeAxis}, ::Type{Symbol})
    return TimeAnnotation()
end

function AxisIndices.to_index(::TimeAnnotation, axis, arg)
    return AxisIndices.to_index(axis.axis, annotations(axis)[arg])
end

function AxisIndices.to_keys(::TimeAnnotation, axis, arg, index)
    return AxisIndices.to_keys(axis.axis, annotations(axis)[arg], index)
end

