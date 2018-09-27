class AddSolutionToScenarios < ActiveRecord::Migration[5.1]
  def change
    add_column :scenarios, :solution_id, :integer
  end
end
