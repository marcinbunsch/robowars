class Question < ActiveRecord::Base
  attr_accessible :answer, :question, :user_id
end
