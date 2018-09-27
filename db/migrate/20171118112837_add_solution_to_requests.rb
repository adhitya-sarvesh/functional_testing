class AddSolutionToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :solution_id, :integer
  end
end
