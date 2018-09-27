class CreateSolutionConfigurations < ActiveRecord::Migration[5.1]
  def change
    create_table :solution_configurations do |t|
      t.integer :solution_id
      t.text :key
      t.text :value
    end
  end
end
