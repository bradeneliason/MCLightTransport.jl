import MCLightTransport.scatterHG
using Plots

## Plotting Henyey-Greenstein scattering function
rnd = 0.0:0.001:1
plot( rnd, scatterHG.(rnd, 0.99), label="g = 0.99")
plot!(rnd, scatterHG.(rnd, 0.90), label="g = 0.90")
plot!(rnd, scatterHG.(rnd, 0.80), label="g = 0.80")
plot!(rnd, scatterHG.(rnd, 0.50), label="g = 0.50")
plot!(rnd, scatterHG.(rnd, 0.10), label="g = 0.10")
plot!(rnd, scatterHG.(rnd, 0.00), label="g = 0.00")
plot!(legend=:bottomright)

##
plot( rnd[1:end-1], log10.(diff(scatterHG.(rnd, 0.99))), label="g = 0.99")
plot!(rnd[1:end-1], log10.(diff(scatterHG.(rnd, 0.90))), label="g = 0.90")
plot!(rnd[1:end-1], log10.(diff(scatterHG.(rnd, 0.80))), label="g = 0.80")
plot!(rnd[1:end-1], log10.(diff(scatterHG.(rnd, 0.50))), label="g = 0.50")
plot!(rnd[1:end-1], log10.(diff(scatterHG.(rnd, 0.10))), label="g = 0.10")
plot!(rnd[1:end-1], log10.(diff(scatterHG.(rnd, 0.00))), label="g = 0.00")
plot!(legend=:bottomright)

##
henyey_greenstein(cosθ, g) = 0.5*(1 - g^2)/(1 + g^2 - 2*g*cosθ)^(3/2)