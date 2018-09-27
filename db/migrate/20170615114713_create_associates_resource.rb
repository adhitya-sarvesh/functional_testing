class CreateAssociatesResource < ActiveRecord::Migration[5.1]
  def change
    create_table :associates, id: false do |t|
      t.string :id, primary_key: true
      t.string :name
      t.string :email
    end
  end
end
