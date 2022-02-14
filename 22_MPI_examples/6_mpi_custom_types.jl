using MPI
using StaticArrays

# Custom type: Must be isbitstype, so we use SVector
struct Custom
    x::Float32
    y::Int64
    z::SVector{2, Int64}
end

# Custom reduction
custom_op(c1::Custom, c2::Custom) = Custom(c1.x + c2.x, c1.y + c2.y, c1.z + c2.z)

# Setup and gather MPI info
MPI.Init()
comm   = MPI.COMM_WORLD
nproc  = MPI.Comm_size(comm)
rank   = MPI.Comm_rank(comm)
master = 0

data = [Custom(rank, rank, (rank, rank)) for _ in 1:10]
local_result = reduce(custom_op, data)

# MPI reduction: Pass custom data and custom reduction
total_result = MPI.Reduce(local_result, custom_op, master, comm)

sleep(0.2rank)
@show local_result

MPI.Barrier(comm)
rank == master && @show total_result
