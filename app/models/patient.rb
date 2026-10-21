class Patient < ApplicationRecord
  ACTIVE_STATUS = "active".freeze
  INACTIVE_STATUS = "inactive".freeze
  STATUS_TYPES = [ ACTIVE_STATUS, INACTIVE_STATUS ].freeze

  belongs_to :user, optional: true

  has_many :caseload_assignments, dependent: :restrict_with_error
  has_many :coordinators, through: :caseload_assignments, source: :coordinator

  has_many :caregiver_assignments, dependent: :restrict_with_error

  has_many :caregivers, through: :caregiver_assignments, source: :caregiver

  has_many :medications, dependent: :restrict_with_error
  has_many :care_notes, dependent: :restrict_with_error

  validates :first_name, :last_name, presence: true, length: { maximum: 100 }
  validates :status, inclusion: { in: STATUS_TYPES }
end
