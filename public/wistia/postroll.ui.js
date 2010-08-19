$(document).ready(function() {
  $('#fcolor').smallColorPicker();
  $('#bcolor').smallColorPicker({ defaultColor: "#FFFFFF" });

  $('#generate_postroll').click(function() {
    if ($('#raw_input').val() == null || $('#raw_input').val() == "") {
      $('<div>Please specify some previously generated embed code to start!</div>').dialog();
    } else {
    $('#results').fadeOut();
    $.extend(wistia.postRoller.settings, {
      backgroundColor: $('#bcolor').val(),
      content: $('#content').val(),
      effect: $('#effect').val(),
      foregroundColor: $('#fcolor').val()
    });

    var outputCode = wistia.postRoller.applyPostRoll($('#raw_input').val());
    $(document).scrollTop(0);
    $('#output_code').val(outputCode);
    $('#results').stop().fadeIn();
    $('#output_code').focus().select();
  }
  });

  $('#test_button').click(function() {
    var h = parseInt(wistia.postRoller.info.height);
    var w = parseInt(wistia.postRoller.info.width);
    $('<div id="testing"></div>').html(wistia.postRoller.lastResult()).height(h).width(w).dialog({
      title: 'Preview',
      height: 'auto',
      width: 'auto',
      minHeight: h,
      minWidth: w,
      zIndex: 10,
      resizable: false,
      stack: false,
      close: function() {
        $('#' + wistia.postRoller.info.id + '_end').remove();
        $('.ui-dialog').remove();
      }
    });
  });
});
