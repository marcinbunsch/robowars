class Robot < ActiveRecord::Base
  attr_accessible :name, :code

  validates :name, :presence => true
  validates :code, :presence => true

end

