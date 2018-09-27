class AddDescriptionToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :description, :string, limit: 500
  end
end
