# using StaticArrays

# Emitter Types ================================================================
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

struct PointSource{T <: Real} <: Emitter 
    src :: SVector{3,T}
end
PointSource(src::Vector{Float64}) = PointSource(SVector{3,Float64}(src))
PointSource() = PointSource(SVector{3,Float64}([0.0, 0.0, 0.0]))

# Functions ===================================================================
function random_traj()
    cosθ = 2.0*rand() - 1.0   
    sinθ = sqrt(1.0 - cosθ^2) # sinθ is always positive
    sinψ, cosψ = sincos(2π * rand())
    return [sinθ * cosψ, sinθ * sinψ, cosθ]
end

makephoton(s::Ray) = Photon(s.src, s.trj)
makephoton(s::PointSource) = Photon(s.src,  SVector{3,Float64}(random_traj()) )