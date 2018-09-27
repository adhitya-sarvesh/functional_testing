class CreateScenarioSteps < ActiveRecord::Migration[5.1]
  def change
    create_table :scenario_steps do |t|
      t.string :scenario_id
      t.string :step_type
      t.text :step_value

      t.timestamps
    end
  end
end
