
# TODO should checks go both ways to ensure keys aren't a subtype of timestamps' type(s)
function check_timestamp(::Type{K}, ::Type{V}, ::Type{S}) where {K,V,S}
    if S <: K
        error("timetamps cannot be a subtype of axis keytype, got keytype(axis) == $K and stamptype(axis) == $S.")
    elseif S <: V
        error("timetamps cannot be a subtype of axis valtype, got valtype(axis) == $S and stamptype(axis) == $S.")
    else
        return nothing
    end
end

"""
    TimeAxis

Subtype of `AbstractAxis` which can store timestamps to corresponding time keys.
"""
struct TimeAxis{K,V,Ks,Vs,SK,TS<:AbstractDict{SK,K}} <: AbstractAxis{K,V,Ks,Vs}
    axis::Axis{K,V,Ks,Vs}
    stamps::TS

    function TimeAxis{K,V,Ks,Vs,SK,TS}(axis::Axis{K,V,Ks,Vs}, ts::TS=TS()) where {K,V,Ks,Vs,SK,TS<:AbstractDict{SK,K}}
        check_timestamp(K,V,SK)
        return new{K,V,Ks,Vs,SK,TS}(axis, ts)
    end

    function TimeAxis(axis::Axis{K,V,Ks,Vs}, ts::AbstractDict{SK,K}) where {K,V,Ks,Vs,SK}
        check_timestamp(K,V,SK)
        return new{K,V,Ks,Vs,SK,typeof(ts)}(axis, ts)
    end
end

function TimeAxis{K,V,Ks,Vs,SK,TS}(ks::Ks, vs::Vs, ts::TS=TS()) where {K,V,Ks,Vs,SK,TS<:AbstractDict{SK,K}}
    check_timestamp(K,V,SK)
    return TimeAxis{K,V,Ks,Vs,SK,TS}(Axis(ks, vs), ts)
end

TimeAxis(axis::Axis{K,V,Ks,Vs}) where {K,V,Ks,Vs,SK} = TimeAxis(axis, Dict{Symbol,K}())

TimeAxis(ks::AbstractVector, vs::AbstractUnitRange=OneTo(length(ks))) = TimeAxis(Axis(ks, vs))

TimeAxis(ks::AbstractVector, vs::AbstractUnitRange, ts::AbstractDict) = TimeAxis(Axis(ks, vs), ts)

Base.keys(axis::TimeAxis) = keys(getfield(axis, :axis))

Base.values(axis::TimeAxis) = values(getfield(axis, :axis))

stamps(axis::TimeAxis) = getfield(axis, :stamps)


stamptype(::T) where {T} = stamptype(T)
stamptype(::Type{TimeAxis{K,V,Ks,Vs,SK,D}}) where {K,V,Ks,Vs,SK,D} = SK

function AxisIndices.similar_type(
    ::TimeAxis{K,V,Ks,Vs,SK,TS},
    new_keys_type::Type=Ks,
    new_values_type::Type=Vs
) where {K,V,Ks,Vs,SK,TS}

   return TimeAxis{
        eltype(new_keys_type),
        eltype(new_values_type),
        new_keys_type,
        new_values_type,
        SK,
        TS
    }
end

# TODO what should happen with annotations here?
function AxisIndices.unsafe_reconstruct(axis::TimeAxis, ks, vs)
    return similar_type(axis, typeof(ks), typeof(vs))(ks, vs, stamps(axis))
end

function Base.setindex!(axis::TimeAxis{K,V,Ks,Vs,S}, val, i::TS) where {K,V,Ks,Vs,S,TS}
    if TS <: S
        axis.stamps[i] = val
    else
        error("Provided timestamp $TS, is not appropriate for axis with timestampe of type $S.")
    end
end

