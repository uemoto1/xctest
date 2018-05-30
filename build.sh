ifort -fpp -c salmon_math.f90 -o salmon_math.o
ifort -fpp -c builtin_pz.f90 -o builtin_pz.o
ifort -fpp -c builtin_pzm.f90 -o builtin_pzm.o
ifort -fpp -c builtin_pbe.f90 -o builtin_pbe.o
ifort -fpp -c builtin_tbmbj.f90 -o builtin_tbmbj.o
ifort -fpp -c salmon_xc.f90 -o salmon_xc.o -I$LIBXC/include -DSALMON_USE_LIBXC
ifort -fpp -c main.f90 -o main.o -I$LIBXC/include


ifort salmon_math.o salmon_xc.o builtin_pz.o main.o builtin_pzm.o builtin_pbe.o builtin_tbmbj.o -L$LIBXC/lib -lxcf90 -lxc -mkl=parallel
