class LeaderboardsController < ApplicationController
  def show
    @scores = Robot.leaderboard
  end
end