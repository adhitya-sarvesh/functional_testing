class CreateScenariosWorkflows < ActiveRecord::Migration[5.1]
  def change
    create_table :scenarios_workflows do |t|
	  t.integer :scenario_id 
	  t.integer :workflow_id
	  t.belongs_to :scenario, index: true
	  t.belongs_to :workflow, index: true      
    end
  end
end
