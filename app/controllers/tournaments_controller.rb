class TournamentsController < ApplicationController
  before_filter :require_staff
  def show
    @robots = Robot.draw(4)
  end
end
