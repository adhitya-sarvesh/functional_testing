class Workflow < ApplicationRecord
	has_many :scenarios_workflows, dependent: :destroy
	has_many :scenarios, through: :scenarios_workflows, dependent: :destroy
	accepts_nested_attributes_for :scenarios, allow_destroy: true 

	belongs_to :associate, class_name: 'Associate', foreign_key: :created_by
	belongs_to :creator, class_name: 'Associate', foreign_key: :created_by
	belongs_to :modifier, class_name: 'Associate', foreign_key: :updated_by, required: false

	validates :name, presence: true
	validates :name, uniqueness: true
end
