@show   Threads.nthreads()
@assert Threads.nthreads() > 1

using Statistics
using FLoops
using ThreadsX
using BenchmarkTools
using Plots

function montecarlo_pi(N::Int)
    M = 0  # count darts that landed in the circle
    for i in 1:N
        if sqrt(rand()^2 + rand()^2) < 1.0
            M += 1
        end
    end
    4 * M / N
end

# 1. Write a function `montecarlo_pi_threads(N::Int)`, which is based on
# `montecarlo_pi(N::Int)`, but distributes the work using the
# `Threads.nthreads()` available threads.
#
# 2. Benchmark and compare both `montecarlo_pi(N::Int)` and
# `montecarlo_pi_threads(N::Int)`. For this part (and all following parts) use
# `N = 10_000_000` as a reasonable value for $N$.

# Version (a): Based on Threads.@spawn
tmap(f, iterator) = map(fetch, map(elem -> Threads.@spawn(f(elem)), iterator))
function montecarlo_pi_spawn(N::Int)
    pies = tmap(1:Threads.nthreads()) do chunk
        n_chunk = ceil(Int, N / Threads.nthreads())
        montecarlo_pi(n_chunk)
    end
    mean(pies)
end

# Version (b): Based on Floops
function montecarlo_pi_floops(N::Int)
    mypi = 0.0
    @floop for i in 1:Threads.nthreads()
        n_chunk = ceil(Int, N / Threads.nthreads())
        pie = montecarlo_pi(n_chunk) / Threads.nthreads()
        @reduce mypi += pie
    end
    mypi
end

# Version (c): Based on ThreadsX
function montecarlo_pi_threadsx(N::Int)
    ThreadsX.sum(1:Threads.nthreads()) do chunk
        n_chunk = ceil(Int, N / Threads.nthreads())
        montecarlo_pi(n_chunk) / Threads.nthreads()
    end
end

# Benchmarking
println("montecarlo_pi")
@btime montecarlo_pi(10_000_000)

println("montecarlo_pi_spawn")
@btime montecarlo_pi_spawn(10_000_000)

println("montecarlo_pi_floops")
@btime montecarlo_pi_floops(10_000_000)

println("montecarlo_pi_threadsx")
@btime montecarlo_pi_threadsx(10_000_000)

println()
println()

#
# -------------------------------------------------------------------------
#
# 3. Based on the function `montecarlo_pi(N::Int)` code up a function
# `montecarlo_pi_all(Ns::Vector{Int})`, which computes $\pi$ for all passed
# values for $N$. The function should be serial.

montecarlo_pi_all(Ns::Vector{Int}) = map(montecarlo_pi, Ns)


#
# -------------------------------------------------------------------------
#
# 4. Write a function `montecarlo_pi_all_parallel(Ns::Vector{Int})`, which uses
# multithreading to do the same thing as 3., but in parallel. Build this
# function upon `montecarlo_pi(N::Int)` as well. Benchmark and compare this
# function with the implementation from 3.

# Version (a): Based on Threads.@spawn
montecarlo_pi_all_spawn(Ns::Vector{Int}) = tmap(montecarlo_pi, Ns)

# Version (b): Based on Floops
function montecarlo_pi_all_floops(Ns::Vector{Int})
    mypies = similar(Ns, Float64)
    @floop for i in eachindex(mypies)
        mypies[i] = montecarlo_pi(Ns[i])
    end
    mypies
end

# Version (c): Based on ThreadsX
montecarlo_pi_all_threadsx(Ns::Vector{Int}) = ThreadsX.map(montecarlo_pi, Ns)

# Benchmarking
Ns = [1_000_000, 2_000_000, 3_000_000, 4_000_000]
println("montecarlo_pi_all")
@btime montecarlo_pi_all(Ns)

println("montecarlo_pi_all_spawn")
@btime montecarlo_pi_all_spawn(Ns)

println("montecarlo_pi_all_floops")
@btime montecarlo_pi_all_floops(Ns)

println("montecarlo_pi_all_threadsx")
@btime montecarlo_pi_all_threadsx(Ns)

println()
println()

#
# -------------------------------------------------------------------------
#
# 5. Write a function `montecarlo_pi_nested(Ns::Vector{Int})`, which does the
# maximal parallelisation possible. Again benchmark this function and compare
# against your result from 4.


# Version (a): Based on Threads.@spawn
montecarlo_pi_nested_spawn(Ns::Vector{Int}) = tmap(montecarlo_pi_spawn, Ns)

# Version (b): Based on Floops
function montecarlo_pi_nested_floops(Ns::Vector{Int})
    mypies = similar(Ns, Float64)
    @floop for i in eachindex(mypies)
        mypies[i] = montecarlo_pi_floops(Ns[i])
    end
    mypies
end

# Version (c): Based on ThreadsX
montecarlo_pi_nested_threadsx(Ns::Vector{Int}) = ThreadsX.map(montecarlo_pi_floops, Ns)

# Benchmarking
Ns = [1_000_000, 2_000_000, 3_000_000, 4_000_000]
println("montecarlo_pi_nested_spawn")
@btime montecarlo_pi_nested_spawn(Ns)

println("montecarlo_pi_nested_floops")
@btime montecarlo_pi_nested_floops(Ns)

println("montecarlo_pi_nested_threadsx")
@btime montecarlo_pi_nested_threadsx(Ns)

println()
println()

#
# -------------------------------------------------------------------------
#
# 6. Calculate estimates of $\pi$ for `Ns = @. ceil(Int, exp10(1:0.15:8.1))`
#    and plot the error of these estimates against the exact $\pi$ (`π`)
#    versus the employed $N$ on a semilog plot.

Ns     = @. ceil(Int, exp10(1:0.15:8.1))
pies   = montecarlo_pi_nested_floops(Ns)
p = plot(Ns, abs.(pies .- π), yaxis=:log)
savefig(p, "pi_errors.pdf")
