if (typeof Object.create !== 'function') {
  Object.create = function (o) {
    function F() {}
    F.prototype = o;
    return new F();
  };
}

function randomNumber(lower, upper) {
  return Math.floor(Math.random() * (upper - (lower - 1))) + lower;
}

function randomInt(lower, upper) {
  return Math.round(randomNumber(lower, upper));
}

var FPS = 30;
var SECONDS_BETWEEN_FRAMES = 1 / FPS;

var gameObjectManager = null;
var gom = null;
var resourceManager = null;

function GameObjectManager() {
  this.gameObjects = new Array();
  this.lastFrame = new Date().getTime();
  this.xScroll = 0;
  this.yScroll = 0;
  this.applicationManager = null;
  this.canvas = null;
  this.ctx = null;
  this.buffer = null;
  this.bufferCtx = null;
  this.stage = null;
  this.progressBar = null;

  this.intervalId = null;

  this.startGameObjectManager = function() {
    gom = gameObjectManager = this;

    this.stage = $('#stage');
    this.canvas = this.stage[0];
    this.ctx = this.canvas.getContext('2d');
    this.buffer = document.createElement('canvas');
    this.buffer.width = this.canvas.width;
    this.buffer.height = this.canvas.height;
    this.bufferCtx = this.buffer.getContext('2d');

    this.progressBar = Object.create(ProgressBar).startProgressBar();
    new ResourceManager().startResourceManager([{name: 'cloud', src: '/images/cloud.png'}]);

    this.intervalId = setInterval(function() { gameObjectManager.draw(); }, SECONDS_BETWEEN_FRAMES * 1000);

    return this;
  };

  this.draw = function() {
    try {
      var thisFrame = new Date().getTime();
      var dt = (thisFrame - this.lastFrame) / 1000;
      this.lastFrame = thisFrame;

      if (resourceManager.loadComplete() && this.applicationManager == null) {
        this.progressBar.stopProgressBar();
        this.applicationManager = Object.create(ApplicationManager).startApplicationManager();
      }

      this.bufferCtx.clearRect(0, 0, this.buffer.width, this.buffer.height);
      this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

      for (x in this.gameObjects) {
        if (this.gameObjects[x].update) {
          this.gameObjects[x].update(dt, this.bufferCtx, this.xScroll, this.yScroll);
        }
      }

      for (x in this.gameObjects) {
        if (this.gameObjects[x].draw) {
          this.gameObjects[x].draw(dt, this.bufferCtx, this.xScroll, this.yScroll);
        }
      }

      this.ctx.drawImage(this.buffer, 0, 0);
    } catch (err) {
      if (console.log) { console.log("Error in " + err.fileName + " at line " + err.lineNumber + ": " + err); }
      clearInterval(this.intervalId);
    }
  }

  this.addGameObject = function(gameObject) {
    this.gameObjects.push(gameObject);
    this.gameObjects.sort(function(a, b) { return a.zOrder - b.zOrder; });
  }

  this.removeGameObject = function(gameObject) {
    for (var i = 0; i < this.gameObjects.length; i++) {
      if (this.gameObjects[i] === gameObject) {
        return this.gameObjects.splice(i, 1);
      }
    }
  }

  this.utils = {
    setImageDataPixel: function(id, x, y, c) {
      id.data[(y * (id.width * 4)) + (x * 4)] = c.r;
      id.data[(y * (id.width * 4)) + (x * 4) + 1] = c.g;
      id.data[(y * (id.width * 4)) + (x * 4) + 2] = c.b;
      id.data[(y * (id.width * 4)) + (x * 4) + 3] = c.a;
    }
  };
}

function GameObject() {
  this.zOrder = 0;
  this.x = 0;
  this.y = 0;

  this.startGameObject = function(x, y, z) {
    this.zOrder = z;
    this.x = x;
    this.y = y;

    gameObjectManager.addGameObject(this);
    return this;
  }

  this.stopGameObject = function() {
    gameObjectManager.removeGameObject(this);
  }
}

var VisualGameObject = Object.create(new GameObject());
$.extend(true, VisualGameObject, {
  image: null,
  draw: function(dt, ctx, xScroll, yScroll) {
    ctx.drawImage(this.image, this.x - xScroll, this.y - yScroll);
  },
  startVisualGameObject: function(image, x, y, z) {
    this.startGameObject(x, y, z);
    this.image = image;
    return this;
  },
  stopVisualGameObject: function() {
    this.stopGameObject();
  }
});

