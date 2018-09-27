class AddDescriptionToScenarios < ActiveRecord::Migration[5.1]
  def change
    add_column :scenarios, :description, :string, limit: 300
  end
end
