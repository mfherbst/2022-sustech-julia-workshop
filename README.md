# Introduction to the Julia programming language

Material for the Julia workshop at SUStech taking place from 5th till 7th February 2022.

## Software and material
What you need for the workshop (quick overview):

- [Julia 1.8](https://julialang.org/downloads/)
- [Jupyter](https://jupyter.org/) and [IJulia.jl](https://github.com/JuliaLang/IJulia.jl)
- This repository of workshop materials
- All required dependencies (Julia packages) for the workshop

### Getting Julia
For following the course you will need at least **Julia 1.8**.
The recommended way to obtain Julia is [`juliaup`](https://github.com/JuliaLang/juliaup):
```
curl -fsSL https://install.julialang.org | sh
```
Alternatively Julia can be obtained in binary form from [Julia downloads](https://julialang.org/downloads/).

### Getting all the rest
To get the remaining files and dependencies
start up `julia` and in the resulting REPL shell,
copy and paste the following:

```julia
import Downloads
script = Downloads.download("https://raw.githubusercontent.com/mfherbst/2022-sustech-julia-workshop/master/install.jl")
include(script)
```
This [downloads the install.jl script](https://raw.githubusercontent.com/mfherbst/2022-sustech-julia-workshop/master/install.jl)
and runs it from julia.
Follow the instructions on the screen and start the Jupyter notebook server
with the command that will be printed.

As an alternative you can also also run the following commands manually
(this requires to have `git` and `julia` available from the commandline):
```
git clone https://github.com/mfherbst/2022-sustech-julia-workshop
cd 2022-sustech-julia-workshop
julia install-manual.jl
```

### Troubleshooting
If you are facing issues, check out
the [great troubleshooting section](https://carstenbauer.github.io/WorkshopWizard.jl/dev/troubleshooting/)
from the WorkshopWizard package by Carsten Bauer (which `install.jl` is using).

### Check everything works
There is a section in the [00_Installation](00_Installation.ipynb) notebook
with a few quick commands to check everything works as expected.

## Working with these notes online (Beta)
Click on the [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/mfherbst/2022-sustech-julia-workshop/master?labpath=00_Introduction.ipynb)
badge to work with these notes online (without a local Julia installation).
Note that for some of the exercises the computational performance available on
binder might not be sufficient.
