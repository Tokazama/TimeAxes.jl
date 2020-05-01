# TimeAxes

[![Build Status](https://travis-ci.com/Tokazama/TimeAxes.jl.svg?branch=master)](https://travis-ci.com/Tokazama/TimeAxes.jl)
[![codecov](https://codecov.io/gh/Tokazama/TimeAxes.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/Tokazama/TimeAxes.jl)

This package utilizes AxisIndices to interface with data that has a time axis.

```julia
julia> using AxisIndices, TimeAxes, Dates

julia> t = TimeAxis(Second(1):Second(1):Second(10))
TimeAxis(1 second:1 second:10 seconds => Base.OneTo(10))

julia> t2 = t[Second(1)..Second(3)]  # index by time interval
TimeAxis(1 second:1 second:3 seconds => 1:3)

julia> t[:ts1] = Second(1);

julia> t[:ts2] = Second(3);

julia> t2 = t[:ts1..:ts2]  # index by interval between two time stamps
TimeAxis(1 second:1 second:3 seconds => 1:3)

julia> t[>(:ts2)] == t[>(Second(3))]  # all time points above :ts2 and 3 seconds returns the same thing
true

julia> x = AxisIndicesArray(ones(10, 2), t)
AxisIndicesArray{Float64,2,Array{Float64,2}...}
 • dim_1 - TimeAxis(1 second:1 second:10 seconds => Base.OneTo(10))
 • dim_2 - SimpleAxis(Base.OneTo(2))
                 1     2
    1 second   1.0   1.0
   2 seconds   1.0   1.0
   3 seconds   1.0   1.0
   4 seconds   1.0   1.0
   5 seconds   1.0   1.0
   6 seconds   1.0   1.0
   7 seconds   1.0   1.0
   8 seconds   1.0   1.0
   9 seconds   1.0   1.0
  10 seconds   1.0   1.0

julia> x[:ts1..:ts2,:]
AxisIndicesArray{Float64,2,Array{Float64,2}...}
 • dim_1 - TimeAxis(1 second:1 second:3 seconds => Base.OneTo(3))
 • dim_2 - SimpleAxis(Base.OneTo(2))
                1     2
   1 second   1.0   1.0
  2 seconds   1.0   1.0
  3 seconds   1.0   1.0

```
