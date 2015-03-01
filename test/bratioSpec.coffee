{expect, assert} = require "chai"

require "../src/toms708/bratio.js"


eps = 0.0000000000000001


describe "fpser", () ->

    it "x=0.1, a=1.0, b=0.5e-16 returns small", () ->
        w = S.fpser(1.0, 0.5e-16, 0.1)
        expect(w).to.be.closeTo(0, eps)
    # TODO: MORE! What would be a good call here?


describe "apser", () ->
    # cc APSER evaluates I(1-X)(B,A) for A very small.
    # C     APSER YIELDS THE INCOMPLETE BETA RATIO I(SUB(1-X))(B,A) FOR
    # C     A .LE. MIN(EPS,EPS*B), B*X .LE. 1, AND X .LE. 0.5. USED WHEN
    # C     A IS VERY SMALL. USE ONLY IF ABOVE INEQUALITIES ARE SATISFIED.

    it "a=0.1e-15, b=0.5, x=0.5", () ->
        w = S.apser(0.1e-15, 0.5, 0.5, 0.1e-15)
        expect(w).to.be.closeTo(0.1762746899292226e-15, eps)

describe "psi", () ->
    # digamma(5.0) at http://www.wolframalpha.com/
    it "psi(5.0) returns close to 1.506117701530457", () ->
        r = S.psi(5.0)
        expect(r).to.be.closeTo(1.506117701530457, 1.0e-7)
    it "psi(3.0) returns close to 0.9227843880653381", () ->
        r = S.psi(3.0)
        expect(r).to.be.closeTo(0.9227843880653381, 1.0e-7)





describe "S.Bratio", () ->
    # AFAICT, this is an extreme corner case.
    it "fpser is working", () ->
        bratio = new S.Bratio(
            0.9e-01,  # .le. 0.5
            1.0,
            0.5e-16  # less than eps
        )
        w = bratio.getw()
        expect(w).to.be.closeTo(0, eps)
        expect(1 - w).to.be.closeTo(1, eps)

        # TODO: what are the non-trivial arguments
        # that go through fpser?

    #it "", () ->
