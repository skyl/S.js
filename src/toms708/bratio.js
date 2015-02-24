// Generated by CoffeeScript 1.8.0
(function() {
  var Bratio, exparg, fpser, geteps, ipmpar, max, min;

  geteps = function() {
    return 0.0000000000000001;
  };

  min = function(a, b) {
    if (a < b) {
      return a;
    } else {
      return b;
    }
  };

  max = function(a, b) {
    if (a > b) {
      return a;
    } else {
      return b;
    }
  };


  /*
  IMACH = [
  ]
   */

  ipmpar = function(i) {
    switch (i) {
      case 4:
        return 2;
      case 6:
        return -125;
      case 7:
        return 128;
    }
  };

  exparg = function(l) {
    var b, lnb, m;
    b = ipmpar(4);
    switch (b) {
      case 2:
        lnb = 0.69314718055995;
        break;
      case 8:
        lnb = 2.0794415416798;
        break;
      case 16:
        lnb = 2.7725887222398;
        break;
      default:
        lnb = Math.log(b);
    }
    if (l !== 0) {
      m = ipmpar(6) - 1;
    } else {
      m = ipmpar(7);
    }
    return 0.99999 * (m * lnb);
  };

  fpser = function(a, b, x, eps) {
    var an, c, ret, s, t, tol;
    ret = 1.0;
    if (a < (0.001 * eps)) {

    } else {
      ret = 0;
      t = a * Math.log(x);
      if (t < exparg(1)) {
        return ret;
      }
      ret = Math.exp(t);
    }
    ret = (b / a) * ret;
    tol = eps / a;
    an = a + 1.0;
    t = x;
    s = t / an;
    c = t / an;
    while (Math.abs(c) > tol) {
      t = x * t;
      c = t / an;
      s = s + c;
    }
    ret = ret * (1.0 + a * s);
    return ret;
  };

  Bratio = (function() {
    function Bratio(x, a, b) {
      this.x = x;
      this.a = a;
      this.b = b;
      this.y = 1 - this.x;
      this.handle_errors();
      this.eps = geteps();
      this.ind = 0;
      this.getlambda();
    }

    Bratio.prototype.handle_errors = function() {
      if ((this.a < 0) || (this.b < 0)) {
        throw "a and b must be greater than or equal to 0";
      }
      if ((this.a === 0) && (this.b === 0)) {
        throw "a and b cannot both be zero";
      }
      if ((this.x < 0) || (this.x > 1)) {
        throw "x must not be less than 0 or greater than 1";
      }
      if ((this.y < 0) || (this.y > 1)) {
        throw "y (1 - x) must not be less than 0 or greater than 1";
      }
    };

    Bratio.prototype.getlambda = function() {
      var a0;
      if (this.a > this.b) {
        this.lambda = (this.a + this.b) * this.y - this.b;
      } else {
        this.lambda = this.a - (this.a + this.b) * this.x;
      }
      if (this.lambda < 0) {
        this.ind = 1;
        a0 = b;
        return console.log("LAMBDA<0");
      }
    };

    Bratio.prototype.getw = function() {
      var tmp;
      if ((this.a > 1) && (this.b > 1)) {
        return proc_a_gt_1_and_b_gt_1();
      } else {
        if (this.x > 0.5) {
          this.ind = 1;
          tmp = this.a;
          this.a = this.b;
          this.b = tmp;
          tmp = this.x;
          this.x = this.y;
          this.y = tmp;
        }
        if (this.b < min(this.eps, this.eps * this.a)) {
          this.w = fpser(this.a, this.b, this.x, this.eps);
          this.goto220();
          return this.w;
        } else {
          console.log("NOOOOP!");
          console.log(this.b);
          return console.log(min(this.eps, this.eps * this.a));
        }
      }
    };

    Bratio.prototype.goto220 = function() {
      if (this.ind === 0) {

      } else {
        return this.w = 1 - this.w;
      }
    };

    Bratio.prototype.proc_a_gt_1_and_b_gt_1 = function() {};

    return Bratio;

  })();

  if (global.S === void 0) {
    global.S = {};
  }

  S.Bratio = Bratio;

}).call(this);