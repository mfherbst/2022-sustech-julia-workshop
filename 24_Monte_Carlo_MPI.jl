# MPI-parallelised Monte Carlo approach to estimating π
#
# This exercise tries to achieve the same thing as notebook 23_Monte_Carlo_threaded.
# However, this time we are using MPI parallelisation.
#
# Again we start from the same basic Julia implementation:

function montecarlo_pi(N)
    M = 0  # count darts that landed in the circle
    for i in 1:N
        if sqrt(rand()^2 + rand()^2) < 1.0
            M += 1
        end
    end
    4 * M / N
end

montecarlo_pi(10_000_000)


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
