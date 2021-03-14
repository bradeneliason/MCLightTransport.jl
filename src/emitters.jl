using StaticArrays

abstract type Emitter end

struct Ray{T <: Real} <: Emitter 
    src :: SVector{3,T}
    trj :: SVector{3,T}
end

Ray(src::Vector{Float64}, trj::Vector{Float64}) = Ray(
    SVector{3,Float64}(src), 
    SVector{3,Float64}(trj),
)

Ray() = Ray(
    SVector{3,Float64}([0.0, 0.0, 0.0]), 
    SVector{3,Float64}([0.0, 0.0, 1.0]),
)


function makephoton(s::Ray)
    return Photon(s.src, s.trj)
end

export Ray, makephoton