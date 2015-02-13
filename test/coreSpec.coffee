{expect, assert} = require "chai"

# creates "S" global
require "../src/core.js"

matrix = [
	[1, 2, 3]
	[4, 5, 6]
]
trans = [
	[1, 4]
	[2, 5]
	[3, 6]
]
other = [
	[0, 0]
	[1, 1]
	[2, 2]
]
mult_result = [
	[8, 8]
	[17, 17]
]
id_3_by_3 = [
	[1, 0, 0]
	[0, 1, 0]
	[0, 0, 1]
]
matrix_example = [
	[3, 2]
	[2, 1]
]
matrix_example_10 = [
	[1346269, 832040]
	[832040, 514229]
]
matrix_for_reduction = [
	[1, 3, -1]
	[0, 1, 7]
]
matrix_reduced = [
	[1, 0, -22]
	[0, 1, 7]
]
matrix_for_reduction2 = [
  [1, 2, -1, -4]
  [2, 3, -1, -11]
  [-2, 0, -3, 22]
]
matrix_reduced2 = [
	[1, 0, 0, -8]
	[0, 1, 0, 1]
	[0, 0, 1, -2]
]
matrix_reduced3 = [
	[1, 0, 0, -8]
	[0, 1, 0, 1]
	[0, 0, 1, -2]
]
invertible = [
	[1, 0, 10]
	[0, 1, 5]
	[0, 0, 5]
]
inverted = [
	[1, 0, -2]
	[0, 1, -1]
	[0, 0, 0.2]
]


describe "S.Matrix", () ->
	it ".transpose() should return transposed Matrix", () ->
		m = new S.Matrix(matrix)
		m2 = m.transposed()
		expect(m2.mtx).to.deep.equal(trans)

	it ".mult(other) throws error for incompatible", () ->
		m = new S.Matrix(trans)
		m2 = new S.Matrix(other)
		f = () ->
			m3 = m.mult(m2)
		expect(f).to.throw "error: incompatible"

	it ".mult(other) returns the correct result", () ->
		m = new S.Matrix(matrix)
		m2 = new S.Matrix(other)
		m3 = m.mult m2
		expect(m3.mtx).to.deep.equal(mult_result)

	it ".exp(n) throws error for non-square", () ->
		m = new S.Matrix(trans)
		f = () ->
			m.exp(10)
		expect(f).to.throw "error: incompatible"

	it ".exp(10) gives correct answer", () ->
		m = new S.Matrix(matrix_example)
		m2 = m.exp(10)
		expect(m2.mtx).to.be.deep.equal(matrix_example_10)

	it ".pow(n) returns the correct values", () ->
		m = new S.Matrix([
			[1, 2, 3]
			[4, 5, 6]
		])
		m2 = m.pow(2)
		expect(m2.mtx).to.be.deep.equal([
			[1, 4, 9]
			[16, 25, 36]
		])

	it ".toReducedRowEchelonForm makes correct matrix 1", () ->
		m = new S.Matrix(matrix_for_reduction)
		m.toReducedRowEchelonForm()
		expect(m.mtx).to.be.deep.equal(matrix_reduced)

	it ".toReducedRowEchelonForm makes correct matrix 2", () ->
		m = new S.Matrix(matrix_for_reduction2)
		m.toReducedRowEchelonForm()
		#console.log(m.mtx)
		#console.log(matrix_reduced2)
		#expect(m.mtx).to.be.deep.equal(matrix_reduced2)
		#expect(matrix_reduced2).to.be.deep.equal(matrix_reduced2)
		#expect(m.mtx).to.be.deep.equal(m.mtx)
		#expect(matrix_reduced2).to.be.deep.equal(matrix_reduced3)
		for i in [0..m.height - 1]
			for j in [0..m.width - 1]
				#console.log()
				#console.log(matrix_reduced2[i][j])
				#console.log(m.mtx[i][j])
				assert(m.mtx[i][j] is matrix_reduced2[i][j])
		#I have to "matrices" that look like they are the same.
		# When I log them, they look the same.
		# When I compare all the members, they look the same.
		# But, when I try to use `chai` to expect that they are deeply equal,
		# it does not work.
		#expect(m.mtx).to.be.deep.equal(matrix_reduced2)

	it ".invert() throws error for non-square", () ->
		m = new S.Matrix(matrix)
		f = () ->
			m.inverse()
		expect(f).to.throw "error: no inverse for non-square matrix"

	it ".inverse() returns correct value", () ->
		m = new S.Matrix(invertible)
		#mtx = m.mtx
		#console.log(m.mtx)
		m2 = m.inverse()
		#console.log(m2.mtx)
		expect(m2.mtx).to.be.deep.equal(inverted)

	it ".subtract(other) returns correct value", () ->
		m = new S.Matrix([[1, 2, 4]])
		m2 = new S.Matrix([[0, 2, 3]])
		expect(m.subtract(m2).mtx).to.be.deep.equal([[1, 0, 1]])

	it ".add(other) returns correct matrix", () ->
		# ...
		m1 = new S.Matrix([
			[1, 2, 3]
			[9, 8, 7]
		])
		m2 = new S.Matrix([
			[0.5, 1.5, 2.5]
			[3.5, 4.5, 5.5]
		])
		m3 = m1.add(m2)
		expect(m3.mtx).to.be.deep.equal([
			[1.5, 3.5, 5.5]
			[12.5, 12.5, 12.5]
		])

	#it ".div(n) returns correct matrix", () ->


