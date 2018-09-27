class AddCreatorModifierToScenarios < ActiveRecord::Migration[5.1]
  def change
    add_column :scenarios, :created_by, :string
    add_column :scenarios, :updated_by, :string
  end
end
