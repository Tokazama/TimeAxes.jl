# TimeAxes

[![Build Status](https://travis-ci.com/Tokazama/TimeAxes.jl.svg?branch=master)](https://travis-ci.com/Tokazama/TimeAxes.jl) [![codecov](https://codecov.io/gh/Tokazama/TimeAxes.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/Tokazama/TimeAxes.jl)

This package utilizes AxisIndices to interface with data that has a time axis.

```julia
julia> using AxisIndices, TimeAxes, Dates

julia> t = TimeAxis(Second(1):Second(1):Second(10))
TimeAxis(1 second:1 second:10 seconds => Base.OneTo(10))

julia> t[:time_1] = Second(1)..Second(3)
1 second..3 seconds

julia> t2 = t[:time_1]
TimeAxis(1 second:1 second:3 seconds => 1:3)

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

julia> x[:time_1,:]
AxisIndicesArray{Float64,2,Array{Float64,2}...}
 • dim_1 - TimeAxis(1 second:1 second:3 seconds => Base.OneTo(3))
 • dim_2 - SimpleAxis(Base.OneTo(2))
                1     2
   1 second   1.0   1.0
  2 seconds   1.0   1.0
  3 seconds   1.0   1.0

```
