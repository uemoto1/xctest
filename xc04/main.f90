program main
  use xc_f90_types_m
  use xc_f90_lib_m

  implicit none
  
  integer, parameter :: nx = 100
  real(8) :: rho(nx)
  real(8) :: exc(nx)
  real(8) :: vxc(nx)
  real(8) :: r_s(nx)
  
  integer :: func_id = XC_LDA_X
  
  integer :: ix
  real(8), parameter :: pi = 3.1415926535897
  
  TYPE(xc_f90_pointer_t) :: xc_func
  TYPE(xc_f90_pointer_t) :: xc_info
  
  do ix = 1, nx
    r_s(ix) = 2d0 * ix / nx
    rho(ix) = 1d0/(4d0/3d0*pi*r_s(ix)**3)
  end do
  
  call xc_f90_func_init(xc_func, xc_info, func_id, XC_UNPOLARIZED)
  select case (xc_f90_info_family(xc_info))
  case(XC_FAMILY_LDA)
    call xc_f90_lda_exc_vxc(xc_func, nx, rho(1), exc(1), vxc(1))
  end select
  call xc_f90_func_end(xc_func)
  
  do ix = 1, nx
    write(*,*) r_s(ix), rho(ix), vxc(ix), exc(ix)
  end do
  
  stop 
end program main