#describe "S.ColumnVector", () ->


describe "S.IdentityMatrix", () ->
	it "constructor produces correct matrix", () ->
		m = new S.IdentityMatrix(3)
		expect(m.mtx).to.be.deep.equal(id_3_by_3)


describe "Basic Regression", () ->
	y = new S.ColumnVector([
		52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93, 61.29,
		63.11, 64.47, 66.28, 68.10, 69.92, 72.19, 74.46
	])
	X = new S.Matrix(
	    [1.47,1.50,1.52,1.55,1.57,1.60,1.63,1.65,1.68,1.70,1.73,1.75,
	     1.78,1.80,1.83
	    ].map (v) ->
	    	[Math.pow(v,0), Math.pow(v,1), Math.pow(v,2)]
	)
	coeff = new S.ColumnVector([
		128.8128035798277
		-143.1620228653037
		61.960325442985436
	])
	it ".regression_coefficients() are correct", () ->
		regression = new S.Regression(y, X)
		regression.run()
		
		expect(regression.B.mtx).to.be.deep.equal(coeff.mtx)
		expect(y.mtx).to.be.deep.equal(
			X.mult(regression.B).add(regression.e).mtx
		)
		#console.log outcome.mtx
		#console.log "="
		#console.log x.mtx
		#console.log coefficients.mtx
		#console.log "+"
		#console.log errors.mtx

	it ".regression_coefficients() are correct simple", () ->
		# simple model with 100 prediction success
		# X0, "intercept" coefficient is 0, X1 coefficient is 1
		y = new S.ColumnVector([50, 60, 70, 80, 90, 100])
		X = new S.Matrix([
			[1, 50]
			[1, 60]
			[1, 70]
			[1, 80]
			[1, 90]
			[1, 100]
		])
		regression = new S.Regression(y, X)
		regression.run()
		e = 0.00000001
		expect(regression.B.mtx[0][0]).to.be.closeTo(0, e)
		expect(regression.B.mtx[1][0]).to.be.closeTo(1, e)


# http://reliawiki.org/index.php/Multiple_Linear_Regression_Analysis

describe "Multiple Linear Regression Analysis", () ->
	outcome = new S.ColumnVector([
		251.3, 251.3, 248.3, 267.5, 273.0, 276.5, 270.3, 274.9, 285.0,
		290.0, 297.0, 302.5, 304.5, 309.3, 321.7, 330.7, 349.0
	])
	X = new S.Matrix([
		[1, 41.9, 29.1]
		[1, 43.4, 29.3]
		[1, 43.9, 29.5]
		[1, 44.5, 29.7]
		[1, 47.3, 29.9]
		[1, 47.5, 30.3]
		[1, 47.9, 30.5]
		[1, 50.2, 30.7]
		[1, 52.8, 30.8]
		[1, 53.2, 30.9]
		[1, 56.7, 31.5]
		[1, 57.0, 31.7]
		[1, 63.5, 31.9]
		[1, 65.3, 32.0]
		[1, 71.1, 32.1]
		[1, 77.0, 32.5]
		[1, 77.8, 32.9]
	])
	regression = new S.Regression(outcome, X)
	regression.run()
	B = [-153.51, 1.24, 12.08]

	it "regression analysis produces correct coefficients", () ->
		for i in [0..regression.B.mtx[0].length - 1]
			expect(regression.B.mtx[0][i]).to.be.closeTo(B[i], 0.1)

	varcovarMat = new S.Matrix([
		[10176.7446, 37.1445, -395.8261]
		[37.1445, 0.1557, -1.481]
		[-395.8261, -1.481, 15.4629]
	])
	it "regression analysis produces correct var/covar matrix", () ->
		vcvM = regression.varCovar
		for i in [0..vcvM.height - 1]
			for j in [0..vcvM.width - 1]
				expect(vcvM.mtx[i][j]).to.be.closeTo(varcovarMat.mtx[i][j], 0.001)




