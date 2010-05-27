jQuery(document).ready(function($) {
  new GameObjectManager().startGameObjectManager();
});

var LEVEL_WIDTH = 1920;
var LEVEL_HEIGHT = 480;

var LAND_HEIGHT = parseInt(LEVEL_HEIGHT * (5 / 6));

var SkyBackground = Object.create(VisualGameObject);
$.extend(true, SkyBackground, {
  startSkyBackground: function(x, y, z) {
    this.image = document.createElement('canvas');
    this.image.height = LEVEL_HEIGHT;
    this.image.width = LEVEL_WIDTH;
    var imageCtx = this.image.getContext('2d');

    var innerRadius = this.image.width;

    var centerX = this.image.width / 2;
    var centerY = (this.image.width / 2) * Math.sqrt(3) + this.image.height;

    var outerRadius = Math.sqrt(Math.pow(centerY, 2) + Math.pow(this.image.width / 2, 2));

    var skyGradient = imageCtx.createRadialGradient(centerX, centerY, innerRadius, centerX, centerY, outerRadius);
    skyGradient.addColorStop(0.9, 'rgba(40, 110, 185, 1)');
    skyGradient.addColorStop(0, 'rgba(0, 200, 255, 1)');

    imageCtx.fillStyle = skyGradient;
    imageCtx.fillRect(0, 0, this.image.width, this.image.height);

    this.startVisualGameObject(this.image, x, y, z);

    return this;
  },
  stopSkyBackground: function() {
    this.stopVisualGameObject();
    return this;
  }
});

var CloudsBackground = Object.create(RepeatingGameObject);
$.extend(true, CloudsBackground, {
  startCloudsBackground: function(x, y, z) {
    this.image = document.createElement('canvas');
    this.image.width = LEVEL_WIDTH;
    this.image.height = LEVEL_HEIGHT;
    var imageCtx = this.image.getContext('2d');

    var numClouds = randomInt(15, 30);
    for (var i = 0; i < numClouds; i++) {
      imageCtx.drawImage(resourceManager.imageByName('cloud'), randomInt(0, this.image.width), randomInt(0, this.image.height / 2), randomInt(50, 100), randomInt(25, 50));
    }

    this.startRepeatingGameObject(this.image, x, y, z, gom.canvas.width, gom.canvas.height, 0.5);

    return this;
  },
  stopCloudsBackground: function() {
    this.stopRepeatingGameObject();
    return this;
  }
});

var Land = Object.create(VisualGameObject);
$.extend(true, Land, {
  heights: new Array(),
  startLand: function(x, y, z) {
    this.image = document.createElement('canvas');
    this.image.width = LEVEL_WIDTH;
    this.image.height = LAND_HEIGHT;
    var imageCtx = this.image.getContext('2d');
    var id = imageCtx.getImageData(0, 0, this.image.width, this.image.height);

    var amplitude = 1.0;
    var scale = 1000;
    var lambda = 0.25;
    var octaves = 2;

    this.heights = new Array();
    for (var i = 0; i < id.width; i++) {
      this.heights[i] = ((perlin.twoD(amplitude, scale, i, 0, lambda, octaves) + 1) / 2) * LAND_HEIGHT;
    }

    for (var i = 0; i < id.width; i++) {
      for (var j = id.height; j > (id.height - parseInt(this.heights[i])); j--) {
        var grad = [
          { color: {r: 50, g: 100, b: 50, a: 255}, point: 0.0 },
          { color: {r: 0, g: 50, b: 0, a: 255}, point: 0.7 },
          { color: {r: 0, g: 100, b: 0, a: 255}, point: 0.95 },
          { color: {r: 0, g: 0, b: 0, a: 255}, point: 1.0 },
          { color: {r: 0, g: 0, b: 0, a: 0}, point: -1 }];
        gom.utils.setImageDataPixel(id, i, j, perlin.gradientColorPoint(grad, parseInt(this.heights[i]), id.height - j));
      }
    }

    imageCtx.putImageData(id, 0, 0);
    this.startVisualGameObject(this.image, x, y, z);

    return this;
  },
  stopLand: function() {
    this.stopVisualGameObject();
    return this;
  }
});

var Tank = Object.create(VisualGameObject);
$.extend(true, Tank, {
  startTank: function() {
    this.startVisualGameObject(this.image, x, y, z);
  },
  stopTank: function() {
    this.stopVisualGameObject();
    return this;
  }
});

