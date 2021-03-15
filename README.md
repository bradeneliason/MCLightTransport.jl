# MCLightTransport

**This is an experimental package that is subject to change.**

This package simulates photon propragation through turbid media based on the Monte Carlo method. Currently only a steady-state simulation in an infinite homogenous medium is supported.

## Features

This is an initial release so the feature list is limited.

 * Emitters
    - Ray emitter which emits photons from the same point and trajectory
 * Absorbers
    - CatesianVolume which is a 3D cartesian grid to track photon absorption

## Future Work

 * Better documenation
 * Additional Emitters
    - Emitting photons from a line
 * Additional Volumes
    - Cylindrical coordinates
 * Performance
    - Reduce allocations
    - Parrelization

## Acknowledgements

This pacakge is based on the mc123.c by Steven L. Jacques. 