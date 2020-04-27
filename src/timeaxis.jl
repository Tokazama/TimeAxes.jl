
struct TimeAxis{K,V,Ks,Vs} <: AbstractAxis{K,V,Ks,Vs}
    axis::Axis{K,V,Ks,Vs}
    annotations::Dict{Symbol,Interval{:closed,:closed,K}}

    function TimeAxis{K,V,Ks,Vs}(
        ks::Ks,
        vs::Vs,
        a::Dict{Symbol,Interval{:closed,:closed,K}}=Dict{Symbol,Interval{:closed,:closed,K}}()
    ) where {K,V,Ks,Vs}
        new{K,V,Ks,Vs}(Axis(ks, vs), a)
    end

    function TimeAxis(
        axis::Axis{K,V,Ks,Vs},
        a::Dict{Symbol,Interval{:closed,:closed,K}}=Dict{Symbol,Interval{:closed,:closed,K}}()
    ) where {K,V,Ks,Vs}
        return new{K,V,Ks,Vs}(axis, a)
    end
end

function TimeAxis(
    keys::AbstractVector{K},
    values::AbstractUnitRange=OneTo(length(keys)),
    annotations::Dict{Symbol,Interval{:closed,:closed,K}}=Dict{Symbol,Interval{:closed,:closed,K}}()
) where {K}

    return TimeAxis(Axis(keys, values), annotations)
end

Base.keys(axis::TimeAxis) = keys(getfield(axis, :axis))

Base.values(axis::TimeAxis) = values(getfield(axis, :axis))

annotations(axis::TimeAxis) = getfield(axis, :annotations)

function AxisIndices.similar_type(
       ::TimeAxis{K,V,Ks,Vs},
       new_keys_type::Type=Ks,
       new_values_type::Type=Vs
   ) where {K,V,Ks,Vs}
       return TimeAxis{eltype(new_keys_type),
                       eltype(new_values_type),
                       new_keys_type,
                       new_values_type}
end

# TODO what should happen with annotations here?
function AxisIndices.unsafe_reconstruct(axis::TimeAxis, ks, vs)
    return similar_type(axis, typeof(ks), typeof(vs))(ks, vs, annotations(axis))  
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

