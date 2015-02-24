# compile lib
gfortran -c toms708.f
ar qc libtoms708.a *.o
# compile problem, name of test script, without `.f`
# example: ./run.sh pf
gfortran -c $1.f
gfortran $1.o -ltoms708 -L. -o $1
# run problem
./$1

