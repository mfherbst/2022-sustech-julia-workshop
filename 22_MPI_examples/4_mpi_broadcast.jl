using MPI
MPI.Init()

comm   = MPI.COMM_WORLD
nproc  = MPI.Comm_size(comm)
rank   = MPI.Comm_rank(comm)
master = 0

# A simple random number generator, see
# https://en.wikipedia.org/wiki/Linear_congruential_generator
linear_congruential(xₙ, m) = mod1(3xₙ, m)

# The initial state (x) and container for a (random) period.
x = 107

m = nothing
if rank == master
    # Draw a random integer on master
    m = 2^rand(5:10)
    println("Drew m = $m")
end

# Use broadcast to get the same period on each processor.
# This ensures we get the same sequence of random numbers in all ranks
m = MPI.bcast(m, master, comm)

# Collect 10 random numbers
output = [x]
for i in 1:10
    xₙ = last(output)
    xₙ₊₁ = linear_congruential(xₙ, m)
    push!(output, xₙ₊₁)
end

# Send data to master and print
tag = 0
if rank == master
    println("Output on master:  ", output)
    for rank in 1:nproc-1
        MPI.Recv!(output, rank, tag, comm)
        println("Output on      $rank:  ", output)
    end
else
    MPI.Send(output, master, tag, comm)
end