var RepeatingGameObject = Object.create(VisualGameObject);
$.extend(true, RepeatingGameObject, {
  width: 0,
  height: 0,
  scrollFactor: 1,
  startRepeatingGameObject: function(image, x, y, z, width, height, scrollFactor) {
    this.width = width;
    this.height = height;
    this.scrollFactor = scrollFactor;
    this.startVisualGameObject(image, x, y, z);
    return this;
  },
  stopRepeatingGameObject: function() {
    this.stopVisualGameObject();
  },
  draw: function(dt, ctx, xScroll, yScroll) {
    var areaDrawn = [0, 0];
    for (var y = 0; y < this.height; y += areaDrawn[1]) {
      for (var x = 0; x < this.width; x += areaDrawn[0]) {
        var newPosition = [this.x + x, this.y + y];
        var newFillArea = [this.width - x, this.height - y];
        var newScrollPosition = [0, 0];
        if (x == 0) { newScrollPosition[0] = xScroll * this.scrollFactor; }
        if (y == 0) { newScrollPosition[1] = yScroll * this.scrollFactor; }
        areaDrawn = this.drawRepeat(ctx, newPosition, newFillArea, newScrollPosition);
      }
    }
  },
  drawRepeat: function(ctx, newPosition, newFillArea, newScrollPosition) {
    var xOffset = Math.abs(newScrollPosition[0]) % this.image.width;
    var yOffset = Math.abs(newScrollPosition[1]) % this.image.height;
    var left = newScrollPosition[0] < 0 ? this.image.width - xOffset : xOffset;
    var top = newScrollPosition[1] < 0 ? this.image.height - yOffset : yOffset;
    var width = newFillArea[0] < this.image.width - left ? newFillArea[0] : this.image.width - left;
    var height = newFillArea[1] < this.image.height - top ? newFillArea[1] : this.image.height - top;

    ctx.drawImage(this.image, left, top, width, height, newPosition[0], newPosition[1], width, height);

    return [width, height];
  }
});

function ResourceManager() {
  this.images = new Array();
  this.resourcesLoaded = false;
  this.numComplete = 0;
  this.objectsToWatch = new Array();

  this.startResourceManager = function(imagesToLoad, objectsToWatch) {
    resourceManager = this;
    this.images = new Array();
    for (var i = 0; i < imagesToLoad.length; i++) {
      var thisImage = new Image();
      this.images.push({
        name: imagesToLoad[i].name,
        src: imagesToLoad[i].src,
        img: thisImage
      });
      thisImage.src = imagesToLoad[i].src;
    }

    if (objectsToWatch) {
      this.objectsToWatch = objectsToWatch;
    }

    return this;
  }

  this.loadComplete = function() {
    if (!this.resourcesLoaded) {
      this.numComplete = 0;
      for (var i = 0; i < this.images.length; i++) {
        if (this.images[i].img.complete) {
          this.numComplete++;
        }
      }

      for (var i = 0; i < this.objectsToWatch.length; i++) {
        if (this.objectsToWatch[i].complete) {
          this.numComplete++;
        }
      }

      if (this.numComplete == this.images.length + this.objectsToWatch.length) {
        this.resourcesLoaded = true;
        this.objectsToWatch = null;
      }
    }

    return this.resourcesLoaded;
  }

  this.percentageComplete = function() {
    if (this.resourcesLoaded) { return 1; }
    if (this.images.length + this.objectsToWatch.length > 0) {
      return this.numComplete / (this.images.length + this.objectsToWatch.length);
    }
    return 1;
  }

  this.imageByName = function(name) {
    for (var i = 0; i < this.images.length; i++) {
      if (this.images[i].name === name) {
        return this.images[i].img;
      }
    }
    return null;
  }
}

var ProgressBar = Object.create(new GameObject());
$.extend(true, ProgressBar, {
  width: 0,
  height: 0,
  startProgressBar: function() {
    var PROGRESS_BAR_WIDTH = this.width = 100;
    var PROGRESS_BAR_HEIGHT = this.height = 20;

    var x = (gom.stage.width() / 2) - (PROGRESS_BAR_WIDTH / 2);
    var y = (gom.stage.height() / 2) - (PROGRESS_BAR_HEIGHT / 2);

    this.startGameObject(x, y, 1);
    return this;
  },
  stopProgressBar: function() {
    this.stopGameObject();
  },
  draw: function(dt, ctx) {
    ctx.save();

    ctx.fillStyle = "rgb(255, 200, 0)";
    ctx.strokeStyle = "rgb(0, 0, 0)";
    ctx.lineWidth = 2;
    ctx.fillRect(this.x, this.y, this.width * resourceManager.percentageComplete(), this.height);
    ctx.strokeRect(this.x, this.y, this.width, this.height);

    ctx.restore();
  }
});
