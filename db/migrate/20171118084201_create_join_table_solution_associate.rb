class CreateJoinTableSolutionAssociate < ActiveRecord::Migration[5.1]
  def change
    create_join_table :solutions, :associates do |t|
      t.string :associate_id
      t.index [:solution_id, :associate_id]
      t.index [:associate_id, :solution_id]
    end
  end
end
