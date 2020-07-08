module TimeAxes

@doc let path = joinpath(dirname(@__DIR__), "README.md")
    include_dependency(path)
    replace(read(path, String), r"^```julia"m => "```jldoctest README")
end TimeAxes

using AxisIndices
using FFTW
using AbstractFFTs
using NamedDims
using IntervalSets
using Reexport
using Base: OneTo, Fix2, @propagate_inbounds
using AxisIndices: unsafe_reconstruct, similar_type, AxisIndicesStyle
using AxisIndices: to_axis, to_index, assign_indices

using Base: tail

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
    lag,
    lead,
    ..

@reexport using AxisIndices

include("utils.jl")
include("timedim.jl")
include("lead.jl")
include("lag.jl")
include("timeaxis.jl")
include("timestamps.jl")
include("fft.jl")

end # module
