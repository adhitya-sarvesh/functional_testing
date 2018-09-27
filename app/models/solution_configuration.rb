class SolutionConfiguration < ApplicationRecord
  belongs_to :solution

  validates :key, :value, presence: true

  before_save :set_solution_configuration

  # cleanup before configurations, workaround for merge
  def set_solution_configuration
    solution.solution_configurations.destroy_all
  end
end
