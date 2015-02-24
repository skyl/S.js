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


###
IMACH = [
]
###
ipmpar = (i) ->
  # TODO: can we just hardcode these or do we need to search?
  switch i
    when 4
      return 2
    when 6
      return -125
    when 7
      return 128


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
      @ind = 1
      a0 = b
      console.log "LAMBDA<0"

  getw: () ->
    # the main routine to get `w`, the lower tail
    # 1 - w is w1
    if (@a > 1) and (@b > 1)
      # GO TO 30
      proc_a_gt_1_and_b_gt_1()

    else
      if @x > 0.5
        # ind is switched
        @ind = 1
        tmp = @a
        @a = @b
        @b = tmp
        tmp = @x
        @x = @y
        @y = tmp
      # GO TO 10
      if @b < min(@eps, @eps * @a)
        # GO TO 80
        @w = fpser(@a, @b, @x, @eps)
        @goto220()
        # w1 = 1 - w
        return @w
      else
        console.log "NOOOOP!"
        console.log @b
        console.log min(@eps, @eps * @a)

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



