using Test
using TimeAxes
using AxisIndices
using Dates

nia = NIArray(reshape(1:6, 2, 3), x = 2:3, time = 3.0:5.0)
@test has_timedim(nia)
@test @inferred(assert_timedim_last(nia))
@test @inferred(!assert_timedim_last(NIArray(reshape(1:6, 3, 2), time = 3.0:5.0, x = 2:3)))
@test !has_timedim(parent(nia))
@test @inferred(time_keys(nia)) == 3:5
@test @inferred(ntime(nia)) == 3
@test @inferred(time_indices(nia)) == 1:3
@test @inferred(timedim(nia)) == 2
@test @inferred(select_timedim(nia, 2)) == selectdim(parent(parent(nia)), 2, 2)
@test @inferred(time_axis_type(nia)) <: Float64
@test @inferred(time_end(nia)) == 5.0
@test @inferred(onset(nia)) == 3.0
@test @inferred(duration(nia)) == 3
@test @inferred(sampling_rate(nia)) == 1
@test_throws ArgumentError timedim(NIArray(reshape(1:6, 2, 3), x = 2:3, y = 3.0:5.0))

t = TimeAxis(Second(1):Second(1):Second(10));

t[:time_1] = Second(1):Second(1):Second(3);

@test t[:time_1] == 1:3
