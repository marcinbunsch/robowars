class User < ActiveRecord::Base
  attr_accessible :username, :avatar_url

  has_many :robots

end
