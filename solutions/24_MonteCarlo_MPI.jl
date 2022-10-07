using MPI

function montecarlo_pi(N::Int)
    M = 0  # count darts that landed in the circle
    for i in 1:N
        if sqrt(rand()^2 + rand()^2) < 1.0
            M += 1
        end
    end
    4 * M / N
end

# ### Exercise
#
# 1. Write an MPI-parallelised script that computes $\pi$ based on
# `montecarlo_pi`, but distributes the work among the available MPI ranks. The
# basic idea is for each rank to only be responsible for a certain `N_local`.
# Afterwards the results should be accumulated on the master rank using
# `MPI.Reduce`. Again take `N = 10_000_000` as a reasonable value.
#
# 2. How does the performance of your script from 1. compare to the multithreaded
#    version from 23_Monte_Carlo_threaded.
#
#    Hint: Use `MPI.Wtime()` to estimate timings in the MPI-parallelised script.
#    This function returns the walltime in seconds.

#
#    See the main() function below, which also includes the Wtime()-based timing
#    measurements.
#
#    Most notably the MPI-based parallelisation has a slightly larger overhead than
#    the threads-based parallelisation at the level of N = 10_000_000

function main()
    MPI.Init()
    comm   = MPI.COMM_WORLD
    nproc  = MPI.Comm_size(comm)
    rank   = MPI.Comm_rank(comm)
    master = 0

    if isempty(ARGS)
        N = 10_000_000
    else
        N = parse(Int, ARGS[1])
    end
    n_repeats = 100

    wtimes = zeros(n_repeats)
    for t in 1:n_repeats
        MPI.Barrier(comm)
        tstart = MPI.Wtime()

        mypi = montecarlo_pi(ceil(Int, N / nproc))
        mypi = MPI.Reduce(mypi, +, master, comm)
        if rank == master
            mypi = mypi / nproc
        end

        MPI.Barrier(comm)
        wtimes[t] = MPI.Wtime() - tstart
    end

    if rank == master
        println("minimal Δt = $(1000minimum(wtimes)) ms")
    end
end

main()
