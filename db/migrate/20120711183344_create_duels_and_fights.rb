class CreateDuelsAndFights < ActiveRecord::Migration
  def up
    create_table :duels do |t|
      t.timestamps
    end

    create_table :results do |t|
      t.column :duel_id, :integer
      t.column :robot_id, :integer
      t.column :rank, :integer
      t.timestamps
    end
  end

  def down
    drop_table(:duels)
    drop_table(:results)
  end
end
