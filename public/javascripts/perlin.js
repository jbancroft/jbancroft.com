function Perlin() {
  this.noise = function(x) {
    x = (x << 13) ^ x;
    return (1.0 - ((x * (x * x * 6803 + 9011) + 9851) & 2147483647) / 1073741824);
  };

  this.noise2D = function(x, y) {
    var n = x + y * 57;
    n = (n << 13) ^ n;
    return (1.0 - ((n * (n * n * 6803 + 9011) + 9851) & 2147483647) / 1073741824);
  };

  this.interpolate = function(a, b, x) {
    var ft = x * Math.PI;
    var f = (1 - Math.cos(ft)) * 0.5;
    return a * (1 - f) + b * f;
  };

  this.oneD = function(amplitude, scale, xo, lambda, octaves) {
    var maxH = 0;
    var h = 0;
    for (var iteration = 1; iteration <= octaves; iteration++) {
      var zoom = scale / (iteration * iteration);
      var fractX = xo / zoom;
      var h1 = this.noise(parseInt(fractX));
      var h2 = this.noise(parseInt(fractX) + 1);
      var i = fractX - parseInt(fractX);

      h += amplitude * this.interpolate(h1, h2, i);
      maxH += amplitude;

      amplitude *= lambda;
    }

    // Normalised
    return (h / maxH);
  };

  this.twoD = function(amplitude, scale, xo, yo, lambda, octaves) {
    var maxH = 0;
    var h = 0;
    for (var iteration = 1; iteration <= octaves; iteration++) {
      var zoom = scale / (iteration * iteration);
      var fractX = xo / zoom;
      var fractY = yo / zoom;
      var h1 = this.noise2D(parseInt(fractX), parseInt(fractY));
      var h2 = this.noise2D(parseInt(fractX) + 1, parseInt(fractY));
      var h3 = this.noise2D(parseInt(fractX), parseInt(fractY) + 1);
      var h4 = this.noise2D(parseInt(fractX) + 1, parseInt(fractY) + 1);

      var xi = fractX - parseInt(fractX);
      var yi = fractY - parseInt(fractY);

      var i1 = this.interpolate(h1, h2, xi);
      var i2 = this.interpolate(h3, h4, xi);
      var i3 = this.interpolate(i1, i2, yi);

      h += amplitude * i3;
      maxH += amplitude;

      amplitude *= lambda;
    }

    // Normalised
    return (h / maxH);
  };

  this.gradientColorPoint = function(grad, length, line) {
    var pointCount = 0;
    var point = line / length;
    for (pointCount = 0; ((point >= grad[pointCount].point) && (grad[pointCount].point != -1)); pointCount++) {}
    pointCount--;

    if (pointCount == -1) {
      return grad[0].color;
    } else if (grad[pointCount + 1].point == -1) {
      return grad[pointCount].color;
    } else {
      var i = (point - grad[pointCount].point) / (grad[pointCount + 1].point - grad[pointCount].point);
      var r = parseInt(this.interpolate(grad[pointCount].color.r, grad[pointCount + 1].color.r, i));
      var g = parseInt(this.interpolate(grad[pointCount].color.g, grad[pointCount + 1].color.g, i));
      var b = parseInt(this.interpolate(grad[pointCount].color.b, grad[pointCount + 1].color.b, i));
      var a = parseInt(this.interpolate(grad[pointCount].color.a, grad[pointCount + 1].color.a, i));
      return {r: r, g: g, b: b, a: a};
    }
  };
}
var perlin = new Perlin();
