class Robot < ActiveRecord::Base
  attr_accessible :name, :code, :ready

  validates :name, :presence => true
  validates :code, :presence => true

  has_many :fights
  has_many :duels, :through => :fights
  belongs_to :user

  scope :ready, where(:ready => true)
end