var ApplicationManager = Object.create(new GameObject());
$.extend(true, ApplicationManager, {
  horizontalScrollDirection: 1,
  startApplicationManager: function() {
    this.startGameObject();

    this.skyBackground = Object.create(SkyBackground).startSkyBackground(0, 0, 1);
    this.cloudsBackground = Object.create(CloudsBackground).startCloudsBackground(0, 0, 2);
    this.land = Object.create(Land).startLand(0, LEVEL_HEIGHT - LAND_HEIGHT, 3);

    return this;
  },
  update: function(dt, context, xScroll, yScroll) {
    gameObjectManager.xScroll += 100 * dt * this.horizontalScrollDirection;
    if (gameObjectManager.xScroll < 0) {
      gameObjectManager.xScroll = 0;
      this.horizontalScrollDirection = 1;
    } else if (gameObjectManager.xScroll > LEVEL_WIDTH - gameObjectManager.canvas.width) {
      gameObjectManager.xScroll = LEVEL_WIDTH - gameObjectManager.canvas.width;
      this.horizontalScrollDirection = -1;
    }
  }
});

function TankGame() {
  var $stage = $('#stage');

  var canvas = $stage[0];
  var ctx = canvas.getContext('2d');

  var displayObjects = [];

  var DisplayObject = Object.create({
    defaults: {
      children: [],
      x: 0,
      y: 0,
      h: Math.min($stage.height(), 20),
      w: Math.min($stage.width(), 100),
      onClick: function() {},
      onHover: function() {},
      hovering: false
    },
    initialize: function () {
      $.extend(true, this, this.defaults);
      displayObjects.push(this);
    },
    containsPoint: function(pointX, pointY) {
      if (((pointX > this.x) && (pointX < this.x + this.w)) && ((pointY > this.y) && (pointY < this.y + this.h))) {
        return true;
      }
      return false;
    }
  });

  $stage.click(function(e) {
    var mouseX = e.pageX - $stage.offset().left;
    var mouseY = e.pageY - $stage.offset().top;

    for (var i = 0; i < displayObjects.length; i++) {
      var displayObject = displayObjects[i];
      if (displayObject.containsPoint(mouseX, mouseY)) {
        if (typeof displayObject.onClick === 'function') {
          displayObject.onClick(e);
        }
      }
    }

  });

  $stage.mousemove(function(e) {
    var mouseX = e.pageX - $stage.offset().left;
    var mouseY = e.pageY - $stage.offset().top;

    for (var i = 0; i < displayObjects.length; i++) {
      var displayObject = displayObjects[i];
      if (displayObject.containsPoint(mouseX, mouseY) && displayObject.hovering === false) {
        displayObject.hovering = true;
        displayObject.onHover(e);
      } else if (!displayObject.containsPoint(mouseX, mouseY) && displayObject.hovering === true) {
        displayObject.hovering = false;
        displayObject.onHover(e);
      }
    }
  });

  var CanvasButton = Object.create(DisplayObject);
  $.extend(true, CanvasButton, {
    defaults: {
      normalStyle: {
        fillStyle: "rgb(100, 40, 170)",
        font: "bold 12px sans-serif",
        fontColor: "rgb(200, 200, 200)",
        lineJoin: "round",
        lineWidth: 4,
        strokeStyle: "rgb(100, 100, 100)"
      },
      hoverStyle: {
        fillStyle: "rgb(90, 30, 150)",
        font: "bold 12px sans-serif",
        fontColor: "rgb(230, 230, 230)",
        lineJoin: "round",
        lineWidth: 4,
        strokeStyle: "rgb(50, 50, 50)"
      },
      mouseDownStyle: {
        fillStyle: "rgb(45, 15, 75)",
        font: "bold 12px sans-serif",
        fontColor: "rgb(255, 255, 255)",
        lineJoin: "round",
        lineWidth: 4,
        strokeStyle: "rgb(50, 50, 50)"
      },
      buttonText: "Button",
      onClick: function() {
        console.log('onClick');
      },
      onHover: function(e) {
        this.draw();
      }
    },
    draw: function() {
      ctx.save();

      var style = this.defaults.normalStyle;
      if (this.hovering === true) {
        style = this.defaults.hoverStyle;
      }
      ctx.fillStyle = style.fillStyle;
      ctx.font = style.font;
      ctx.lineJoin = style.lineJoin;
      ctx.lineWidth = style.lineWidth;
      ctx.strokeStyle = style.strokeStyle;

      ctx.textAlign = "center";
      ctx.textBaseline = "middle";
      ctx.beginPath();

      ctx.clearRect(this.x, this.y, this.w, this.h);
      ctx.fillRect(this.x, this.y, this.w, this.h);
      ctx.strokeRect(this.x, this.y, this.w, this.h);
      ctx.fillStyle = style.fontColor;
      ctx.fillText(this.buttonText, this.x + (this.w / 2), this.y + (this.h / 2));

      ctx.restore();
    }
  });

  function draw() {
    ctx.clearRect(0, 0, $stage.width(), $stage.height());
  }

  this.start = function() {
    var startButton = Object.create(CanvasButton);
    startButton.initialize();
    startButton.x = 10;
    startButton.y = 10;
    startButton.buttonText = "Start";
    startButton.draw();
  }
}
