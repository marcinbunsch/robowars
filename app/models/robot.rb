class Robot < ActiveRecord::Base
  attr_accessible :name, :code, :ready

  validates :name, :presence => true
  validates :code, :presence => true

  scope :ready, where(:ready => true)
end

