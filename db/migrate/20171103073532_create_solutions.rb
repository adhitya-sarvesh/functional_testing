class CreateSolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :solutions do |t|
      t.string :name
      t.string :created_by
      t.string :updated_by
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
