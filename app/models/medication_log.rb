class MedicationLog < ApplicationRecord
  TAKEN_STATUS = "taken".freeze
  MISSED_STATUS = "missed".freeze

  STATUSES = [ TAKEN_STATUS, MISSED_STATUS ].freeze

  belongs_to :medication
  belongs_to :recorded_by, class_name: "User"

  validates :status, inclusion: { in: STATUSES }
  validates :scheduled_at, :recorded_at, presence: true

  validates :scheduled_at, uniqueness: {
    scope: :medication_id
  }

  validates :note, length: { maximum: 50000 }, allow_blank: true
end
