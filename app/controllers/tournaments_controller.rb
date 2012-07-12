class TournamentsController < ApplicationController
  def show
    @robots = Robot.draw(4)
  end
end
