
@inline function _noshift_axis(axis::A, inds::I) where {A,I}
    if is_indices_axis(axis)
        return to_axis(axis, nothing, inds, false)
    else
        return to_axis(axis, keys(axis), inds, false)
    end
end

@inline function _shift_axis(
    axis::AbstractAxis,
    indexing_index::AbstractUnitRange,
    parent_index::AbstractUnitRange
)

    if is_indices_axis(axis)
        return to_axis(
            axis,
            nothing,
            parent_index,
            false,
        )
    else
        return to_axis(
            axis,
            @inbounds(keys(axis)[indexing_index]),
            parent_index,
            false,
        )
    end
end

_shift_axes(::Tuple{}, ::Tuple{}, ::Tuple{}, dim::Int) = ()
@inline function _shift_axes(
    old_axes::Tuple,
    indexing_indices::Tuple,
    parent_indices::Tuple,
    dim::Int
)

    if dim === 1
        return (
            _shift_axis(
                first(old_axes),
                first(indexing_indices),
                first(parent_indices),
            ),
            map(_noshift_axis, tail(old_axes), tail(parent_indices))...
        )
    else
        return (
            _noshift_axis(
                first(old_axes),
                first(parent_indices)
            ),
            _shift_axes(
                tail(old_axes),
                tail(indexing_indices),
                tail(parent_indices),
                dim - 1
            )...
        )
    end
end
