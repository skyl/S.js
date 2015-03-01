geteps = () ->
  #TODO - smallest number in JS?
  # no, eps should be bigger ..
  # the max of this and the smallest ..
  0.0000000000000001


min = (a, b) ->
  if a < b
    return a
  else
    return b

max = (a, b) ->
  if a > b
    return a
  else
    return b

sw = (a, b) ->
  # [b, a] = sw(a, b)
  return [b, a]

###
IMACH = [
]
###
ipmpar = (i) ->
  # TODO: can we just hardcode these or do we need to search?
  switch i
    when 1
      return 2
    when 2
      return 31
    when 3
      return 2147483647
    when 4
      return 2
    when 5
      return 24
    when 6
      return -125
    when 7
      return 128
    when 8
      return 53
  throw "called impar with invalid argument, #{i}"

spmpar = (i) ->


  ###
        function spmpar ( i )

  c*********************************************************************72
  c
  cc SPMPAR returns single precision real machine constants.
  c
  C     SPMPAR PROVIDES THE SINGLE PRECISION MACHINE CONSTANTS FOR
  C     THE COMPUTER BEING USED. IT IS ASSUMED THAT THE ARGUMENT
  C     I IS AN INTEGER HAVING ONE OF THE VALUES 1, 2, OR 3. IF THE
  C     SINGLE PRECISION ARITHMETIC BEING USED HAS M BASE B DIGITS AND
  C     ITS SMALLEST AND LARGEST EXPONENTS ARE EMIN AND EMAX, THEN
  C
  C        SPMPAR(1) = B**(1 - M), THE MACHINE PRECISION,
  C
  C        SPMPAR(2) = B**(EMIN - 1), THE SMALLEST MAGNITUDE,
  C
  C        SPMPAR(3) = B**EMAX*(1 - B**(-M)), THE LARGEST MAGNITUDE.
  ###

  one = parseFloat(1)

  if (i <= 1)
    b = ipmpar(4)
    m = ipmpar(5)
    return b ** (1 - m)

  if (i <=2)
    b = ipmpar(4)
    emin = ipmpar(6)
    binv = one / b
    w = b ** (emin / 2)
    return ((w * binv) * binv) * binv

  else
    m = ipmpar(5)
    emax = ipmpar(7)
    b = ibeta
    bm1 = ibeta - 1
    z = b ** (m - 1)
    w = ((z - one) * b + bm1) / (b * z)
    z = b ** (emax - 2)
    return ((w*z) * b) * b


exparg = (l) ->
  # ln 1892 in toms708.f
  b = ipmpar(4)

  switch b
    when 2
      lnb = 0.69314718055995
    when 8
      lnb = 2.0794415416798
    when 16
      lnb = 2.7725887222398
    else
      lnb = Math.log(b)

  if l isnt 0
    m = ipmpar(6) - 1
  else
    m = ipmpar(7)

  return 0.99999 * (m * lnb)


fpser = (a, b, x, eps) ->
  # ln1938
  # Ix(a, b) for b = 0 and x <= 0.5
  ret = 1.0
  if a < (0.001 * eps)
    # GO TO 10
  else
    ret = 0
    t = a * Math.log(x)
    if t < exparg(1)
      return ret
    ret = Math.exp(t)

  # GO TO 10
  ret = (b / a) * ret
  tol = eps / a
  an = a + 1.0
  t = x
  s = t / an

  c = t / an
  while (Math.abs(c) > tol)
    t = x * t
    c = t / an
    s = s + c

  ret = ret * (1.0 + a * s)
  return ret

apser = (a, b, x, eps) ->
  ###
  cc APSER evaluates I(1-X)(B,A) for A very small.
  c
  C     APSER YIELDS THE INCOMPLETE BETA RATIO I(SUB(1-X))(B,A) FOR
  C     A .LE. MIN(EPS,EPS*B), B*X .LE. 1, AND X .LE. 0.5. USED WHEN
  C     A IS VERY SMALL. USE ONLY IF ABOVE INEQUALITIES ARE SATISFIED.
  C
  ###
  g = 0.577215664901533
  bx = b * x
  t = x - bx
  if (b * eps) > 2e-2
    c = Math.log(bx) + g + t
  else
    # psi?
    c = Math.log(x) + psi(b) + g + t
  tol = 5.0 * eps * Math.abs(c)
  j = 1.0
  s = 0.0

  aj = 0
  g = () ->
    j = j + 1
    t = t * (x - bx / j)
    aj = t / j
    s = s + aj
  g()
  while (Math.abs(aj) > tol)
    g()
  return -a * (c + s)


