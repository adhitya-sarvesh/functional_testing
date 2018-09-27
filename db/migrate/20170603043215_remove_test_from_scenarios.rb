class RemoveTestFromScenarios < ActiveRecord::Migration[5.1]
  def change
    remove_column :scenarios, :test
  end
end
