class AddResultsCountToRobot < ActiveRecord::Migration
  def change
    add_column :robots, :results_count, :integer, :default => 0
  end
end
