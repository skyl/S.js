global.S = {}


class Matrix

  constructor: (@mtx) ->
    # mtx is as in [[1, 0], [0, 1]] for 2x2 identity
    @height = @mtx.length
    @width = @mtx[0].length

  # http://rosettacode.org/wiki/Matrix_Transpose#JavaScript
  transposed: () ->
    # returns a new Matrix that is transposed
    trans = []
    for i in [0..@width - 1]
      trans[i] = []
      for j in [0..@height - 1]
        trans[i][j] = @mtx[j][i]
    return new Matrix(trans);

  mult: (other) ->
    if @width isnt other.height
      throw "error: incompatible"
    result = []
    for r in [0..@height - 1]
      result[r] = []
      for c in [0..other.width - 1]
        sum = 0
        for k in [0..@width - 1]
          sum += @mtx[r][k] * other.mtx[k][c]
        result[r][c] = sum
    return new Matrix(result)

  exp: (n) ->
    # http://en.wikipedia.org/wiki/Matrix_exponential
    if @width isnt @height
      throw "error: incompatible"
    result = new IdentityMatrix(@height)
    for i in [1..n]
      result = result.mult @
    return result

  pow: (n) ->
    # raise every member to a power
    # return new Matrix
    res = []
    for i in [0..@height - 1]
      res[i] = []
      for j in [0..@width - 1]
        res[i][j] = Math.pow(@mtx[i][j], n)
    return new Matrix(res)

  toReducedRowEchelonForm: () ->
    # in place
    lead = 0
    for r in [0..@height - 1]
      if @width <= lead
        return
      i = r
      while @mtx[i][lead] is 0
        i += 1
        if i is @height
          i = r
          lead += 1
          if lead is @width
            return
      tmp = @mtx[i]
      @mtx[i] = @mtx[r]
      @mtx[r] = tmp

      val = @mtx[r][lead]

      for j in [0..@width - 1]
        @mtx[r][j] /= val

      for i in [0..@height - 1]
        if i is r
          continue
        val = @mtx[i][lead]
        for j in [0..@width - 1]
          @mtx[i][j] -= val * @mtx[r][j]
      lead += 1
    return @

  inverse: () ->
    res = new Matrix(@mtx)
    res.invert()
    return res

  invert: () ->
    if @width isnt @height
      throw "error: no inverse for non-square matrix"

    I = new IdentityMatrix(@height)
    for i in [0..@height - 1]  
      @mtx[i] = @mtx[i].concat(I.mtx[i])
    @width *= 2
    @toReducedRowEchelonForm()
 
    for i in [0..@height - 1]
      @mtx[i].splice 0, @height
    @width /= 2
    
    return @

  subtract: (other) ->
    if (@width isnt other.width) or (@height isnt other.height)
      throw "error: incompatible"
    res = []
    for i in [0..@height - 1]
      res[i] = []
      for j in [0..@width - 1]
        res[i][j] = @mtx[i][j] - other.mtx[i][j]
    return new Matrix(res)

  add: (other) ->
    if (@width isnt other.width) or (@height isnt other.height)
      throw "error: incompatible"
    res = []
    for i in [0..@height - 1]
      res[i] = []
      for j in [0..@width - 1]
        res[i][j] = @mtx[i][j] + other.mtx[i][j]
    return new Matrix(res)


class ColumnVector extends Matrix

  constructor: (array) ->
    super(array.map (v) -> [v])

  regression_coefficients: (X) ->
    # outcome is `this`
    X_t = X.transposed()
    B = X_t.mult(X).inverse().mult(X_t).mult @
    XB = X.mult(B)
    e = @subtract XB
    return [B, e]

  #var_covar_matrix: (X) ->


class IdentityMatrix extends Matrix

  constructor: (n) ->
    @height = n
    @width = n
    @mtx = []
    for i in [0..n - 1]
      @mtx[i] = []
      for j in [0..n-1]
        @mtx[i][j] = if i is j then 1 else 0


S.Matrix = Matrix
S.ColumnVector = ColumnVector
S.IdentityMatrix = IdentityMatrix