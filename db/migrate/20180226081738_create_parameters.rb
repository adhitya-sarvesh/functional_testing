class CreateParameters < ActiveRecord::Migration[5.1]
  def change
    create_table :parameters do |t|
      t.string :key
      t.string :value
      t.references :scenario, foreign_key: true

      t.timestamps
    end
  end
end
