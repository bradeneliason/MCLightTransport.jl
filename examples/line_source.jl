using BenchmarkTools
using MCLightTransport
using Plots

src = [0.0, 0.0, 0.0];

s = Ray()
makephoton(s)
##
corner1 = [-2.0, -2.0, -2.0]
corner2 = [2.0, 2.0, 2.0]
d_xyz = [0.01, 0.01, 0.01]

μ_a = 1.6  # cm^-1
μ_s = 6.9  # cm^-1
g   = 0.5 
nt  = 1.33
albedo = μ_s/(μ_s + μ_a)
prop = [μ_a, μ_s, g, nt, albedo]

# cvol = CatesianVolume(corner1, corner2, d_xyz)
cvol = CatesianVolume(corner1, corner2, d_xyz, prop);
##
N = 100_000;
@btime simulate!(cvol, s, N); 

## Plotting Max Projection
xx, yy, zz = [l:d:h for (l,d,h) in zip(cvol.corner1, cvol.d_xyz, cvol.corner2)]

vol_log = log10.(collect(cvol.data));
maxproj(v, d=1) = dropdims(maximum(v, dims=d), dims=d)

p1 = heatmap(xx, yy, maxproj(vol_log, 3), aspect_ratio=:equal, legend = :none)
p2 = heatmap(xx, zz, maxproj(vol_log, 2), aspect_ratio=:equal, legend = :none)
p3 = heatmap(yy, zz, maxproj(vol_log, 1), aspect_ratio=:equal, legend = :none)
plot(p1,p2,p3, layout=grid(3,1), size=(300,950))