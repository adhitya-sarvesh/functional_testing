class ScenariosWorkflow < ApplicationRecord
  belongs_to :scenario
  belongs_to :workflow
end
