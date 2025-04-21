program test_parallel_netcdf
  use mpi
  use netcdf
  implicit none

  integer :: ncid, ierr, mpierr

  ! Initialize MPI
  call MPI_Init(mpierr)

  ! Try to create a parallel NetCDF-4 file
  ierr = nf90_create('test.nc', or(NF90_NETCDF4, NF90_MPIIO), ncid)
  if (ierr /= nf90_noerr) then
    print *, 'Parallel NetCDF not supported:', nf90_strerror(ierr)
  else
    print *, 'Parallel NetCDF support is working.'
    ierr = nf90_close(ncid)
  end if

  ! Finalize MPI
  call MPI_Finalize(mpierr)

end program test_parallel_netcdf
