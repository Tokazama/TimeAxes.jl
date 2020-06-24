# TODO if FFTW functionality is merged int NamedDims then this code needs to be changed

###
### fft_axes
###
function fft_axis(fxn::Function, axis::AbstractAxis, inds::AbstractUnitRange)
    return assign_indices(axis, inds)  # default
end

@inline function fft_axes(fxn::Function, axs::Tuple, inds::Tuple, dims::Tuple, cnt::Int=1)
    if first(dims) === cnt
        return (fft_axis(fxn, first(axs), first(inds)),
                fft_axes(fxn, tail(axs), tail(inds), tail(dims), cnt + 1)...)
    else
        return (assign_indices(first(axs), first(inds)),
                fft_axes(fxn, tail(axs), tail(inds), dims, cnt + 1)...)
    end
end
fft_axes(fxn::Function, axs::Tuple, inds::Tuple, dims::Tuple{}, cnt::Int=1) = map(assign_indices, axs, inds)
fft_axes(fxn::Function, axs::Tuple{}, inds::Tuple{}, dims::Tuple{}, cnt::Int=1) = ()


###
### fft_names
###
fft_name(fxn::Function, dname::Symbol) = dname  # default is to do nothing
@inline function fft_names(fxn::Function, dnames::NTuple{N,Symbol}, dims::Tuple{Vararg{Int}}) where {N}
    ntuple(Val) do i
        if i in dims
            fft_name(fxn, getfield(dnames, i))
        else
            getfield(dnames, i)
        end
    end
end


for f in (:fft, :ifft, :bfft)
    @eval begin
        function AbstractFFTs.$f(A::AbstractAxisArray, dims)
            p = AbstractFFTs.$f(p, dims)
            axs = fft_axes(AbstractFFTs.$f, axes(A), axes(p), dims)
            return unsafe_reconstruct(A, p, axs)
        end

        function AbstractFFTs.$f(A::NamedAxisArray, dims)
            return AbstractFFTs.$f(A, NamedDims.dims(dimnames(A), dims))
        end

        function AbstractFFTs.$f(A::NamedDimsArray, dims::Tuple{Vararg{<:Integer}})
            dn = fft_names(AbstractFFTs.$f, dimnames(A), dims)
            return NamedDimsArray{dn}(AbstractFFTs.$f(parent(A), dims))
        end

        function AbstractFFTs.$f(A::NamedDimsArray{L,T,N}) where {L,T,N}
            if has_timedim(A)
                return AbstractFFTs.$f(A, (timedim(A),))
            else
                return AbstractFFTs.$f(A, ntuple(+, Val(N)))
            end
        end
    end
end

for f in (:dct, :idct)
    @eval begin
        function FFTW.$f(A::AbstractAxisArray, dims)
            p = FFTW.$f(p, dims)
            axs = fft_axes(AbstractFFTs.$f, axes(A), axes(p), dims)
            return unsafe_reconstruct(A, p, axs)
        end

        function FFTW.$f(A::NamedAxisArray, dims)
            return FFTW.$f(A, NamedDims.dims(dimnames(A), dims))
        end

        function FFTW.$f(A::NamedDimsArray, dims::Tuple{Vararg{<:Integer}})
            dn = fft_names(AbstractFFTs.$f, dimnames(A), dims)
            return NamedDimsArray{dn}(FFTW.$f(parent(A), dims))
        end

        function FFTW.$f(A::NamedDimsArray{L,T,N}) where {L,T,N}
            if has_timedim(A)
                return FFTW.$f(A, (timedim(A),))
            else
                return FFTW.$f(A, ntuple(+, Val(N)))
            end
        end
    end
end
