
using Test
using TimeAxes
using AxisIndices
using Dates
using Documenter
using Unitful

nia = NamedAxisArray(reshape(1:6, 2, 3), x = 2:3, time = 3.0:5.0)
@test has_timedim(nia)
@test @inferred(assert_timedim_last(nia))
@test @inferred(!assert_timedim_last(NamedAxisArray(reshape(1:6, 3, 2), time = 3.0:5.0, x = 2:3)))
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
@test_throws ArgumentError timedim(NamedAxisArray(reshape(1:6, 2, 3), x = 2:3, y = 3.0:5.0))

t = TimeAxis(Second(1):Second(1):Second(10));

@test t == TimeAxis(Second(1):Second(1):Second(10), Base.OneTo(10), Dict{Symbol,Second}())

@test keys(t) == Second(1):Second(1):Second(10)

t[:ts1] = Second(1)
t[:ts2] = Second(3)

@test AxisIndices.similar_type(t) <: typeof(t)
@test TimeAxes.timestamp_type(t) <: Symbol
@test TimeAxes.timestamp_type(typeof(t)) <: Symbol

@test TimeAxes.check_timestamp(Second, Int, Symbol) == nothing
@test_throws ErrorException TimeAxes.check_timestamp(Second, Int, Int)
@test_throws ErrorException TimeAxes.check_timestamp(Second, Int, Second)


t2 = @inferred(t[:ts1..:ts2])

@test values(t2) == 1:3
@test keys(t2) == Second(1):Second(1):Second(3)

# this avoids errors due to differences in how Symbols are printing between versions of Julia
if !(VERSION < v"1.4")
    @testset "docs" begin
        doctest(TimeAxes)
    end
end

