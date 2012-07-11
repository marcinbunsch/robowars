class TournamentsController < ApplicationController
  def show
    @duels = []
    d = Duel.new
    d.robots << Robot.first
    d.robots << Robot.first
    d.robots << Robot.first
    d.robots << Robot.first
    @duels << d
  end
end