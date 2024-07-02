
struct Polynomial{T<:Number}
    coeff::Vector{T}  # Коэффициенты многочлена в порядке убывания степеней
end

function Polynomial{T}(coeff::Vector{T}) where T
    k = findfirst(!iszero, coeff)
    return k === nothing ? Polynomial{T}([zero(T)]) : Polynomial{T}(coeff[k:end])
end

ord(p::Polynomial) = length(p.coeff) - 1

Base.:+(p::Polynomial{T}, q::Polynomial{T}) where T = begin
    n, m = length(p.coeff), length(q.coeff)
    if n > m
        r = copy(p.coeff)
        r[n-m+1:end] .+= q.coeff
    else
        r = copy(q.coeff)
        r[m-n+1:end] .+= p.coeff
    end
    Polynomial{T}(r)
end

Base.:+(p::Polynomial{T}, q::T) where T = p + Polynomial{T}([q])
Base.:+(p::T, q::Polynomial{T}) where T = q + p
Base.:-(p::Polynomial{T}) where T = Polynomial{T}(-p.coeff)
Base.:-(p::Polynomial{T}, q::Polynomial{T}) where T = p + (-q)
Base.:-(p::Polynomial{T}, q::T) where T = p + Polynomial{T}([-q])
Base.:-(p::T, q::Polynomial{T}) where T = Polynomial{T}([p]) - q

Base.:*(p::Polynomial{T}, q::Polynomial{T}) where T = begin
    n, m = length(p.coeff), length(q.coeff)
    r = zeros(T, n + m - 1)
    for i in 1:n
        for j in 1:m
            r[i+j-1] += p.coeff[i] * q.coeff[j]
        end
    end
    Polynomial{T}(r)
end

Base.:*(p::Polynomial{T}, q::T) where T = Polynomial{T}(p.coeff .* q)
Base.:*(p::T, q::Polynomial{T}) where T = q * p

Base.divrem(p::Polynomial{T}, q::Polynomial{T}) where T = begin
    if isempty(q.coeff)
        throw(DivideError())
    end
    n, m = length(p.coeff), length(q.coeff)
    q_coeff = zeros(T, n - m + 1)
    r_coeff = copy(p.coeff)
    for i in 1:n-m+1
        q_coeff[i] = r_coeff[1] / q.coeff[1]
        r_coeff = r_coeff .- q_coeff[i] .* q.coeff
        r_coeff = r_coeff[2:end]
    end
    Polynomial{T}(q_coeff), Polynomial{T}(r_coeff)
end

Base.:÷(p::Polynomial{T}, q::Polynomial{T}) where T = divrem(p, q)[1]
Base.:%(p::Polynomial{T}, q::Polynomial{T}) where T = divrem(p, q)[2]

(p::Polynomial{T})(x::T) where T = begin
    val = zero(promote_type(T, typeof(x)))
    for i in 1:length(p.coeff)
        val = val * x + p.coeff[i]
    end
    val
end

function valdiff(p::Polynomial, x)
    n = length(p.coeff)
    val = p.coeff[n]
    diff = zero(promote_type(eltype(p.coeff), typeof(x)))
    for i in n-1:-1:1
        val = val * x + p.coeff[i]
        diff = diff * x + val
    end
    val, diff
end

Base.show(io::IO, p::Polynomial{T}) where {T<:Number} = begin
    s = ""
    for i in length(p.coeff):-1:1
        if p.coeff[i] != 0
            if i > 1
                s *= string(p.coeff[i], "x^", i-1, " + ")
            elseif i == 1
                s *= string(p.coeff[i], "x + ")
            else
                s *= string(p.coeff[i])
            end
        end
    end
    println(io, s)
end

Base.zero(::Type{Polynomial{T}}) where T = Polynomial{T}([zero(T)])
Base.iszero(p::Polynomial{T}) where T = all(iszero, p.coeff)
Base.one(::Type{Polynomial{T}}) where T = Polynomial{T}([one(T), zero(T)])
Base.isone(p::Polynomial{T}) where T = length(p.coeff) == 2 && p.coeff[1] == one(T) && all(iszero, p.coeff[2:end])
