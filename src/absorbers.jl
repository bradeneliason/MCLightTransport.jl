using StaticArrays

abstract type Absorber end

# TODO: put optical properties in absorber
# struct CatesianVolume{T <: Real} <: Absorber
#     corner1 :: SVector{3,T}
#     corner2 :: SVector{3,T}
#     d_xyz :: SVector{3,T}
#     Δxyz :: SVector{3,T}
#     Nxyz :: SVector{3,Integer}
#     # prop :: SVector{5,T}
#     # prop :: SVector{5,T}
#     data :: SizedArray{Tuple, T}
#     function CatesianVolume(corner1::Vector{T}, corner2::Vector{T}, d_xyz::Vector{T}) where {T<:Real} #, prop::Vector{T}
#         corner1 = SVector{3,T}(corner1)
#         corner2 = SVector{3,T}(corner2)
#         Δxyz = SVector{3,T}(corner2 - corner1)
#         Nxyz = SVector{3,Integer}(Int.(round.(Δxyz ./ d_xyz)))
#         data = SizedArray{Tuple{Nxyz...}, T}(zeros(Nxyz...))
#         # prop = SVector{5,T}(prop)
#         new{T}(corner1, corner2, d_xyz, Δxyz, Nxyz, data) #prop
#     end
# end

struct CatesianVolume{T <: Real} <: Absorber
    corner1 :: SVector{3,T}
    corner2 :: SVector{3,T}
    d_xyz :: SVector{3,T}
    Δxyz :: SVector{3,T}
    Nxyz :: SVector{3,Integer}
    # data :: SizedArray{Tuple, T}
    prop :: SVector{5,T}
    data
    function CatesianVolume(corner1::Vector{T}, corner2::Vector{T}, d_xyz::Vector{T}, prop::Vector{T}) where {T<:Real}
        corner1 = SVector{3,T}(corner1)
        corner2 = SVector{3,T}(corner2)
        Δxyz = SVector{3,T}(corner2 - corner1)
        Nxyz = SVector{3,Integer}(Int.(round.(Δxyz ./ d_xyz)))
        prop = SVector{5,T}(prop)
        data = SizedArray{Tuple{Nxyz...}, T}(zeros(Nxyz...))
        new{T}(corner1, corner2, d_xyz, Δxyz, Nxyz, prop, data)
    end
end


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

export CatesianVolume, RadialVolume