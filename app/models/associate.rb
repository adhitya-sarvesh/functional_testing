class Associate < ApplicationRecord
  has_many :scenarios
  has_many :requests
  has_and_belongs_to_many :solutions
  has_many :workflows

  validates_presence_of :name, :email
end
