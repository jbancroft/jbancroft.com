var EasyDays = function() {
  this.inputs = {
    'service_type': 'load_only',
    'vehicle_size': '10',
    'percent_full': '100',
    'elevator': false,
    'floors': '0',
    'truck_distance': '50',
    'disassembly': '0',
    'chowder': '0',
    'movers': '2'
  };

  this.calculateTime = function() {
    var time = 30;

    if (this.inputs.vehicle_size == '10') {
      time = 30;
    } else if (this.inputs.vehicle_size == '14') {
      time = 60;
    } else if (this.inputs.vehicle_size == '17') {
      time = 90;
    } else if (this.inputs.vehicle_size == '24') {
      time = 240;
    } else if (this.inputs.vehicle_size == '26') {
      time = 270;
    }

    var twentyPercent = 0.20 * time;

    if (this.inputs.elevator == false) {
      time += twentyPercent * parseInt(this.inputs.floors);
    } else {
      time += time * 0.30;
    }

    time += ((parseInt(this.inputs.truck_distance) / 50) - 1) * twentyPercent;

    time += parseInt(this.inputs.disassembly) * 5;

    time += parseInt(this.inputs.chowder) * 0.5;

    time = time * (parseInt(this.inputs.percent_full) / 100);

    var thirtyPercent = 0.30 * time;
    time -= thirtyPercent * (parseInt(this.inputs.movers) - 2);

    if (this.inputs.service_type == 'unload_only') {
      time = time * 0.75;
    } else if (this.inputs.service_type == 'load_unload') {
      time = time + (time * 0.75);
    }

    return time;
  };
};

var easyDays = new EasyDays();

$(document).ready(function () {
  $('[name="service_type"]').change(function() {
    easyDays.inputs.service_type = $('[name="service_type"]:checked').val();
  });

  $('#vehicle_size').change(function() {
    easyDays.inputs.vehicle_size = $('#vehicle_size').val();
  });

  $('#percent_full').change(function() {
    easyDays.inputs.percent_full = $('#percent_full').val();
  });

  $('#elevator').change(function() {
    easyDays.inputs.elevator = $('#elevator').is(':checked');
  });

  $('#floors').change(function() {
    easyDays.inputs.floors = $('#floors').val();
  });

  $('#truck_distance').change(function() {
    easyDays.inputs.truck_distance = $('#truck_distance').val();
  });

  $('#disassembly').change(function() {
    easyDays.inputs.disassembly = $('#disassembly').val();
  });

  $('#chowder').change(function() {
    easyDays.inputs.chowder = $('#chowder').val();
  });

  $('#movers').change(function() {
    easyDays.inputs.movers = $('#movers').val();
  });

  $('[name="service_type"], #vehicle_size, #percent_full, #elevator, #floors, #truck_distance, #disassembly, #chowder, #movers').change(function() {
    var time = easyDays.calculateTime();
    $('.result').fadeOut(500, function() {
      $('.result').html(Math.round(time).toString() + ' minutes').show('blind', {}, 500);
    });
  });
});
