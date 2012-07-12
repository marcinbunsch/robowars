class Result < ActiveRecord::Base
  belongs_to :duel
  belongs_to :robot, :counter_cache => true
end
