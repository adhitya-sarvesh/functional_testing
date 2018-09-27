class Parameter < ApplicationRecord
  belongs_to :scenario
  validates :key, presence: true
end
