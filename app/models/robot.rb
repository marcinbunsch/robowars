class Robot < ActiveRecord::Base
  attr_accessible :name, :code, :ready

  validates :name, :presence => true
  validates :code, :presence => true

  has_many :results, :counter_cache => true
  has_many :duels, :through => :results
  belongs_to :user

  scope :ready, where(:ready => true)

  def self.draw(amount)

  end

end

