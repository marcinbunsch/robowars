class Duel < ActiveRecord::Base
  has_many :results
  has_many :robots, :through => :results

  def self.from_results(results)
    duel = self.create
    results.each do |robot_id, place|
      duel.results.create(:robot_id => robot_id, :rank => place)
    end
  end

end
