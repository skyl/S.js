      program main
      implicit none
      real pf
      real p
      integer ipmpar
      p = pf(2.726468, 2.0, 14.0)
      write ( *, '(g24.16)' ) p




      write ( *, '(I5)' ) ipmpar(4)
      write ( *, '(I5)' ) ipmpar(6)
      write ( *, '(I5)' ) ipmpar(7)

c test fpser, x <= 0.5, B < min(eps,eps*A)

      p = pf(0.1E-15, 0.51, 0.1E-15)
      write ( *, '(g24.16)' ) p



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

