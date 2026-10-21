class Role < ApplicationRecord
  PATIENT_ROLE = "patient".freeze
  COORDINATOR_ROLE = "coordinator".freeze
  CAREGIVER_ROLE = "caregiver".freeze

  ROLE_TYPES = [ PATIENT_ROLE, COORDINATOR_ROLE, CAREGIVER_ROLE ].freeze

  has_many :role_assignments, dependent: :restrict_with_error
  has_many :users, through: :role_assignments

  validates :name, presence: true, uniqueness: true, inclusion: { in: ROLE_TYPES }
end
