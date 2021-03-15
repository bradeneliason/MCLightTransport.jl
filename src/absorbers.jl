abstract type Absorber end

struct AbsorberProperties{T <: Real}
    μ_a :: T
    μ_s :: T
    g   :: T
    nt  :: T
    albedo :: T
end
AbsorberProperties(μ_a, μ_s, g, nt) = AbsorberProperties(μ_a, μ_s, g, nt, μ_s/(μ_s + μ_a))

struct CatesianVolume{T <: Real} <: Absorber
    corner1 :: SVector{3,T}
    corner2 :: SVector{3,T}
    d_xyz :: SVector{3,T}
    Δxyz :: SVector{3,T}
    Nxyz :: SVector{3,Integer}
    prop :: AbsorberProperties
    # data :: SizedArray{Tuple, T}
    data
    function CatesianVolume(corner1::Vector{T}, corner2::Vector{T}, d_xyz::Vector{T}, prop::Vector{T}) where {T<:Real}
        corner1 = SVector{3,T}(corner1)
        corner2 = SVector{3,T}(corner2)
        Δxyz = SVector{3,T}(corner2 - corner1)
        Nxyz = SVector{3,Integer}(Int.(round.(Δxyz ./ d_xyz)))
        prop = AbsorberProperties(prop[1], prop[2], prop[3], prop[4])
        data = SizedArray{Tuple{Nxyz...}, T}(zeros(Nxyz...))
        new{T}(corner1, corner2, d_xyz, Δxyz, Nxyz, prop, data)
    end
end
CatesianVolume(lower::T, upper::T, dxyz::T, prop::Vector) where T <: Real = CatesianVolume(
    lower*ones(3),
    upper*ones(3),
    dxyz* ones(3),
    prop
)
CatesianVolume(lower::Real, upper::Real, dxyz::Real, prop::Vector) = CatesianVolume(
    promote(lower*ones(3),  upper*ones(3),  dxyz* ones(3),  prop)...
)


struct RadialVolume{T <: Real} <: Absorber
    r1 :: T
    r2 :: T
    dr :: T
    Δr :: T
    Nr :: Integer
    data :: Vector{T}
    function RadialVolume(r1::T, r2::T, dr::T) where {T<:Real}
        Δr = r2 - r1
        Nr = Int(round(Δr / dr))
        data = zeros(Nr)
        new{T}(r1, r2, dr, Δr, Nr, data)
    end
end
