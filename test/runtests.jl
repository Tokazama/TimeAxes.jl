
using Test
using TimeAxes
using AxisIndices
using Dates
using Documenter
using Unitful
using Unitful: s

nia = NamedAxisArray(reshape(1:6, 2, 3), x = 2:3, time = 3.0:5.0)
@test has_timedim(nia)
@test @inferred(assert_timedim_last(nia)) == nothing
@test_throws ErrorException assert_timedim_last(NamedAxisArray(reshape(1:6, 3, 2), time = 3.0:5.0, x = 2:3))
@test !has_timedim(parent(nia))
@test @inferred(time_keys(nia)) == 3:5
@test @inferred(ntime(nia)) == 3
@test @inferred(time_indices(nia)) == 1:3
@test @inferred(timedim(nia)) == 2
@test @inferred(select_time(nia, 2)) == selectdim(parent(parent(nia)), 2, 2)
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

@testset "lead" begin
    A = [1 2 3; 4 5 6; 7 8 9]
    A_axes = AxisArray(A,(1:3, (1:3)s));
    A_named_axes = NamedAxisArray{(:time,:_)}(A, (1:3, (1:3)s))

    @testset "Array" begin
        @test @inferred(lead(A, 1, 1)) == [4 5 6; 7 8 9]
        @test @inferred(lead(A, 1, 2)) == [2 3; 5 6; 8 9]
    end

    @testset "AxisArray" begin
        @test @inferred lead(A_axes, 1, 1) == [4 5 6; 7 8 9]
        @test @inferred(lead(A_axes, 1, 2)) == [2 3; 5 6; 8 9]
    end

    @testset "NamedAxisArray" begin
        @test @inferred lead(A_named_axes, 1, 1) == [4 5 6; 7 8 9]
        @test @inferred(lead(A_named_axes, 1, 2)) == [2 3; 5 6; 8 9]
    end
    # this has a mutable axis and therefore it needs to handle this in a type
    # stable way when recreating the axes
    @test lead(NamedAxisArray{(:time,)}(collect(1:5), (1:5)s), 1) == [2, 3, 4, 5]
end


@testset "lag" begin
    A = [1 2 3; 4 5 6; 7 8 9]
    A_axes = AxisArray(A,(1:3, (1:3)s));
    A_named_axes = NamedAxisArray{(:time,:_)}(A, (1:3, (1:3)s))

    @testset "Array" begin
        @test @inferred(lag(A, 1, 1)) == [1 2 3; 4 5 6]
        @test @inferred(lag(A, 1, 2)) == [1 2; 4 5; 7 8]
    end

    @testset "AxisArray" begin
        @test @inferred(lag(A_axes, 1, 1)) == [1 2 3; 4 5 6]
        @test @inferred(lag(A_axes, 1, 2)) == [1 2; 4 5; 7 8]
    end

    @testset "NamedAxisArray" begin
        @test @inferred(lag(A_named_axes, 1, 1)) == [1 2 3; 4 5 6]
        @test @inferred(lag(A_named_axes, 1, 2)) == [1 2; 4 5; 7 8]
    end
    # this has a mutable axis and therefore it needs to handle this in a type
    # stable way when recreating the axes
    @test lag(NamedAxisArray{(:time,)}(collect(1:5), (1:5)s), 1) == [1, 2, 3, 4]
end

@testset "fft-tests" begin
    A = reshape(1:6, 2, 3)
    A_named_axes = NamedAxisArray(A, x = 2:3, time = 3.0:5.0)
    A_named_axes_no_time = NamedAxisArray(A, x = 2:3, y = 3.0:5.0)


    @testset "fft" begin
        A_fft = TimeAxes.fft(A, 2)
        A_named_axes_fft = TimeAxes.fft(A_named_axes, 2)
        @test A_fft == A_named_axes_fft
        @test typeof(A_named_axes_fft) <: NamedAxisArray{(:x, :time)}

        A_fft = TimeAxes.fft(A)
        A_named_axes_no_time_fft = TimeAxes.fft(A_named_axes_no_time)
        @test A_fft == A_named_axes_no_time_fft
        @test typeof(A_named_axes_no_time_fft) <: NamedAxisArray{(:x, :y)}
    end

    @testset "ifft" begin
        A_ifft = TimeAxes.ifft(A, 2)
        A_named_axes_ifft = TimeAxes.ifft(A_named_axes, 2)
        @test A_ifft == A_named_axes_ifft
        @test typeof(A_named_axes_ifft) <: NamedAxisArray{(:x, :time)}

        A_fft = TimeAxes.ifft(A)
        A_named_axes_no_time_fft = TimeAxes.ifft(A_named_axes_no_time)
        @test A_fft == A_named_axes_no_time_fft
        @test typeof(A_named_axes_no_time_fft) <: NamedAxisArray{(:x, :y)}
    end

    @testset "bfft" begin
        A_bfft = TimeAxes.bfft(A, 2)
        A_named_axes_bfft = TimeAxes.bfft(A_named_axes, 2)
        @test A_bfft == A_named_axes_bfft
        @test typeof(A_named_axes_bfft) <: NamedAxisArray{(:x, :time)}

        A_fft = TimeAxes.bfft(A)
        A_named_axes_no_time_fft = TimeAxes.bfft(A_named_axes_no_time)
        @test A_fft == A_named_axes_no_time_fft
        @test typeof(A_named_axes_no_time_fft) <: NamedAxisArray{(:x, :y)}
    end

    @testset "dct" begin
        A_dct = TimeAxes.dct(A, 2)
        A_named_axes_dct = TimeAxes.dct(A_named_axes, 2)
        @test A_dct == A_named_axes_dct
        @test typeof(A_named_axes_dct) <: NamedAxisArray{(:x, :time)}

        A_fft = TimeAxes.dct(A)
        A_named_axes_no_time_fft = TimeAxes.dct(A_named_axes_no_time)
        @test A_fft == A_named_axes_no_time_fft
        @test typeof(A_named_axes_no_time_fft) <: NamedAxisArray{(:x, :y)}
    end

    @testset "idct" begin
        A_idct = TimeAxes.idct(A, 2)
        A_named_axes_idct = TimeAxes.idct(A_named_axes, 2)
        @test A_idct == A_named_axes_idct
        @test typeof(A_named_axes_idct) <: NamedAxisArray{(:x, :time)}

        A_fft = TimeAxes.idct(A)
        A_named_axes_no_time_fft = TimeAxes.idct(A_named_axes_no_time)
        @test A_fft == A_named_axes_no_time_fft
        @test typeof(A_named_axes_no_time_fft) <: NamedAxisArray{(:x, :y)}
    end
end

# this avoids errors due to differences in how Symbols are printing between versions of Julia
if !(VERSION < v"1.5")
    @testset "docs" begin
        doctest(TimeAxes)
    end
end
