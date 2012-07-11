class AddReadyFlagToRobots < ActiveRecord::Migration
  def change
    add_column(:robots, :ready, :boolean, :default => false)
  end
end
