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

var loadRobot = function(bot, color) {
  var program = new Program();
  program.parse(bot.code);
  var robot = new Robot(bot.name, color, program);
  robot.id = bot.id;
  robot.color = color;
  return robot;
};

var updateRobotStatus = function(robot) {
  var robot_el = $('#robot-' + robot.id);
  var status_el = $('#robot-' + robot.id + ' .status');
  // status_el.text("Damage: "+robot.damage + " Energy: " + robot.energy + " Status: " + robot.is_running);
  if (!robot.is_running && !robot.marked_as_dead) {
    robot.marked_as_dead = true;
    robot.damage = 0;
    robot.energy = 0;
    robot_el.css({ 'opacity': 0.5 })
  }
  robot_el.find('.color').html(robot.place);
  status_el.find('.energy').css({width: (robot.energy / 150) * 100 + '%'})
  status_el.find('.damage').css({width: (robot.damage / 100) * 100 + '%'})
  robot_el.find('.color').css({'background-color': robot.color });
};

var CurrentGame;
$(function() {
  var COLORS = ['#0ff', '#ff0', '#f99', '#0f0', '#f0f'];
  var robots = JSON.parse($('#robots').text());
  if (robots.length < 4) {
    // less than 4, should we fight?
  }
  var game = new Game($('#arena')[0], $('#scoreboard')[0]);

  _.each(robots, function(bot) {
    var robot = loadRobot(bot, COLORS.shift());
    game.add_robot(robot);
    updateRobotStatus(robot)
  });

  game.onUpdate = function(data) {
    $('.arena h1 span').text(data.chronons);
    _.each(data.robots, updateRobotStatus);
  };

  game.onGameOver = function(results) {
    var data = {};
    _.each(results, function(result) {
       if (result.place === 0) {
         result.place = 1;
       }
      var robot_el = $('#robot-' + result.robot_id);
      robot_el.find('.color').html(result.place);
      data[result.robot_id] = result.place;
    });
    $.post('/results', { results: data }).success(function(res) {
      var next_countdown = new Countdown(5);
      next_countdown.onTick = function() {
        var text = "Next battle in " + this.seconds + '...';
        $('.next .countdown').html(text);
      };
      next_countdown.onDone = function() {
        $('.next .countdown').html('');
        window.location.reload();
      };
      next_countdown.start();
    }).error(function() {
      alert('Error saving results');
    });
  };

  game.onError = function(error) {
    $('.errors').append('<div class="alert alert-danger"><b>'+error.replace("\n", "<br>")+"</b></div>");
  }

  CurrentGame = game;

  $('.arena .battle').click(function() {
    CurrentGame.start();
    $(this).hide();
  });

  var countdown = new Countdown(3);
  countdown.onTick = function() {
    var text = "Battle will begin in " + this.seconds + '...';
    $('.next .countdown').html(text);
  };
  countdown.onDone = function() {
    $('.next .countdown').html('');
    CurrentGame.start();
  };
  countdown.start();
  $('.arena a.next').hide();
  $('.arena a.battle').hide();
  SoundEffects.enable(true);
});

function Countdown(seconds) {
  var self = this;
  var interval;
  this.seconds = seconds;
  this.onTick = function() {};
  this.onDone = function() {};
  var check = function() {
    if (self.seconds == 0) {
      clearInterval(interval);
      self.onDone();
    } else {
      self.onTick();
      self.seconds--;
    }
  };
  this.start = function() {
    check();
    interval = setInterval(check, 1000);
  };
}

