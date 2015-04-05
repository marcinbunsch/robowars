class TutorialController < ApplicationController
  skip_before_filter :authenticate_user
  before_filter :find_user
  def index
  end
end
