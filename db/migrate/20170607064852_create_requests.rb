class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests, id: false do |t|
      t.string :id, primary_key: true
      t.text :tags
      t.string :status
      t.text :created_by

      t.timestamps
    end
  end
end
