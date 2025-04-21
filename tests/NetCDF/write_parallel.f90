program write_parallel_netcdf
  use mpi
  use netcdf
  implicit none

  integer :: ncid, varid, dimid, ierr
  integer :: comm, info
  integer :: mpierr, rank, nprocs
  integer :: start(1), count(1)
  integer, parameter :: local_size = 4
  integer :: global_size
  integer :: i
  integer, dimension(local_size) :: data

  ! MPI setup
  call MPI_Init(mpierr)
  comm = MPI_COMM_WORLD
  info = MPI_INFO_NULL
  call MPI_Comm_rank(comm, rank, mpierr)
  call MPI_Comm_size(comm, nprocs, mpierr)

  global_size = local_size * nprocs
  data = [(i + rank*local_size, i = 1, local_size)]

  ! Create parallel NetCDF file
  ierr = nf90_create("parallel_data.nc", OR(NF90_NETCDF4, NF90_MPIIO), ncid, comm=comm, info=info)
  if (ierr /= nf90_noerr) stop "Error creating file: "//nf90_strerror(ierr)

  ! Define dimensions and variable
  ierr = nf90_def_dim(ncid, "x", global_size, dimid)
  ierr = nf90_def_var(ncid, "data", NF90_INT, (/dimid/), varid)

  ierr = nf90_enddef(ncid)

  ! Set hyperslab
  start(1) = rank * local_size + 1
  count(1) = local_size

  ! Write data collectively
  ierr = nf90_put_var(ncid, varid, data, start=start, count=count)
  if (ierr /= nf90_noerr) stop "Error writing data: "//nf90_strerror(ierr)

  ! Close file
  ierr = nf90_close(ncid)

  if (rank == 0) print *, "✅ Successfully wrote parallel data to NetCDF!"

  call MPI_Finalize(mpierr)
end program write_parallel_netcdf
