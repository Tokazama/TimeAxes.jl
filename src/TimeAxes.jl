
module TimeAxes

using AxisIndices
using NamedDims
using IntervalSets

using Base: OneTo
using AxisIndices: unsafe_reconstruct, similar_type

export
    TimeAxis,
    # @defdim output
    is_time,
    timedim,
    has_timedim,
    time_axis,
    time_axis_type,
    time_keys,
    time_indices,
    ntime,
    # other methods
    time_end,
    onset,
    duration,
    select_timedim,
    sampling_rate,
    assert_timedim_last,
    ..

include("timedim.jl")
include("timeaxis.jl")


end # module

