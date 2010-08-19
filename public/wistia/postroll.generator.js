function Wistia() {
  function PostRoller() {
    this.rawInput = "<object width=\"640\" height=\"360\" id=\"wistia_167217\" classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\"><param name=\"movie\" value=\"http://embed.wistia.com/flash/embed_player_v1.1.swf\"/><param name=\"allowfullscreen\" value=\"true\"/><param name=\"allowscriptaccess\" value=\"always\"/><param name=\"wmode\" value=\"opaque\"/><param name=\"flashvars\" value=\"videoUrl=http://embed.wistia.com/deliveries/936f1571558860e4bcc0dc61f57a9d23c1d768b0.bin&stillUrl=http://embed.wistia.com/deliveries/b300126144f62ba2942ec4a4f29e949a47e16f12.bin&unbufferedSeek=true&controlsVisibleOnLoad=false&autoPlay=false&playButtonVisible=true&embedServiceURL=http://distillery.wistia.com/x&accountKey=wistia-production_3488&mediaID=wistia-production_167217&mediaDuration=30\"/><embed src=\"http://embed.wistia.com/flash/embed_player_v1.1.swf\" width=\"640\" height=\"360\" name=\"wistia_167217\" type=\"application/x-shockwave-flash\" allowfullscreen=\"true\" allowscriptaccess=\"always\" wmode=\"opaque\" flashvars=\"videoUrl=http://embed.wistia.com/deliveries/936f1571558860e4bcc0dc61f57a9d23c1d768b0.bin&stillUrl=http://embed.wistia.com/deliveries/b300126144f62ba2942ec4a4f29e949a47e16f12.bin&unbufferedSeek=true&controlsVisibleOnLoad=false&autoPlay=false&playButtonVisible=true&embedServiceURL=http://distillery.wistia.com/x&accountKey=wistia-production_3488&mediaID=wistia-production_167217&mediaDuration=30\"></embed></object>";

    this.info = {
      width: "640",
      height: "360",
      id: ""
    };

    this.settings = {
      backgroundColor: "#FFFFFF",
      content: "The End",
      effect: "",
      foregroundColor: "#000000"
    };

    this.outputCode = this.rawInput;

    this.extractInfo = function() {
      var inp = this.rawInput;
      var matcher = /\swidth="(\d+)"/gi;
      var matches = matcher.exec(inp);
      if (matches != null && matches.length > 1) {
        this.info.width = matches[1];
      }

      matcher = /\sheight="(\d+)"/gi;
      matches = matcher.exec(inp);
      if (matches != null && matches.length > 1) {
        this.info.height = matches[1];
      }

      matcher = /\sid="([^"]+)"/gi;
      matches = matcher.exec(inp);
      if (matches != null && matches.length > 1) {
        this.info.id = matches[1];
      }
    };

    this.insertCallback = function() {
      this.outputCode = this.outputCode.replace(/(<param\sname="flashvars"\svalue="[^"]+)(")/gi, "$1&endVideoCallback=endVideo$2");
      this.outputCode = this.outputCode.replace(/(flashvars="[^"]+)(")/gi, "$1&endVideoCallback=endVideo$2");
    };

    this.insertPostRollCode = function() {
      //var divLine = "<div id=\"" + this.info.id + "_end\" style=\"width:" + this.info.width + "px;height:" + this.info.height + "px;color:" + this.settings.foregroundColor + ";background-color:" + this.settings.backgroundColor + ";display:none;position:relative;top:0;left:0;z-index:1000;\">" + this.settings.content + "</div>";
      // See http://weblogs.asp.net/joelvarty/archive/2009/05/07/load-jquery-dynamically.aspx for an explanation of this method of dynamically loading jQuery.
      var scriptLines = "<script>";
      scriptLines += "var jQueryScriptOutputted = false;";
      scriptLines += "function initJQuery() {";
      scriptLines += "  if (typeof(jQuery) == 'undefined') {";
      scriptLines += "    if (! jQueryScriptOutputted) {";
      scriptLines += "      jQueryScriptOutputted = true;";
      scriptLines += "      document.write(\"<scr\" + \"ipt src=\\\"http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js\\\"></scr\" + \"ipt>\");";
      scriptLines += "    }";
      scriptLines += "    setTimeout(initJQuery, 50);";
      scriptLines += "  } else if (typeof(jQuery.ui) == 'undefined') {";
      scriptLines += "    $.getScript('http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.4/jquery-ui.min.js');";
      scriptLines += "  }";
      scriptLines += "}";
      scriptLines += "initJQuery();";
      scriptLines += "function endVideo() {";
      scriptLines += "  if (typeof(jQuery) == 'undefined' || typeof(jQuery.ui) == 'undefined') {";
      scriptLines += "    setTimeout(endVideo, 50);";
      scriptLines += "  } else {";
      scriptLines += "    $('body').append($(\"<div id=\\\"" + this.info.id + "_end\\\" style=\\\"width:" + this.info.width + "px;height:" + this.info.height + "px;color:" + this.settings.foregroundColor + ";background-color:" + this.settings.backgroundColor + ";display:none;position:absolute;top:0;left:0;z-index:1000;\\\">" + this.settings.content + "</div>\"));";
      scriptLines += "    $('#" + this.info.id + "_end').position({ my: 'center center', at: 'center center', of: $('#" + this.info.id + "') }).show('" + this.settings.effect + "');";
      scriptLines += "  }";
      scriptLines += "}";
      scriptLines += "</script>";
      //this.outputCode = this.outputCode + divLine + scriptLines;
      this.outputCode = this.outputCode + scriptLines;
    };

    this.applyPostRoll = function(inp) {
      this.rawInput = this.outputCode = inp;
      this.extractInfo();
      this.insertCallback();
      this.insertPostRollCode();

      return this.outputCode;
    };

    this.lastResult = function() {
      return this.outputCode;
    }
  }

  this.postRoller = new PostRoller();
}

var wistia = new Wistia();
