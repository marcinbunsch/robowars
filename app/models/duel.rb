class Duel < ActiveRecord::Base
  attr_accessible :name, :code, :ready
  has_many :results
  has_many :robots, :through => :results

end
