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

var gui = {};
gui.settings = {};
gui.current_section;

gui.set_section = function(name) {
  $('#nav').attr('class', name);
  $('section#' + name).show();
  $('section#' + gui.current_section).hide();
  gui.current_section = name;
};
gui.ready_robots = function() {
  var choices = ['Development robots', [
    ['target-practice', 'Target Practice']
  ]];
  return choices;
};

gui.load_settings = function() {
  if ($("#robot_slots").length && $("#robot_slots").val()) {
      gui.settings.robot_slots = parseInt($("#robot_slots").val());
    } else {
    gui.settings.robot_slots = 2;
    }
};

gui.robot_colors = ['#0ff', '#ff0', '#f99', '#0f0', '#f0f'];

gui.load_robot = function(code, name, color) {
  var program = new Program();
  program.parse(code);
//  if (program.errors) {
//    alert(name + " failed to start\nReason:\n" +program.errors);
//    // reveal_editor(i, program.errors);
//    return;
//  }

  var robot = new Robot(name, color, program);
  return robot;
};

gui.setup_game = function() {
  gui.load_settings();
  // Reset the robots and game state.
  gui.game.clear();
  gui.game_results = {};
  $.get('/robots.json', function(robots) {
    _.each(_.range(gui.settings.robot_slots), function(i) {
      var robot = robots[i];
      gui.game_results[robot.name] = {robot_id:robot.id, place:0};
      var code = robot.code.replace(/#/gm,'');
      var robot = gui.load_robot(code, robot.name, gui.robot_colors[i]);
      gui.game.add_robot(robot);
    });
  });

};

$(document).ready(function() {
  gui.game = new Game($('#arena')[0], $('#scoreboard')[0]);
  $("#draw").on('click', gui.setup_game);

  gui.set_section(document.location.hash.replace(/\W/g, '') || 'play');

  $('#nav li a').click(function() {
    var name = $(this).attr('href').substr(1);
    gui.set_section(name);
    document.location.hash = name;
    window.scroll(0, 0);
    return false;
  });

  // Hide the editor initially.
  $('#editor').hide();

  var show_start_button = function() {
    $('#start').show();
    $('#stop').hide();
  };

  $('#start').click(function(e) {
    e.preventDefault();
    gui.game.start(show_start_button);
    $(this).hide();
    $('#stop').show();
  });

  $('#stop').click(function(e) {
    e.preventDefault();
    gui.game.stop();
    show_start_button();
  });

  show_start_button();

  // Sound-toggle button -----------------------------------------------------

  $('#sound').change(function() {
    SoundEffects.enable($(this).attr('checked'));
  }).change();


  //# _.delay(function() {$('#start').click()}, 600);

});
