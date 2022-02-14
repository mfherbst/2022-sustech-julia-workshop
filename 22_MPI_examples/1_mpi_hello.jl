using MPI
MPI.Init()

comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
world_size = MPI.Comm_size(comm)

println("Hello from rank $(rank) of $(world_size)")
