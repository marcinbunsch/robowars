class Robot < ActiveRecord::Base
  attr_accessible :name, :code, :ready

  validates :name, :presence => true
  validates :code, :presence => true

  has_many :results
  has_many :duels, :through => :results
  belongs_to :user

  scope :ready, where(:ready => true)
  scope :least_played, order('results_count ASC')

  def self.draw(amount)
    self.simple_draw(amount)
  end

  def self.simple_draw(amount)
    self.ready.least_played.limit(4)
  end

  # Draw proposed by Yoda (Mateusz Juda)
  # It's supposed to be more fair
  # It picks 2 from 1/4 that played the least
  # Then it picks to from the remainder
  def self.yoda_draw(amount)
    tier_size = amount/2
    all_robot_count = self.ready.count
    offset = (all_robot_count / 4.0).floor
    lowest_tier = self.ready.limit(offset).least_played
    lowest_tier.sample(tier_size)
    top_tier = self.ready.offset(offset).least_played
    top_tier.sample(tier_size)
    lowest_tier + top_tier
  end

end

