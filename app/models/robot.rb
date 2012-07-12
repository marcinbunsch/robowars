class Robot < ActiveRecord::Base
  attr_accessible :name, :code

  validates :name, :presence => true
  validates :code, :presence => true

  has_many :results
  has_many :duels, :through => :results
  belongs_to :user

  scope :ready, where(:ready => true)
  scope :least_played, order('results_count ASC')

  # how many points for given rank in a match
  POINTS_MAP = {'1' => 4, '2' => 3, '3' => 2, '4' => 0}

  def self.draw(amount)
    self.yoda_draw(amount)
  end

  def self.simple_draw(amount)
    self.ready.least_played.limit(4)
  end

  def stats
    blank_slate = {1 => 0, 2 => 0, 3 => 0, 4 => 0}
    stats = results.group('rank').count
    stats.empty? ? blank_slate : stats
  end

  def score
    calculated_score = 0
    stats.each do |bucket,count|
      calculated_score += (count || 0) * (POINTS_MAP[bucket.to_s] || 0)
      calculated_score += (count * POINTS_MAP[bucket.to_s])
    end
    calculated_score
  end

  # Draw proposed by Yoda (Mateusz Juda)
  # It's supposed to be more fair
  # It picks 2 from 1/4 that played the least
  # Then it picks to from the remainder
  def self.yoda_draw(amount)
    tier_size = amount/2
    all_robot_count = self.ready.count
    offset = (all_robot_count / 4.0).ceil
    lowest_tier = self.ready.limit(offset).least_played
    lowest_tier = lowest_tier.sample(tier_size)
    top_tier = self.ready.offset(offset).least_played
    top_tier = top_tier.sample(tier_size)
    lowest_tier + top_tier
  end

  def self.leaderboard
    scores = Robot.all.map do |robot|
      current_stats = robot.stats
      {:robot_id => robot.id,
       :robot_name => robot.name,
       :matches => robot.results.count,
       :first => robot.stats[1].to_i,
       :second => robot.stats[2].to_i,
       :third => robot.stats[3].to_i,
       :fourth => robot.stats[4].to_i,
       :score => robot.score,
       :avatar_url => robot.user.avatar_url,
       :constructor => robot.user.username}
    end
    scores.sort {|a,b| a[:score] <=> b[:score]}.reverse
  end
end

