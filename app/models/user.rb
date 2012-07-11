class User < ActiveRecord::Base
  attr_accessible :username, :avatar_url, :staff

  has_many :robots

end
