using MPI
MPI.Init()

comm   = MPI.COMM_WORLD
rank   = MPI.Comm_rank(comm)
nproc  = MPI.Comm_size(comm)
master = 0

data = fill(rank, 10)
tag  = 0  # Agree on a common tag for the message
if rank != master
    # Worker: Send the message `msg` to the master (rank 0)
    MPI.Send(data, master, tag, comm) # blocking
else
    # Master: Receive and print the message
    #         Since Recv! is blocking this happens one by one
    println("Data on master:  ", data)
    for rank in 1:nproc-1  # Remember: MPI ranks are 0-based
        MPI.Recv!(data, rank, tag, comm) # blocking
        println("Data from    $rank:  ", data)
    end
end
