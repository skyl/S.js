{expect, assert} = require "chai"

require "../src/toms708/bratio.js"


eps = 0.0000000000000001


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
