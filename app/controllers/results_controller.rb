class ResultsController < ApplicationController

  def create
    Duel.from_results(params[:results])

    render :json => :ok
  end
end

