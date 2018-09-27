class Request < ApplicationRecord
  after_initialize :generate_uuid

  belongs_to :associate, class_name: 'Associate', foreign_key: :created_by
  belongs_to :creator, class_name: 'Associate', foreign_key: :created_by
  belongs_to :solution

  validates :tags, presence: true

  # TODO: validate tags for scenario_ids

  def progress!
    update!(status: 'In Progress')
  end

  def complete!
    update!(status: 'Complete')
  end

  def progress?
    status == 'In Progress'
  end

  def complete?
    status == 'Complete'
  end

  protected

    def generate_uuid
      self.id = SecureRandom.uuid unless self.id
    end
end
