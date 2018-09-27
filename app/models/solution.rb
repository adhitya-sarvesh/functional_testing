class Solution < ApplicationRecord
  has_and_belongs_to_many :associates
  has_many :solution_configurations
  belongs_to :creator, class_name: 'Associate', foreign_key: :created_by
  belongs_to :modifier, class_name: 'Associate', foreign_key: :updated_by, required: false

  accepts_nested_attributes_for :solution_configurations

  validates :name, presence: true, uniqueness: true

  def member?(associate_id)
    Associate.find_by(id: associate_id).in? associates
  end

  def configuration_by_key(c_key)
    solution_configurations.find_by(key: c_key).value rescue ''
  end
end