psi = (X) ->
  ###
        function psi ( xx )

  c*********************************************************************72
  C
  cc PSI evaluates the Digamma function.
  c
  C
  C     PSI(XX) IS ASSIGNED THE VALUE 0 WHEN THE DIGAMMA FUNCTION CANNOT
  C     BE COMPUTED.
  C
  C     THE MAIN COMPUTATION INVOLVES EVALUATION OF RATIONAL CHEBYSHEV
  C     APPROXIMATIONS PUBLISHED IN MATH. COMP. 27, 123-127(1973) BY
  C     CODY, STRECOK AND THACHER.
  C
  C
  C     PSI WAS WRITTEN AT ARGONNE NATIONAL LABORATORY FOR THE FUNPACK
  C     PACKAGE OF SPECIAL FUNCTION SUBROUTINES. PSI WAS MODIFIED BY
  C     A.H. MORRIS (NSWC).
  C
  ###

  if X is 0.0
    # GO TO 400
    return 0

  PIOV4 = 0.785398163397448
  #PIOV4 = Math.PI / 4.0

  DX0 = 1.461632144968362341262659542325721325

  P1 = [
    0.895385022981970e-02,
    0.477762828042627e+01,
    0.142441585084029e+03,
    0.118645200713425e+04,
    0.363351846806499e+04,
    0.413810161269013e+04,
    0.130560269827897e+04,
  ]
  Q1 = [
    0.448452573429826e+02,
    0.520752771467162e+03,
    0.221000799247830e+04,
    0.364127349079381e+04,
    0.190831076596300e+04,
    0.691091682714533e-05,
  ]
  P2 = [
    -0.212940445131011e+01,
    -0.701677227766759e+01,
    -0.448616543918019e+01,
    -0.648157123766197e+00,
  ]
  Q2 = [
    0.322703493791143e+02,
    0.892920700481861e+02,
    0.546117738103215e+02,
    0.777788548522962e+01,
  ]

  XMAX1 = ipmpar(3)
  XMAX1 = min(XMAX1, 1.0 / spmpar(1))
  XSMALL = 1.0e-9

  AUG = 0.0

  if X >= 0.5
    # GO TO 200
    #console.log("GO TO 200")
  else
    if Math.abs(X) > XSMALL
      # GO TO 100
      # 100
      #console.log("100")
      W = -X
      SGN = PIOV4
      if W <= 0.0
        W = -W
        SGN = -SGN
      # GO TO 120
      # 120
      #console.log("120")
      if W >= XMAX1
        # GO TO 400
        return 0
      NQ = Math.parseInt(W)
      W = W - Math.parseFloat(NQ)
      NQ = Math.parseInt(W * 4.0)
      W = 4.0 * (W = Math.parseFloat(NQ) * 0.25)
      ###
      C
      C  W IS NOW RELATED TO THE FRACTIONAL PART OF  4.0 * X.
      C  ADJUST ARGUMENT TO CORRESPOND TO VALUES IN FIRST
      C  QUADRANT AND DETERMINE SIGN
      C
      ###
      N = NQ / 2
      if (N + N) isnt NQ
        W = 1.0 - W
      Z = PIOV4 * W
      if Z is 0.0
        return 0

      M = N / 2
      if (M + M) isnt N
        SGN = -SGN

      N = (NQ + 1) / 2
      M = N / 2
      M = M + M
      if M isnt N
        # GO TO 140
        # 140
        #console.log("140")
        AUG = SGN * (Math.sin(Z) / Math.cos(Z)) * 4.0
      else
        AUG = SGN * (Math.cos(Z) / Math.sin(Z)) * 4.0
    else
      ###
      C
      C  0 < ABS(X) < XSMALL.  USE 1/X AS A SUBSTITUTE
      C  FOR  PI*COTAN(PI*X)
      C
      ###
      AUG = -1.0 / X
      # GO TO 150
    # 150
    #console.log("150")
    X = 1.0 - X
  # 200
  #console.log("200")
  if X <= 3.0
    #console.log("not GO TO 300")
    DEN = X
    UPPER = P1[0] * X
    for I in [0..4]
      DEN = (DEN + Q1[I]) * X
      UPPER = (UPPER + P1[I+1]) * X
    DEN = (UPPER + P1[6]) / (DEN + Q1[5])
    XMX0 = parseFloat(X) - DX0
    return DEN * XMX0 + AUG
  #console.log("300")
  # 300
  #console.log(X, XMAX1)
  if X < XMAX1
    #console.log("not GO TO 350")

    W = 1.0 / (X * X)
    DEN = W
    UPPER = P2[0] * W

    for I in [0..2]
      DEN = (DEN + Q2[I]) * W
      UPPER = (UPPER + P2[I+1]) * W
    #console.log(UPPER, DEN, Q2[3], X, AUG)
    AUG = UPPER / (DEN + Q2[3]) - 0.5 / X + AUG
    #console.log(AUG)
  #console.log("350")
  #console.log(AUG, Math.log(X))
  return AUG + Math.log(X)


