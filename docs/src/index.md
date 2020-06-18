# TimeAxes

```@doc
TimeAxes
```

## Examples

A simple array with a time dimension time units along the axis.
```jldoctest doc_examples
julia> using TimeAxes

julia> using Unitful: s

julia> A = NamedAxisArray{(:time,)}(collect(1:100), (1:100)s);
```

### Iteration

One could use the time axis for iteration...
```jldoctest doc_examples
julia> sum([A[i] for i in axes(A, 1)])
5050

julia> sum([A[time=i] for i in time_axis(A)])
5050

```


...or windows of the time axis.
```jldoctest doc_examples
julia> A2 = sum([A[i] for i in AxisIterator(axes(A, 1), 10)])
10-element NamedAxisArray{Int64,1}
 • time - 1 s:1 s:10 s

   1 s   460
   2 s   470
   3 s   480
   4 s   490
   5 s   500
   6 s   510
   7 s   520
   8 s   530
   9 s   540
  10 s   550

julia> sum([A[time=i] for i in time_axis(A, 10)])
10-element NamedAxisArray{Int64,1}
 • time - 1 s:1 s:10 s

   1 s   460
   2 s   470
   3 s   480
   4 s   490
   5 s   500
   6 s   510
   7 s   520
   8 s   530
   9 s   540
  10 s   550

```

Some other basic functions related to time data are also available.
```jldoctest doc_examples
julia> lag(A2, 1)
9-element NamedAxisArray{Int64,1}
 • time - 2 s:1 s:10 s

   2 s   460
   3 s   470
   4 s   480
   5 s   490
   6 s   500
   7 s   510
   8 s   520
   9 s   530
  10 s   540

julia> lead(A2, 1)
9-element NamedAxisArray{Int64,1}
 • time - 1 s:1 s:9 s

  1 s   470
  2 s   480
  3 s   490
  4 s   500
  5 s   510
  6 s   520
  7 s   530
  8 s   540
  9 s   550

```

More time specific methods may be found in the [References](#References)


## References

```@autodocs
Modules = [TimeAxes]
Order = [:type, :function]
```
