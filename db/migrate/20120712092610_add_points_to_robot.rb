class AddPointsToRobot < ActiveRecord::Migration
  def change
    add_column :robots, :points, :integer, :default => 0
  end
end
