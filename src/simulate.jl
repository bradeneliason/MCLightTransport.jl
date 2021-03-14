using LinearAlgebra: norm

const ONE_MINUS_COSZERO = 1.0E-12 # TODO: figure out why this is used
const THRESHOLD = 0.01
const CHANCE = 0.1 

get_index(y, b, m) = Int(round((y - b) / m))

function binoverflow(i, N)
    i < 1 && (return 1)
    i > N && (return N)
    i
end

## TODO: fix this function to remove allocations
function absorb!(p::Photon, v::CatesianVolume, a)
    p.weight -= a
    indices = get_index.(p.pos, v.corner1, v.d_xyz)
    i,j,k = binoverflow.(indices, v.Nxyz)
    @inbounds v.data[i,j,k] += a 
    nothing
end

function absorb!(p::Photon, v::RadialVolume, a)
    p.weight -= a
    pr = norm(p.pos)
    i = get_index.(pr, v.r1, v.dr)
    i = binoverflow.(i, v.Nr)
    @inbounds v.data[i] += a 
    nothing
end

function random_traj()
    cosθ = 2.0*rand() - 1.0   
    sinθ = sqrt(1.0 - cosθ^2) # sinθ is always positive
    sinψ, cosψ = sincos(2π * rand())
    return [sinθ * cosψ, sinθ * sinψ, cosθ]
end

function hop!(p::Photon, s)
    hop_vec = s .* p.trj
    p.pos = p.pos + hop_vec
    nothing
end

function scatterHG(rnd, g)
    # TODO: doi: 10.1088/0031-9155/51/17/N04
    g == 0.0 && return 2.0*rnd - 1.0
    temp = (1.0 - g^2)/(1.0 - g + 2*g*rnd)
    cosθ = (1.0 + g^2 - temp^2)/(2.0*g)
end

function spin!(p::Photon)
    cosθ = scatterHG(rand(), g) # Sample a random cos(θ) from Henyey-Greenstein scattering function, inverted function
    sinθ = sqrt(1.0 - cosθ^2)   # sqrt() is faster than sin(). 
    
    sinψ, cosψ = sincos(2π*rand()) # Sample psi 

    ux,uy,uz = p.trj
    # New Trajectory
    if (1 - abs(uz) <= ONE_MINUS_COSZERO)      # close to perpendicular. 
        ux_new = sinθ * cosψ
        uy_new = sinθ * sinψ
        uz_new = cosθ * sign(uz)   # SIGN() is faster than division. 
        new_trj = [ux_new, uy_new, uz_new]
        new_trj = new_trj ./ norm(new_trj)
    else # usually use this option 
        temp = sqrt(1.0 - uz^2)
        ux_new =  sinθ * (ux * uz * cosψ - uy * sinψ) / temp + ux * cosθ
        uy_new =  sinθ * (uy * uz * cosψ + ux * sinψ) / temp + uy * cosθ
        uz_new = -sinθ * cosψ * temp + uz * cosθ
        new_trj = [ux_new, uy_new, uz_new] 
    end

    p.trj = new_trj
    nothing
end

function roulette!(p::Photon)
    if p.weight < THRESHOLD
        if rand() <= CHANCE
            p.weight /= CHANCE
        else
            p.live = false
        end
    end
    nothing
end

# TODO: make this function parallelizable
# TODO: make soure types
function simulate!(volume::Absorber, e::Emitter, num_photons)
    hop_function() = -log(rand())/(volume.prop[1] + volume.prop[2])

    for i = 1:num_photons
        # simulating photons emitted in line
        phot = makephoton(e)
        # tmp1 = SVector{3, Int32}([1,1,1])
        while phot.live
            s = -log(rand())/(μ_a + μ_s)
            a = phot.weight*(1 - albedo)
    
            hop!(phot, s)
            absorb!(phot, volume, a)
            spin!(phot)
            roulette!(phot)
        end
    end
    return volume
end

export simulate!