var documenterSearchIndex = {"docs":
[{"location":"#TimeAxes","page":"TimeAxes","title":"TimeAxes","text":"","category":"section"},{"location":"","page":"TimeAxes","title":"TimeAxes","text":"TimeAxes","category":"page"},{"location":"#Examples","page":"TimeAxes","title":"Examples","text":"","category":"section"},{"location":"","page":"TimeAxes","title":"TimeAxes","text":"A simple array with a time dimension time units along the axis.","category":"page"},{"location":"","page":"TimeAxes","title":"TimeAxes","text":"julia> using TimeAxes\n\njulia> using Unitful: s\n\njulia> A = NamedAxisArray{(:time,)}(collect(1:100), (1:100)s);","category":"page"},{"location":"#Iteration","page":"TimeAxes","title":"Iteration","text":"","category":"section"},{"location":"","page":"TimeAxes","title":"TimeAxes","text":"One could use the time axis for iteration...","category":"page"},{"location":"","page":"TimeAxes","title":"TimeAxes","text":"julia> sum([A[i] for i in axes(A, 1)])\n5050\n\njulia> sum([A[time=i] for i in time_axis(A)])\n5050\n","category":"page"},{"location":"","page":"TimeAxes","title":"TimeAxes","text":"...or windows of the time axis.","category":"page"},{"location":"","page":"TimeAxes","title":"TimeAxes","text":"julia> A2 = sum([A[i] for i in AxisIterator(axes(A, 1), 10)])\n10-element NamedAxisArray{Int64,1}\n • time - 1 s:1 s:10 s\n\n   1 s   460\n   2 s   470\n   3 s   480\n   4 s   490\n   5 s   500\n   6 s   510\n   7 s   520\n   8 s   530\n   9 s   540\n  10 s   550\n\njulia> sum([A[time=i] for i in time_axis(A, 10)])\n10-element NamedAxisArray{Int64,1}\n • time - 1 s:1 s:10 s\n\n   1 s   460\n   2 s   470\n   3 s   480\n   4 s   490\n   5 s   500\n   6 s   510\n   7 s   520\n   8 s   530\n   9 s   540\n  10 s   550\n","category":"page"},{"location":"","page":"TimeAxes","title":"TimeAxes","text":"Some other basic functions related to time data are also available.","category":"page"},{"location":"","page":"TimeAxes","title":"TimeAxes","text":"julia> lag(A2, 1)\n9-element NamedAxisArray{Int64,1}\n • time - 2 s:1 s:10 s\n\n   2 s   460\n   3 s   470\n   4 s   480\n   5 s   490\n   6 s   500\n   7 s   510\n   8 s   520\n   9 s   530\n  10 s   540\n\njulia> lead(A2, 1)\n9-element NamedAxisArray{Int64,1}\n • time - 1 s:1 s:9 s\n\n  1 s   470\n  2 s   480\n  3 s   490\n  4 s   500\n  5 s   510\n  6 s   520\n  7 s   530\n  8 s   540\n  9 s   550\n","category":"page"},{"location":"","page":"TimeAxes","title":"TimeAxes","text":"More time specific methods may be found in the References","category":"page"},{"location":"#References","page":"TimeAxes","title":"References","text":"","category":"section"},{"location":"","page":"TimeAxes","title":"TimeAxes","text":"Modules = [TimeAxes]\nOrder = [:type, :function]","category":"page"},{"location":"#TimeAxes.TimeAxis","page":"TimeAxes","title":"TimeAxes.TimeAxis","text":"TimeAxis\n\nSubtype of AbstractAxis which can store timestamps to corresponding time keys.\n\n\n\n\n\n","category":"type"},{"location":"#TimeAxes.assert_timedim_last-Union{Tuple{T}, Tuple{T}} where T","page":"TimeAxes","title":"TimeAxes.assert_timedim_last","text":"assert_timedim_last(x)\n\nThrow an error if the x has a time dimension that is not the last dimension.\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.duration-Tuple{Any}","page":"TimeAxes","title":"TimeAxes.duration","text":"duration(x)\n\nDuration of the event along the time axis.\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.each_time-Tuple{Any}","page":"TimeAxes","title":"TimeAxes.each_time","text":"each_time(x)\n\nCreate a generator that iterates over the time dimensions A, returning views that select all the data from the other dimensions in A.\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.has_timedim-Tuple{Any}","page":"TimeAxes","title":"TimeAxes.has_timedim","text":"has_timedim(x) -> Bool\n\nReturns true if x has a dimension corresponding to time.\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.lead-Union{Tuple{N}, Tuple{T}, Tuple{AbstractArray{T,N},Integer,Integer}} where N where T","page":"TimeAxes","title":"TimeAxes.lead","text":"lead(A::AbstractArray, nshift::Integer[, dim::Integer])\n\nShift the elements of A along the the axis of the dimension dim by nshift elements earlier. If dim is not specified then the dimension returned by timedim is used. If A does not have a time dimension then the last dimension is assumed to be the time dimension.\n\nExamples\n\njulia> using TimeAxes\n\njulia> using Unitful: s\n\njulia> A = NamedAxisArray{(:time,)}(collect(1:5), (1:5)s)\n5-element NamedAxisArray{Int64,1}\n • time - 1 s:1 s:5 s\n\n  1 s   1\n  2 s   2\n  3 s   3\n  4 s   4\n  5 s   5\n\njulia> lead(A, 1)\n4-element NamedAxisArray{Int64,1}\n • time - 1 s:1 s:4 s\n\n  1 s   2\n  2 s   3\n  3 s   4\n  4 s   5\n\njulia> lead([1 2 3; 4 5 6; 7 8 9], 1, 1)\n2×3 Array{Int64,2}:\n 4  5  6\n 7  8  9\n\njulia> lead([1 2 3; 4 5 6; 7 8 9], 1, 2)\n3×2 Array{Int64,2}:\n 2  3\n 5  6\n 8  9\n\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.ntime-Tuple{Any}","page":"TimeAxes","title":"TimeAxes.ntime","text":"ntime(x) -> Int\n\nReturns the size along the dimension corresponding to the time. Defaults to 1\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.onset-Tuple{Any}","page":"TimeAxes","title":"TimeAxes.onset","text":"onset(x)\n\nFirst time point along the time axis.\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.sampling_rate-Tuple{Any}","page":"TimeAxes","title":"TimeAxes.sampling_rate","text":"sampling_rate(x)\n\nNumber of samples per second.\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.select_timedim-Tuple{Any,Any}","page":"TimeAxes","title":"TimeAxes.select_timedim","text":"select_timedim(x, i)\n\nReturn a view of all the data of x where the index for the time dimension equals i.\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.time_axis-Tuple{Any,Any}","page":"TimeAxes","title":"TimeAxes.time_axis","text":"time_axis(x, size[; first_pad=nothing, last_pad=nothing, stride=nothing, dilation=nothing])\n\nReturns an AxisIterator along the time axis.\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.time_axis-Tuple{Any}","page":"TimeAxes","title":"TimeAxes.time_axis","text":"time_axis(x)\n\nReturns the axis corresponding to the time dimension.\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.time_axis_type-Tuple{Any}","page":"TimeAxes","title":"TimeAxes.time_axis_type","text":"time_axis_type(x)\n\nReturns the key type corresponding to the time axis.\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.time_end-Tuple{Any}","page":"TimeAxes","title":"TimeAxes.time_end","text":"time_end(x)\n\nLast time point along the time axis.\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.time_indices-Tuple{Any}","page":"TimeAxes","title":"TimeAxes.time_indices","text":"time_indices(x)\n\nReturns the indices corresponding to the time axis\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.time_keys-Tuple{Any}","page":"TimeAxes","title":"TimeAxes.time_keys","text":"time_keys(x)\n\nReturns the keys corresponding to the time axis\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.time_step-Tuple{Any}","page":"TimeAxes","title":"TimeAxes.time_step","text":"time_step(x)\n\nThe time step/interval between each element.\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.timedim-Tuple{Any}","page":"TimeAxes","title":"TimeAxes.timedim","text":"timedim(x) -> Int\n\nReturns the dimension corresponding to time.\n\n\n\n\n\n","category":"method"},{"location":"#TimeAxes.to_timestamp-Tuple{TimeAxis,Any}","page":"TimeAxes","title":"TimeAxes.to_timestamp","text":"to_timestamp(axis::TimeAxis, key)\n\nReturns a timestamp where key corresponds to a key-value pair for the timestamps of axis.\n\n\n\n\n\n","category":"method"}]
}
