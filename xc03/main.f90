program main
  implicit none
  character(20) :: xc
  integer :: ispin ! ispin=0(nonmag) =1(mag)
  real(8) :: cval
  integer, parameter :: nx = 100
  integer, parameter :: ny = 1
  integer, parameter :: nz = 1
  real(8) :: dv
  real(8) :: rho(nx, ny, nz)
  real(8) :: rho_s(nx, ny, nz, 2)
  real(8) :: tau(nx, ny, nz)
  real(8) :: rj(nx, ny, nz, 3)
  real(8) :: grho(nx, ny, nz, 3)
  real(8) :: rlrho(nx, ny, nz)
  real(8) :: rho_nlcc(nx, ny, nz)
  real(8) :: vxc(nx, ny, nz) ! lda
  real(8) :: vxc_s(nx, ny, nz, 2) !lsda
  real(8) :: exc(nx, ny, nz)
  real(8) :: tot_exc ! sum(exc)
  
  integer :: ix
  real(8) :: rs
  real(8), parameter :: pi = 3.1415926535897
  
  ispin = 0
  xc = 'pz'
  dv = 1.00
  
  do ix = 1, nx
    rs = 2d0 * ix / nx
    rho(ix, 1, 1) = 1d0/(4d0/3d0*pi*rs**3)
  end do
  
  call core_exc_cor(xc, ispin, cval, nx, ny, nz, dv, rho, rho_s, tau, rj, grho, rlrho, rho_nlcc, vxc, vxc_s, exc, tot_exc)
  
  do ix = 1, nx
    rs = 2d0 * ix / nx
    write(*,*) rs, rho(ix,1,1),  exc(ix,1,1), vxc(ix,1,1)
  end do
  
  stop 
end program main