class Bratio

  constructor: (@x, @a, @b) ->
    @y = 1 - @x
    @handle_errors()
    @eps = geteps()
    @ind = 0
    @getlambda()

  handle_errors: () ->
    # a and b must be non-negative, d1/2, d2/2
    # x is between 0 and 1 = d1x / (d1x + d2)
    if (@a < 0) or (@b < 0)
      throw "a and b must be greater than or equal to 0"
    if (@a is 0) and (@b is 0)
      throw "a and b cannot both be zero"
    if (@x < 0) or (@x > 1)
      throw "x must not be less than 0 or greater than 1"
    if (@y < 0) or (@y > 1)
      throw "y (1 - x) must not be less than 0 or greater than 1"

  getlambda: () ->
    # 30, 31, 32
    if @a > @b
      @lambda = (@a + @b) * @y - @b
    else
      @lambda = @a - (@a + @b) * @x
    # 32
    if @lambda < 0
      console.log "32 LAMBDA<0"
      @ind = 1
      console.log @a, @b
      [@b, @a] = sw(@a, @b)
      console.log @a, @b
      [@y, @x] = sw(@x, @y)
      @lambda = Math.abs(@lambda)


  getw: () ->
    # the main routine to get `w`, the lower tail
    # 1 - w is w1
    if (@a > 1) and (@b > 1)
      # GO TO 30
      proc_a_gt_1_and_b_gt_1()

    else
      if @x > 0.5
        # ln1121
        # ind is switched
        @ind = 1
        [@a, @b] = sw(@b, @a)
        [@x, @y] = sw(@y, @x)
      # GO TO 10
      # IF (B0 .LT. AMIN1(EPS,EPS*A0)) GO TO 80
      if @b < min(@eps, @eps * @a)
        # GO TO 80
        @w = fpser(@a, @b, @x, @eps)
        @goto220()
        # w1 = 1 - w
        return @w
      # IF (A0 .LT. AMIN1(EPS,EPS*B0) .AND. B0*X0 .LE. 1.0) GO TO 90
      if (@a < min(@eps, @eps * @b)) and (@b * @x <= 1.0) and (@x <= 0.5)
        # GO TO 90
        @w = apser(@a, @b, @x, @eps)
        @goto220()
        return @w


    ###
     40 IF (B0 .LT. 40.0 .AND. B0*X0 .LE. 0.7) GO TO 100
        IF (B0 .LT. 40.0) GO TO 140
        IF (A0 .GT. B0) GO TO 50
           IF (A0 .LE. 100.0) GO TO 120
           IF (LAMBDA .GT. 0.03*A0) GO TO 120
           GO TO 180
     50 IF (B0 .LE. 100.0) GO TO 120
        IF (LAMBDA .GT. 0.03*B0) GO TO 120
        GO TO 180
    ###


  goto220: () ->
    if @ind is 0
      return
    else
      @w = 1 - @w

  proc_a_gt_1_and_b_gt_1: () ->
    # GO TO 30




if global.S is undefined
  global.S = {}

S.Bratio = Bratio
S.fpser = fpser
S.apser = apser
S.psi = psi



