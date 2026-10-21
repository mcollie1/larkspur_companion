class User < ApplicationRecord
  has_many :role_assignments, dependent: :restrict_with_error
  has_many :roles, through: :role_assignments

  has_one :patient, dependent: :restrict_with_error

  has_many :caseload_assignments,
         foreign_key: :coordinator_id,
         inverse_of: :coordinator

  has_many :assigned_patients, through: :caseload_assignments, source: :patient

  has_many :caregiver_assignments, foreign_key: :caregiver_id, inverse_of: :caregiver

  has_many :cared_for_patients, through: :caregiver_assignments, source: :patient

  has_many :recorded_medication_logs,
          class_name: "MedicationLog",
          foreign_key: :recorded_by_id,
          inverse_of: :recorded_by

  has_many :authored_care_notes,
          class_name: "CareNote",
          foreign_key: :author_id,
          inverse_of: :author

  validates :first_name, :last_name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, length: { maximum: 200 }
end
