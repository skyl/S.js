c This script runs the fortran which validates
c that our S.js toms708 is correct.
c run it with ./run.sh stest

      program main
      implicit none





c      real pf
c      real p
c      real r
      integer ipmpar
c      p = pf(2.726468, 2.0, 14.0)
c      write ( *, '(g24.16)' ) p




c test fpser, x <= 0.5, B < min(eps,eps*A)

c      p = pf(0.1E-15, 0.51, 0.1E-15)
c      write ( *, '(g24.16)' ) p


c test fpser directly
      real fpser
      real r

c YOU HAVE TO HAVE YOUR declarations up FRONT!
      real apser

      real psi



      write ( *, '(g24.16)' ) 'IPMPAR'
      write ( *, '(g24.16)' ) ipmpar(1)
      write ( *, '(g24.16)' ) ipmpar(2)
      write ( *, '(g24.16)' ) ipmpar(3)
      write ( *, '(g24.16)' ) ipmpar(4)
      write ( *, '(g24.16)' ) ipmpar(5)
      write ( *, '(g24.16)' ) ipmpar(6)
      write ( *, '(g24.16)' ) ipmpar(7)
      write ( *, '(g24.16)' ) ipmpar(8)
      write ( *, '(a)' ) 'DONE IPMPAR'





c a, b, x, eps
      r = fpser(1.0, 0.5E-16, 0.1, 0.1E-15)
      write ( *, '(g24.16)' ) r

      r = apser(0.1E-15, 0.5, 0.5, 0.1E-15)
      write ( *, '(g24.16)' ) r



      write ( *, '(a)' ) 'PSI'
      r = psi(5.0)
      write ( *, '(g24.16)' ) r
      r = psi(3.0)
      write ( *, '(g24.16)' ) r


      stop
      end


      real function pf(f0, d1, d2)
      implicit none

      real f0
      real d1
      real d2

      real a
      real b
      integer ierr
      real w
      real x
      real y


      write ( *, '(2x,g24.16,2x,g24.16,2x,g24.16)') f0, d1, d2

      a = d1 / 2.0
      b = d2 / 2.0
      x = (f0 * a) / (f0 * a + b)
      y = 1.0E+00 - x

      write ( *, '(2x,g24.16,2x,g24.16,2x,g24.16)') x, a, b

      call bratio ( a, b, x, y, w, pf, ierr )
      return

      end

