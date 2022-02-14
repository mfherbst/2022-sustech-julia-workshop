using MPI
MPI.Init()

comm   = MPI.COMM_WORLD
rank   = MPI.Comm_rank(comm)
master = 0

# Toss 10 coins on each rank:
local_count_heads = count(i -> rand(Bool), 1:10)

# Perform reduction
total_count_heads = MPI.Reduce(local_count_heads, +, master, comm)

sleep(0.2rank)
@show local_count_heads

MPI.Barrier(comm)
rank == master && @show total_count_heads
