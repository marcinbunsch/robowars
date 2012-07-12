/*
 *  Copyright © 2010 Ian Langworth
 *
 *  This file is part of JSRoboWar.
 *
 *  JSRoboWar is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  JSRoboWar is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with JSRoboWar.  If not, see <http://www.gnu.org/licenses/>.
 */

// TODO: Hardware Depot
// TODO: Game speed adjustment
// TODO: Integrated debugger

if (!window.$) alert('`$` object missing. jquery.js is required.');
if (!window._) alert('`_` object missing. underscore.js is required.');

$(document).ready(function() {

  // Navigation tabs ---------------------------------------------------------

  var current_section;

  function set_section(name) {
    $('#nav').attr('class', name);
    $('section#' + name).show();
    $('section#' + current_section).hide();
    current_section = name;
  };

 // $('#container > section').hide();
  set_section(document.location.hash.replace(/\W/g, '') || 'play');

  $('#nav li a').click(function() {
    var name = $(this).attr('href').substr(1);
    set_section(name);
    document.location.hash = name;
    window.scroll(0, 0);
    return false;
  });

  // Robot choices -----------------------------------------------------------

  var ROBOT_SLOTS = 4;
  var ROBOT_COLORS = ['#0ff', '#ff0', '#f99', '#0f0', '#f0f'];
  var ROBOT_CHOICES = [
    ['Development robots', [
      ['target-practice', 'Target Practice']
    ]],
    ['Tutorial robots', [
      ['corner-hopper', 'Corner Hopper'],
      ['dgt-with-probes', 'Defensive Gun Turret'],
      ['shape-changer', 'Shape Changer'],
      ['stationary', 'Stationary Bot'],
      ['wall-hugger', 'Wall-Hugger'],
      ['wall-seeker', 'Wall-Seeker'],
      ['wanderer', 'Wanderer'],
    ]],
    ['Mortal class', [
      ['arachnee', 'Arachnee'],
      ['archivist', 'Archivist'],
      ['existentialist', 'Existentialist'],
      ['ghost', 'Ghost'],
      ['invisible-stalker', 'Invisible Stalker'],
      ['locke', 'Lock v18'],
      ['pearl', 'Pearl'],
      ['silo-iv', 'Silo IV'],
      ['timbot-iv', 'Timbot IV'],
    ]],
    ['Titan class', [
      ['dark-knight-4', 'Dark Knight 4'],
      ['fluffy-3', 'Fluffy 3'],
      ['soul-deliverer-9x', 'Soul Deliverer 9x'],
      ['the-dead-parrot', 'The Dead Parrot'],
      ['zim', 'Zim'],
    ]],
  ];

  function get_robot_name(i) {
    var select = $('#choice' + i);
    return select.val() ? select.find(':selected').text() : 'Custom Robot ' + (i + 1);
  }

  function reveal_editor(i, errors) {
    var name = get_robot_name(i);
    $('#editor h2').text(name);
    if (errors) {
      alert('Error compiling ' + name + ":\n\n" + errors);
      $('#errors').show().text(errors);
    } else {
      $('#errors').hide().text(errors);
    }

    $('#editors textarea').slideUp();
    $('#editor').slideDown();
    $('#code' + i).slideDown();
  }

  _.each(_.range(ROBOT_SLOTS- 1), function(i) {  // Scope i correctly.

    // Create the drop-down menu.
    var select = $('<select/>').attr('id', 'choice' + i);
    select.append($('<option/>').text('Choose a robot...').attr('value', ''));
    for (var j = 0, group; group = ROBOT_CHOICES[j]; j++) {
      var optgroup = $('<optgroup/>').attr('label', group[0]);
      for (var k = 0, choice; choice = group[1][k]; k++) {
        optgroup.append($('<option/>').attr('value', choice[0]).text(choice[1]));
      }
      select.append(optgroup);
    }

    // Create the edit button.
    var edit_button = $('<button/>').text('Edit');

    // Add the menu and the edit button to the page.
    $('#choices ol').append($('<li/>').append(select, ' ', edit_button));

    // Create the robot code editor and add it to the page.
    var textarea = $('<textarea/>').attr('id', 'code' + i);
    textarea.hide();
    $('#editors').append(textarea);

    // Changing resets the bot choice to reflect "a custom bot."
    textarea.change(function() {
      select.val('');
      $('#editor h2').text(get_robot_name(i));
    });

    // Load robot code into the editor when a robot is selected.
    select.change(function() {
      var name = $(this).val();
      if (name) {
        var path = '/jsrobowar/robots/' + name + '.txt';
        textarea.val('(Loading ' + path + ')');
        textarea.attr('disabled', 'disabled');
        $.get(path, function(src) {
          textarea.val(src);
          textarea.attr('disabled', null);
        });
        // TODO: Hardware depot
      }
    });

    // Make the edit button show the editor.
    edit_button.click(function() {
      reveal_editor(i);
    });

    edit_button.hide();

  });

  // Hide the editor initially.
  $('#editor').hide();

  // Game initialization -----------------------------------------------------

  var game = new Game($('#arena')[0], $('#scoreboard')[0]);

  function load_robot(code, name, color) {
    var program = new Program();
    program.parse(code);
    if (program.errors) {
      alert(name + " failed to start\nReason:\n" +program.errors);
      // reveal_editor(i, program.errors);
      return;
    }

    var robot = new Robot(name, color, program);
    return robot;
  }
  function setup_game() {
    // Reset the robots and game state.
    game.clear();

    // Get tested robot code
    // Load each robot. Bail out if one doesn't compile.
    var tested_code = myCodeMirror.getValue();
    var robot_name = $('#robot_name').val();
    var robot = load_robot(tested_code, robot_name, ROBOT_COLORS[1]);
    game.add_robot(robot);
    _.each(_.range(ROBOT_SLOTS -1), function(i) {
      var code = $('#code' + i).val();

      var robot = load_robot(code, get_robot_name(i), ROBOT_COLORS[i]);
      game.add_robot(robot);
    });
  };

  // Play/pause button -------------------------------------------------------

  var show_start_button = function() {
    $('#start').show();
    $('#stop').hide();
  };

  $('#start').click(function(e) {
    e.preventDefault();
    setup_game();
    game.start(show_start_button);
    $(this).hide();
    $('#stop').show();
  });

  $('#stop').click(function(e) {
    e.preventDefault();
    game.stop();
    show_start_button();
  });

  show_start_button();

  // Sound-toggle button -----------------------------------------------------

  $('#sound').change(function() {
    SoundEffects.enable($(this).attr('checked'));
  }).change();

  // Auto-start demo mode ----------------------------------------------------

  $('#choice0').val('target-practice').change();
  $('#choice1').val('target-practice').change();
  $('#choice2').val('target-practice').change();

  //# _.delay(function() {$('#start').click()}, 600);

});
