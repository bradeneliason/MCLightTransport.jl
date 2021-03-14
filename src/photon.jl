mutable struct Photon{T <: Real}
    pos :: SVector{3,T}
    trj :: SVector{3,T}
    weight :: T
    live :: Bool
end

Photon() = Photon(
    SVector{3,Float64}([0.0, 0.0, 0.0]), 
    SVector{3,Float64}([1.0, 0.0, 0.0]), 
    1.0, true
)

Photon(src::Vector{Float64}, trj::Vector{Float64}) = Photon(
    SVector{3,Float64}(src), 
    SVector{3,Float64}(trj),
    1.0, true
)

Photon(src::Vector{Float64}) = Photon(
    SVector{3,Float64}(src), 
    SVector{3,Float64}(random_traj()), 
    1.0, true
)

Photon(src::SVector{3,Float64}, trj::SVector{3,Float64}) = Photon(
   src, trj, 1.0, true
)

export Photon